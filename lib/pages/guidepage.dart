import 'package:flutter/material.dart';
import '../widgets/custom_appbar.dart';
import '../widgets/custom_navbar.dart';

class GuidePage extends StatefulWidget {
  const GuidePage({super.key});

  @override
  State<GuidePage> createState() => _GuidePageState();
}

class _GuidePageState extends State<GuidePage> {
  final TextEditingController _searchController = TextEditingController();

  // 🔹 Dummy ASL signs (replace with real data later)
  final List<Map<String, String>> allSigns = [
    {
      "letter": "A",
      "image": "assets/images/asl_a.png",
      "desc": "Hand Pose: Closed fist, thumb to the side"
    },
    {
      "letter": "B",
      "image": "assets/images/asl_b.png",
      "desc": "Hand Pose: Flat hand, palm forward"
    },
    {
      "letter": "C",
      "image": "assets/images/asl_c.png",
      "desc": "Hand Pose: Curve hand like letter C"
    },
    {
      "letter": "D",
      "image": "assets/images/asl_d.png",
      "desc": "Hand Pose: Index up, other fingers curled"
    },
    {
      "letter": "E",
      "image": "assets/images/asl_e.png",
      "desc": "Hand Pose: Fingers bent toward palm"
    },
    {
      "letter": "F",
      "image": "assets/images/asl_f.png",
      "desc": "Hand Pose: Thumb and index touch"
    },
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
      if (query.isEmpty) {
        filteredSigns = List.from(allSigns);
      } else {
        filteredSigns = allSigns
            .where((sign) =>
                sign["letter"]!.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(username: "Cuti E. Patuti"),
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/bg_guide.png"), // 👈 background
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // 🔹 Search bar
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 4,
                    ),
                  ],
                ),
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
                        child: Text(
                          "No results found",
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                      )
                    : GridView.builder(
                        itemCount: filteredSigns.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2, // 2 cards per row
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
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "\"$letter\"",
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: Image.asset(
                imagePath,
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              desc,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12, color: Colors.black87),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    minimumSize: const Size(60, 30),
                  ),
                  onPressed: () {},
                  child: const Text("Watch"),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    minimumSize: const Size(60, 30),
                  ),
                  onPressed: () {},
                  child: const Text("Practice"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
