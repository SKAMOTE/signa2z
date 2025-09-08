import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart'; // 👈 import package
import '../widgets/custom_appbar.dart';
import '../widgets/custom_navbar.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  // ✅ Notification list (dynamic so we can remove items)
  final List<Map<String, dynamic>> _notifications = [
    {"title": "Update", "time": "4:00 PM", "unread": true},
    {"title": "Update", "time": "5:46 PM", "unread": true},
    {"title": "Update", "time": "Yesterday", "unread": true},
    {"title": "Update", "time": "4:00 PM", "unread": true},
    {"title": "New Features!", "time": "5:46 PM", "unread": true},
    {"title": "Update", "time": "Yesterday", "unread": true},
  ];

  void _deleteNotification(int index) {
    final removedItem = _notifications[index];

    setState(() {
      _notifications.removeAt(index);
    });

    // Optional: Undo Snackbar
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Deleted: ${removedItem['title']}"),
        action: SnackBarAction(
          label: "UNDO",
          onPressed: () {
            setState(() {
              _notifications.insert(index, removedItem);
            });
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(username: "User"),

      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/bg.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: ListView.builder(
          padding: const EdgeInsets.all(10),
          itemCount: _notifications.length,
          itemBuilder: (context, index) {
            final item = _notifications[index];
            return NotificationCard(
              title: item["title"],
              time: item["time"],
              unread: item["unread"],
              onDelete: () => _deleteNotification(index),
            );
          },
        ),
      ),

      // ✅ Reuse your custom navbar
      bottomNavigationBar: const CustomNavBar(currentIndex: 2),
    );
  }
}

/// 🔹 Notification Card with Slide-to-Reveal Delete
class NotificationCard extends StatelessWidget {
  final String title;
  final String time;
  final bool unread;
  final VoidCallback onDelete;

  const NotificationCard({
    super.key,
    required this.title,
    required this.time,
    required this.unread,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Slidable(
      key: ValueKey(title + time),

      // Swipe left to show delete
      endActionPane: ActionPane(
        motion: const DrawerMotion(),
        extentRatio: 0.25,
        children: [
          SlidableAction(
            onPressed: (BuildContext ctx) => onDelete(),
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            icon: Icons.delete,
            label: 'Delete',
          ),
        ],
      ),

      child: Card(
        elevation: 2,
        margin: const EdgeInsets.symmetric(vertical: 6),
        child: ListTile(
          leading: unread
              ? const Icon(Icons.circle, color: Colors.red, size: 10)
              : null,
          title: Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          subtitle: Text(time),
        ),
      ),
    );
  }
}
