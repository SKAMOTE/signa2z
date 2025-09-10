import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import '../widgets/custom_appbar.dart';
import '../widgets/custom_navbar.dart';
import '../styles/notificationpagestyle.dart'; // ✅ import styles

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
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
      appBar: const CustomAppBar(username: "Cuti E. Patuti"),
      body: Container(
        decoration: notificationPageBackground, // ✅ background
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
      bottomNavigationBar: const CustomNavBar(currentIndex: 2),
    );
  }
}

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
      endActionPane: ActionPane(
        motion: const DrawerMotion(),
        extentRatio: 0.25,
        children: [
          SlidableAction(
            onPressed: (ctx) => onDelete(),
            backgroundColor: deleteButtonBackground, // ✅ style
            foregroundColor: deleteButtonForeground, // ✅ style
            icon: deleteButtonIcon, // ✅ style
            label: deleteButtonLabel, // ✅ style
          ),
        ],
      ),
      child: Card(
        elevation: notificationCardElevation, // ✅ style
        margin: notificationCardMargin, // ✅ style
        child: ListTile(
          leading: unread ? unreadIndicator : null, // ✅ style
          title: Text(title, style: notificationTitleTextStyle), // ✅ style
          subtitle: Text(time),
        ),
      ),
    );
  }
}
