import 'package:flutter/material.dart';

class NotificationsSettingsView extends StatelessWidget {
  const NotificationsSettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: true,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Color(0x0D000000),
                  blurRadius: 10,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
        ),
        title: Row(
          children: [
            Image.asset(
              'assets/images/notification.png',
              width: 24,
              height: 24,
              fit: BoxFit.contain,
            ),
            const SizedBox(width: 8),
            const Text(
              'Notifications',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
                fontSize: 18,
                color: Colors.black,
              ),
            ),
          ],
        ),
        centerTitle: false,
      ),
      body: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        itemCount: 5,
        separatorBuilder: (context, index) => const SizedBox(height: 24),
        itemBuilder: (context, index) {
          return _NotificationSettingItem();
        },
      ),
    );
  }
}

class _NotificationSettingItem extends StatefulWidget {
  const _NotificationSettingItem({super.key});

  @override
  State<_NotificationSettingItem> createState() =>
      _NotificationSettingItemState();
}

class _NotificationSettingItemState extends State<_NotificationSettingItem> {
  bool _enabled = true;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                "Détection d'un problème",
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  height: 1.5, // 24px line height
                  letterSpacing: -0.32, // -2% of 16px
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 4),
              Text(
                'Lorem ipsum dolor sit amet, consectetur adipiscing elit ut aliquam, purus sit amet luctus venenatis, lectus magna fringilla urna, porttitor',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w300,
                  fontSize: 12,
                  height: 2, // 24px line height
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
        Switch(
          value: _enabled,
          onChanged: (val) {
            setState(() {
              _enabled = val;
            });
          },
          activeColor: Colors.white, // thumb color
          activeTrackColor: Color(0xFF4ECDC4), // track color
          inactiveThumbColor: Colors.white,
          inactiveTrackColor: Colors.grey.shade300,
        ),
      ],
    );
  }
}
