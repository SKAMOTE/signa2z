import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import '../widgets/custom_appbar.dart';
import '../widgets/custom_navbar.dart';
import '../styles/homepagestyle.dart'; // ✅ import styles

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
      _cameraController?.dispose();
      _cameraController = null;
      setState(() {
        _isCameraInitialized = false;
        _isCameraOn = false;
      });
    } else {
      _initCamera();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HomeColors.background,
      appBar: const CustomAppBar(username: "Cuti E. Patuti"),

      body: SingleChildScrollView(
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

                // Camera Container
                Container(
                  width: double.infinity,
                  height: 220,
                  decoration: HomeDecorations.cameraContainer,
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    decoration: HomeDecorations.cameraOverlayBox,
                    child: _isCameraOn && _isCameraInitialized
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: CameraPreview(_cameraController!),
                          )
                        : const Center(
                            child: Icon(Icons.photo_camera_outlined, size: 60, color: Colors.white70),
                          ),
                  ),
                ),

                const SizedBox(height: 10),

                // Start/Stop Button
                ElevatedButton(
                  style: HomeButtons.cameraToggleButton,
                  onPressed: _toggleCamera,
                  child: Text(
                    _isCameraOn ? "Stop" : "Start",
                    style: HomeTextStyles.buttonText,
                  ),
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

                  // 👇 Make "View all" clickable
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
