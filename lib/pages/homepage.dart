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
  bool _isSendingFrame = false; // throttle
  String? _prediction;

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

    // Dispose existing (if any) safely
    await _cameraController?.stopImageStream();
    await _cameraController?.dispose();

    _cameraController = CameraController(
      _currentCamera!,
      ResolutionPreset.medium, // medium: better fps, adjust as needed
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

    // start streaming frames
    _cameraController!.startImageStream((image) => _processCameraImage(image));
  }

  Future<void> _switchCamera() async {
    if (_cameras == null || _cameras!.length < 2) return;
    final old = _cameraController;

    // pick other camera
    final lens = _currentCamera!.lensDirection;
    _currentCamera = _cameras!.firstWhere(
      (c) => c.lensDirection != lens,
      orElse: () => _cameras!.first,
    );

    setState(() {
      _isCameraInitialized = false;
      _prediction = null;
    });

    // stop + dispose old
    await old?.stopImageStream();
    await old?.dispose();

    // small delay to avoid device disconnects
    await Future.delayed(const Duration(milliseconds: 120));

    // init new
    await _initCamera();
  }

  Future<String?> predictASL(Uint8List jpegBytes) async {
    final url = Uri.parse('http://192.168.1.66:5000/predict'); // YOUR SERVER IP
    final base64Image = base64Encode(jpegBytes);

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'image': base64Image}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['prediction']?.toString();
      } else {
        debugPrint('Server error: ${response.statusCode} ${response.body}');
        return null;
      }
    } catch (e) {
      debugPrint('Request error: $e');
      return null;
    }
  }

  // Main streaming callback
  void _processCameraImage(CameraImage image) async {
    // throttle: only one in-flight frame at a time
    if (_isSendingFrame) return;
    if (_cameraController == null || !_isCameraInitialized) return;

    _isSendingFrame = true;
    try {
      final jpeg = _convertYUV420ToJpeg(image, _cameraController!);
      // optional: save jpeg to disk for debugging (disabled by default)
      // final f = await getTemporaryDirectory();
      // File('${f.path}/frame.jpg').writeAsBytesSync(jpeg);

      final pred = await predictASL(jpeg);
      if (mounted && pred != null) {
        setState(() {
          _prediction = pred;
        });
      }
    } catch (e) {
      debugPrint('Frame processing error: $e');
    } finally {
      _isSendingFrame = false;
    }
  }

  /// Convert CameraImage (YUV420) to a JPEG bytes array.
  /// Handles pixelStride/rowStride correctly and rotates/mirrors using controller orientation.
  Uint8List _convertYUV420ToJpeg(CameraImage image, CameraController controller) {
    final int width = image.width;
    final int height = image.height;

    // create empty Image from package:image
    final img.Image imgBuffer = img.Image(width: width, height: height);

    // plane data
    final Plane yPlane = image.planes[0];
    final Plane uPlane = image.planes[1];
    final Plane vPlane = image.planes[2];

    final Uint8List yBytes = yPlane.bytes;
    final Uint8List uBytes = uPlane.bytes;
    final Uint8List vBytes = vPlane.bytes;

    final int yRowStride = yPlane.bytesPerRow;
    final int uvRowStride = uPlane.bytesPerRow;
    final int uvPixelStride = uPlane.bytesPerPixel ?? 1;

    // convert yuv to rgb
    for (int y = 0; y < height; y++) {
      final int yRow = y * yRowStride;
      final int uvRow = (y >> 1) * uvRowStride;
      for (int x = 0; x < width; x++) {
        final int yIndex = yRow + x;
        final int uvIndex = uvRow + (x >> 1) * uvPixelStride;

        final int yp = yBytes[yIndex] & 0xff;
        final int up = uBytes[uvIndex] & 0xff;
        final int vp = vBytes[uvIndex] & 0xff;

        // YUV to RGB (BT.601)
        int r = (yp + 1.402 * (vp - 128)).toInt();
        int g = (yp - 0.344136 * (up - 128) - 0.714136 * (vp - 128)).toInt();
        int b = (yp + 1.772 * (up - 128)).toInt();

        r = r.clamp(0, 255);
        g = g.clamp(0, 255);
        b = b.clamp(0, 255);

        imgBuffer.setPixelRgba(x, y, r, g, b, 255);
      }
    }

    // Handle rotation/mirroring so the server receives upright frames:
    // controller.description.sensorOrientation gives angle in degrees.
    img.Image fixed = imgBuffer;

    // rotate according to sensorOrientation
    final int sensorOrientation = controller.description.sensorOrientation;
    // common values: 90, 270, 0, 180
    if (sensorOrientation != 0) {
      fixed = img.copyRotate(fixed, angle: sensorOrientation);
    }

    // front camera often needs horizontal flip to appear as user sees
    if (controller.description.lensDirection == CameraLensDirection.front) {
      fixed = img.flipHorizontal(fixed);
    }

    // encode JPEG (quality 80)
    final List<int> jpg = img.encodeJpg(fixed, quality: 80);
    return Uint8List.fromList(jpg);
  }

  // UI
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HomeColors.background,
      appBar: const CustomAppBar(username: "Cuti E. Patuti"),
      body: _isCameraOn
          ? Stack(
              children: [
                Positioned.fill(
                  child: _isCameraInitialized
                      ? ClipRect(
                          child: OverflowBox(
                            maxWidth: double.infinity,
                            maxHeight: double.infinity,
                            child: FittedBox(
                              fit: BoxFit.cover,
                              alignment: Alignment.center,
                              child: SizedBox(
                                // use previewSize to size the child so FittedBox scales properly
                                width: _cameraController!.value.previewSize?.height ?? MediaQuery.of(context).size.width,
                                height: _cameraController!.value.previewSize?.width ?? MediaQuery.of(context).size.height,
                                child: CameraPreview(_cameraController!),
                              ),
                            ),
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
                // Close button (top-right)
                Positioned(
                  top: 40,
                  right: 16, // 👈 changed from left to right
                  child: FloatingActionButton(
                    backgroundColor: Colors.white,
                    mini: true,
                    onPressed: () async {
                      // stop streaming and return to homepage UI
                      await _cameraController?.stopImageStream();
                      await _cameraController?.dispose();
                      _cameraController = null;
                      setState(() {
                        _isCameraOn = false;
                        _isCameraInitialized = false;
                        _prediction = null;
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
                  // 🔹 Camera Section
                  Column(
                    children: [
                      Container(
                        width: double.infinity,
                        alignment: Alignment.center,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: const Text("ASL CAMERA", style: HomeTextStyles.cameraTitle),
                      ),
                      Container(
                        width: double.infinity,
                        height: 220,
                        decoration: HomeDecorations.cameraContainer,
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                          decoration: HomeDecorations.cameraOverlayBox,
                          child: const Center(
                            child: Icon(Icons.photo_camera_outlined, size: 60, color: Colors.white70),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        style: HomeButtons.cameraToggleButton,
                        onPressed: _initCamera,
                        child: const Text("Start", style: HomeTextStyles.buttonText),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  // 🔹 Tips Section
                  Container(
                    width: double.infinity,
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Tips for you:", style: HomeTextStyles.tipTitle),
                        SizedBox(height: 4),
                        Text("\"Try learning 5 new letters today!\" [Learn More]", style: HomeTextStyles.tipSubtitle),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  // 🔹 Recent Transitions Header
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Recent Transitions", style: HomeTextStyles.sectionTitle),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, "/history");
                          },
                          child: const Text("View all", style: HomeTextStyles.sectionAction),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  // Example Items
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      children: List.generate(3, (index) {
                        return Card(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          margin: const EdgeInsets.only(bottom: 10),
                          child: const ListTile(
                            leading: Icon(Icons.front_hand, size: 30, color: Colors.brown),
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
