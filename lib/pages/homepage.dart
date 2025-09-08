import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import '../widgets/custom_appbar.dart';
import '../widgets/custom_navbar.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  CameraController? _cameraController;
  bool _isCameraInitialized = false;
  bool _isCameraOn = false;

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  Future<void> _initCamera() async {
    try {
      final cameras = await availableCameras();
      final firstCamera = cameras.first;

      _cameraController = CameraController(
        firstCamera,
        ResolutionPreset.medium,
      );

      await _cameraController!.initialize();
      if (!mounted) return;

      setState(() {
        _isCameraInitialized = true;
        _isCameraOn = true;
      });
    } catch (e) {
      debugPrint("Camera init error: $e");
    }
  }

  void _toggleCamera() {
    if (_isCameraOn) {
      // turn OFF
      _cameraController?.dispose();
      _cameraController = null;
      setState(() {
        _isCameraInitialized = false;
        _isCameraOn = false;
      });
    } else {
      // turn ON
      _initCamera();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(username: "Cuti E. Patuti"),

      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🔸 Camera Section
            Column(
              children: [
                Container(
                  width: double.infinity,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: const Text(
                    "ASL CAMERA",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                // Camera Container with zigzag + borders
                Container(
                  width: double.infinity,
                  height: 220,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/images/zigzag_bg.png"),
                      fit: BoxFit.cover,
                    ),
                    border: Border(
                      top: BorderSide(color: Colors.blue, width: 2),
                      bottom: BorderSide(color: Colors.blue, width: 2),
                    ),
                  ),
                  child: Container(
                    margin:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    decoration: const BoxDecoration(
                      color: Color.fromRGBO(76, 77, 76, 0.882),
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                    ),
                    child: _isCameraOn && _isCameraInitialized
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: CameraPreview(_cameraController!),
                          )
                        : const Center(
                            child: Icon(
                              Icons.photo_camera_outlined,
                              size: 60,
                              color: Colors.white70,
                            ),
                          ),
                  ),
                ),

                const SizedBox(height: 10),

                // Start/Stop Button
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  onPressed: _toggleCamera,
                  child: Text(
                    _isCameraOn ? "Stop" : "Start",
                    style: const TextStyle(fontSize: 14, color: Colors.white),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // 🔸 Tips Section
            Container(
              width: double.infinity,
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Tips for you:",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    "\"Try learning 5 new letters today!\" [Learn More]",
                    style: TextStyle(
                      color: Colors.black87,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // 🔸 Recent Transitions
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text(
                    "Recent Transitions",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "View all",
                    style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),

            // Example Recent Items
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: List.generate(3, (index) {
                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
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
