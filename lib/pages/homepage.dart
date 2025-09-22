import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:http/http.dart' as http;
import 'package:image/image.dart' as img;
import '../widgets/custom_appbar.dart';
import '../widgets/custom_navbar.dart';
import '../styles/homepagestyle.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  CameraController? _cameraController;
  bool _isCameraInitialized = false;
  bool _isCameraOn = false;
  bool _isSendingFrame = false;

  String? _prediction;
  String _phrase = "";

  // Hold-time tracking
  String? _lastStablePrediction;
  DateTime? _predictionStartTime;
  final Duration _holdTime = const Duration(milliseconds: 1200); // ~1.2 sec

  CameraDescription? _currentCamera;
  List<CameraDescription>? _cameras;

  @override
  void initState() {
    super.initState();
    _initCameras();
  }

  @override
  void dispose() {
    _cameraController?.stopImageStream();
    _cameraController?.dispose();
    super.dispose();
  }

  Future<void> _initCameras() async {
    try {
      _cameras = await availableCameras();
      _currentCamera = _cameras!.firstWhere(
        (cam) => cam.lensDirection == CameraLensDirection.front,
        orElse: () => _cameras!.first,
      );
    } catch (e) {
      debugPrint("Camera init error: $e");
    }
  }

  Future<void> _initCamera() async {
    if (_currentCamera == null) return;

    await _cameraController?.stopImageStream();
    await _cameraController?.dispose();

    _cameraController = CameraController(
      _currentCamera!,
      ResolutionPreset.high,
      enableAudio: false,
      imageFormatGroup: ImageFormatGroup.yuv420,
    );

    try {
      await _cameraController!.initialize();
    } catch (e) {
      debugPrint("Camera initialize failed: $e");
      return;
    }

    if (!mounted) return;

    setState(() {
      _isCameraInitialized = true;
      _isCameraOn = true;
    });

    _cameraController!.startImageStream((image) => _processCameraImage(image));
  }

  Future<void> _switchCamera() async {
    if (_cameras == null || _cameras!.length < 2) return;
    final old = _cameraController;

    final lens = _currentCamera!.lensDirection;
    _currentCamera = _cameras!.firstWhere(
      (c) => c.lensDirection != lens,
      orElse: () => _cameras!.first,
    );

    setState(() {
      _isCameraInitialized = false;
      _prediction = null;
    });

    await old?.stopImageStream();
    await old?.dispose();
    await Future.delayed(const Duration(milliseconds: 120));
    await _initCamera();
  }

  Future<String?> predictASL(Uint8List jpegBytes) async {
    final url = Uri.parse('http://192.168.1.88:5000/predict'); // your backend IP
    final base64Image = base64Encode(jpegBytes);

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'image': base64Image}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['letter']?.toString(); // ✅ matches backend
      } else {
        debugPrint('Server error: ${response.statusCode} ${response.body}');
        return null;
      }
    } catch (e) {
      debugPrint('Request error: $e');
      return null;
    }
  }

  void _processCameraImage(CameraImage image) async {
    if (_isSendingFrame) return;
    if (_cameraController == null || !_isCameraInitialized) return;

    _isSendingFrame = true;
    try {
      final jpeg = _convertYUV420ToJpeg(image, _cameraController!);
      final pred = await predictASL(jpeg);

      if (mounted && pred != null && pred != "None") {
        _handleStablePrediction(pred);
      } else {
        setState(() {
          _prediction = null;
          _lastStablePrediction = null;
          _predictionStartTime = null;
        });
      }
    } catch (e) {
      debugPrint('Frame processing error: $e');
    } finally {
      _isSendingFrame = false;
    }
  }

  // ✅ Stable hold-time logic with SPACE + DEL handling
  void _handleStablePrediction(String pred) {
    if (_lastStablePrediction != pred) {
      _lastStablePrediction = pred;
      _predictionStartTime = DateTime.now();
    } else {
      if (_predictionStartTime != null &&
          DateTime.now().difference(_predictionStartTime!) >= _holdTime) {
        setState(() {
          if (pred.toLowerCase() == "space") {
            _phrase += " ";
          } else if (pred.toLowerCase() == "del") {
            if (_phrase.isNotEmpty) {
              _phrase = _phrase.substring(0, _phrase.length - 1);
            }
          } else {
            _phrase += pred;
          }

          _prediction = pred; // show on screen
          _lastStablePrediction = null; // reset for next
          _predictionStartTime = null;
        });
      }
    }
  }

  Uint8List _convertYUV420ToJpeg(CameraImage image, CameraController controller) {
    final int width = image.width;
    final int height = image.height;
    final img.Image imgBuffer = img.Image(width: width, height: height);

    final Plane yPlane = image.planes[0];
    final Plane uPlane = image.planes[1];
    final Plane vPlane = image.planes[2];

    final Uint8List yBytes = yPlane.bytes;
    final Uint8List uBytes = uPlane.bytes;
    final Uint8List vBytes = vPlane.bytes;

    final int yRowStride = yPlane.bytesPerRow;
    final int uvRowStride = uPlane.bytesPerRow;
    final int uvPixelStride = uPlane.bytesPerPixel ?? 1;

    for (int y = 0; y < height; y++) {
      final int yRow = y * yRowStride;
      final int uvRow = (y >> 1) * uvRowStride;
      for (int x = 0; x < width; x++) {
        final int yIndex = yRow + x;
        final int uvIndex = uvRow + (x >> 1) * uvPixelStride;

        final int yp = yBytes[yIndex] & 0xff;
        final int up = uBytes[uvIndex] & 0xff;
        final int vp = vBytes[uvIndex] & 0xff;

        int r = (yp + 1.402 * (vp - 128)).toInt();
        int g = (yp - 0.344136 * (up - 128) - 0.714136 * (vp - 128)).toInt();
        int b = (yp + 1.772 * (up - 128)).toInt();

        r = r.clamp(0, 255);
        g = g.clamp(0, 255);
        b = b.clamp(0, 255);

        imgBuffer.setPixelRgba(x, y, r, g, b, 255);
      }
    }

    // ✅ Keep orientation + flip for front camera
    img.Image fixed = imgBuffer;
    final int sensorOrientation = controller.description.sensorOrientation;
    if (sensorOrientation != 0) {
      fixed = img.copyRotate(fixed, angle: sensorOrientation);
    }
    if (controller.description.lensDirection == CameraLensDirection.front) {
      fixed = img.flipHorizontal(fixed);
    }

    final List<int> jpg = img.encodeJpg(fixed, quality: 80);
    return Uint8List.fromList(jpg);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HomeColors.background,
      appBar: const CustomAppBar(username: "Cuti E. Patuti"),
      body: _isCameraOn
          ? Stack(
              children: [
                // ✅ full screen camera preview
                Positioned.fill(
                  child: _isCameraInitialized
                      ? FittedBox(
                          fit: BoxFit.cover,
                          child: SizedBox(
                            width: _cameraController!.value.previewSize?.height ??
                                MediaQuery.of(context).size.width,
                            height: _cameraController!.value.previewSize?.width ??
                                MediaQuery.of(context).size.height,
                            child: CameraPreview(_cameraController!),
                          ),
                        )
                      : const Center(child: CircularProgressIndicator()),
                ),
                if (_prediction != null)
                  Positioned(
                    top: 20,
                    left: 20,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      color: Colors.black45,
                      child: Text(
                        _prediction!,
                        style: const TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          color: Colors.greenAccent,
                        ),
                      ),
                    ),
                  ),
                if (_phrase.isNotEmpty)
                  Positioned(
                    top: 80,
                    left: 20,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      color: Colors.black54,
                      child: Text(
                        _phrase,
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                // Phrase editing buttons
                Positioned(
                  bottom: 80,
                  left: 0,
                  right: 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () => setState(() => _phrase += " "),
                        child: const Text("Space"),
                      ),
                      const SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: () => setState(() => _phrase = ""),
                        child: const Text("Clear"),
                      ),
                      const SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: () {
                          if (_phrase.isNotEmpty) {
                            setState(() =>
                                _phrase = _phrase.substring(0, _phrase.length - 1));
                          }
                        },
                        child: const Text("⌫"),
                      ),
                    ],
                  ),
                ),
                // Camera switch
                Positioned(
                  bottom: 20,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: FloatingActionButton(
                      backgroundColor: Colors.white,
                      onPressed: _switchCamera,
                      child: const Icon(Icons.cameraswitch, color: Colors.black),
                    ),
                  ),
                ),
                // Close button
                Positioned(
                  top: 40,
                  right: 16,
                  child: FloatingActionButton(
                    backgroundColor: Colors.white,
                    mini: true,
                    onPressed: () async {
                      await _cameraController?.stopImageStream();
                      await _cameraController?.dispose();
                      _cameraController = null;
                      setState(() {
                        _isCameraOn = false;
                        _isCameraInitialized = false;
                        _prediction = null;
                        _phrase = "";
                      });
                    },
                    child: const Icon(Icons.close, color: Colors.black),
                  ),
                ),
              ],
            )
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      Container(
                        width: double.infinity,
                        alignment: Alignment.center,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: const Text("ASL CAMERA",
                            style: HomeTextStyles.cameraTitle),
                      ),
                      Container(
                        width: double.infinity,
                        height: 220,
                        decoration: HomeDecorations.cameraContainer,
                        child: Container(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 10),
                          decoration: HomeDecorations.cameraOverlayBox,
                          child: const Center(
                            child: Icon(Icons.photo_camera_outlined,
                                size: 60, color: Colors.white70),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        style: HomeButtons.cameraToggleButton,
                        onPressed: _initCamera,
                        child: const Text("Start",
                            style: HomeTextStyles.buttonText),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Container(
                    width: double.infinity,
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Tips for you:", style: HomeTextStyles.tipTitle),
                        SizedBox(height: 4),
                        Text("\"Try learning 5 new letters today!\" [Learn More]",
                            style: HomeTextStyles.tipSubtitle),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Recent Transitions",
                            style: HomeTextStyles.sectionTitle),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, "/history");
                          },
                          child: const Text("View all",
                              style: HomeTextStyles.sectionAction),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      children: List.generate(3, (index) {
                        return Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          margin: const EdgeInsets.only(bottom: 10),
                          child: const ListTile(
                            leading: Icon(Icons.front_hand,
                                size: 30, color: Colors.brown),
                            title: Text("[A]"),
                            subtitle: Text("Aug 21, 2025 - 09:42 PM"),
                          ),
                        );
                      }),
                    ),
                  ),
                ],
              ),
            ),
      bottomNavigationBar: const CustomNavBar(currentIndex: 0),
    );
  }
}
