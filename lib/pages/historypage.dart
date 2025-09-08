import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart'; // ✅ import Slidable
import '../widgets/custom_appbar.dart';
import '../widgets/custom_navbar.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  final TextEditingController _searchController = TextEditingController();

  // 🔹 Dummy history list
  List<Map<String, String>> allHistory = [
    {"letter": "A", "time": "Aug 26, 2025 – 10:12 AM"},
    {"letter": "B", "time": "Aug 26, 2025 – 10:15 AM"},
    {"letter": "C", "time": "Aug 26, 2025 – 10:20 AM"},
    {"letter": "D", "time": "Aug 26, 2025 – 10:30 AM"},
    {"letter": "E", "time": "Aug 26, 2025 – 10:45 AM"},
    {"letter": "F", "time": "Aug 26, 2025 – 11:00 AM"},
  ];

  List<Map<String, String>> filteredHistory = [];

  @override
  void initState() {
    super.initState();
    filteredHistory = List.from(allHistory);

    _searchController.addListener(() {
      _filterHistory(_searchController.text);
    });
  }

  void _filterHistory(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredHistory = List.from(allHistory);
      } else {
        filteredHistory = allHistory
            .where((item) =>
                item["letter"]!.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  void _clearAll() {
    setState(() {
      allHistory.clear();
      filteredHistory.clear();
    });
  }

  void _deleteItem(int index) {
    setState(() {
      String target = filteredHistory[index]["letter"]!;
      allHistory.removeWhere((item) => item["letter"] == target);
      filteredHistory.removeAt(index);
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
            image: AssetImage("assets/images/bg_history.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // 🔹 Search Bar + Clear Button
              Row(
                children: [
                  Expanded(
                    child: Container(
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
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: _clearAll,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.shade700,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                    ),
                    child: const Text("Clear All"),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // 🔹 History List with Slidable
              Expanded(
                child: filteredHistory.isEmpty
                    ? const Center(
                        child: Text(
                          "No history found",
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                      )
                    : ListView.builder(
                        itemCount: filteredHistory.length,
                        itemBuilder: (context, index) {
                          final item = filteredHistory[index];
                          return Slidable(
                            key: ValueKey(item["letter"]),
                            endActionPane: ActionPane(
                              motion: const DrawerMotion(),
                              extentRatio: 0.25,
                              children: [
                                SlidableAction(
                                  onPressed: (context) => _deleteItem(index),
                                  backgroundColor: Colors.red,
                                  foregroundColor: Colors.white,
                                  icon: Icons.delete,
                                  label: 'Delete',
                                ),
                              ],
                            ),
                            child: Card(
                              margin: const EdgeInsets.only(bottom: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 2,
                              child: ListTile(
                                title: Text(
                                  "\"${item["letter"]}\"",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                subtitle: Text(item["time"]!),
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const CustomNavBar(currentIndex: 1),
    );
  }
}
