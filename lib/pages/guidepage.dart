import 'package:flutter/material.dart';
import '../widgets/custom_appbar.dart';
import '../widgets/custom_navbar.dart';
import '../styles/guidepagestyle.dart'; // ✅ import styles

class GuidePage extends StatefulWidget {
  const GuidePage({super.key});

  @override
  State<GuidePage> createState() => _GuidePageState();
}

class _GuidePageState extends State<GuidePage> {
  final TextEditingController _searchController = TextEditingController();

  final List<Map<String, String>> allSigns = [
    {"letter": "A", "image": "assets/images/asl_a.png", "desc": "Hand Pose: Closed fist, thumb to the side"},
    {"letter": "B", "image": "assets/images/asl_b.png", "desc": "Hand Pose: Flat hand, palm forward"},
    {"letter": "C", "image": "assets/images/asl_c.png", "desc": "Hand Pose: Curve hand like letter C"},
    {"letter": "D", "image": "assets/images/asl_d.png", "desc": "Hand Pose: Index up, other fingers curled"},
    {"letter": "E", "image": "assets/images/asl_e.png", "desc": "Hand Pose: Fingers bent toward palm"},
    {"letter": "F", "image": "assets/images/asl_f.png", "desc": "Hand Pose: Thumb and index touch"},
  ];

  List<Map<String, String>> filteredSigns = [];

  @override
  void initState() {
    super.initState();
    filteredSigns = List.from(allSigns);

    _searchController.addListener(() {
      _filterSigns(_searchController.text);
    });
  }

  void _filterSigns(String query) {
    setState(() {
      filteredSigns = query.isEmpty
          ? List.from(allSigns)
          : allSigns
              .where((sign) =>
                  sign["letter"]!.toLowerCase().contains(query.toLowerCase()))
              .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(username: "Cuti E. Patuti"),
      body: Container(
        width: double.infinity,
        decoration: guidePageBackground, // ✅ use style
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // 🔹 Search bar
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: searchBarDecoration, // ✅ use style
                child: TextField(
                  controller: _searchController,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: "Type A - Z",
                    icon: Icon(Icons.search, color: Colors.grey),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // 🔹 Grid of ASL Cards
              Expanded(
                child: filteredSigns.isEmpty
                    ? const Center(
                        child: Text("No results found", style: noResultsTextStyle), // ✅ style
                      )
                    : GridView.builder(
                        itemCount: filteredSigns.length,
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: 0.75,
                        ),
                        itemBuilder: (context, index) {
                          final sign = filteredSigns[index];
                          return _aslCard(
                            sign["letter"]!,
                            sign["image"]!,
                            sign["desc"]!,
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const CustomNavBar(currentIndex: 2),
    );
  }

  // 🔹 ASL Card Widget
  Widget _aslCard(String letter, String imagePath, String desc) {
    return Card(
      shape: aslCardShape, // ✅ style
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("\"$letter\"", style: aslLetterTextStyle), // ✅ style
            const SizedBox(height: 8),
            Expanded(child: Image.asset(imagePath, fit: BoxFit.contain)),
            const SizedBox(height: 8),
            Text(desc, textAlign: TextAlign.center, style: aslDescTextStyle), // ✅ style
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(onPressed: () {}, style: watchButtonStyle, child: const Text("Watch")), // ✅ style
                ElevatedButton(onPressed: () {}, style: practiceButtonStyle, child: const Text("Practice")), // ✅ style
              ],
            ),
          ],
        ),
      ),
    );
  }
}
