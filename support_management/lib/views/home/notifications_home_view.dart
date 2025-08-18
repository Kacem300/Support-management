import 'package:flutter/material.dart';

class NotificationsHomeView extends StatelessWidget {
  const NotificationsHomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F6),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF6F6F6),
        elevation: 0,
        leadingWidth: 64,
        leading: Padding(
          padding: const EdgeInsets.only(left: 12.0),
          child: Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: const [
            Text(
              'Notifications',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
                fontSize: 14,
                height: 22 / 14,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 4),
            Text(
              'Ticket# 2023-CS123',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w500,
                fontSize: 14,
                color: Color(0xFF707070),
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20),
        child: Column(
          children: [
            // Push notification box (simple bell, no green circle)
            Center(
              child: Container(
                width: 336,
                height: 62,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: const Color(0xFF404040),
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0x082A4526),
                      blurRadius: 15,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    // simple bell icon (no circle)
                    const SizedBox(width: 6),
                    const Icon(Icons.notifications_outlined,
                        color: Colors.white, size: 24),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Text(
                            'Push Notification',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                              height: 22 / 14,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Automatically send new notifications',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w500,
                              fontSize: 12,
                              height: 14 / 12,
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Switch(value: false, onChanged: null),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Notifications list
            Expanded(
              child: ListView.separated(
                itemCount: 6,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  // Rich notification card with left gradient circle and right content card
                  return Center(
                    child: SizedBox(
                      width: 336,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // timeline circle
                          Column(
                            children: [
                              Container(
                                width: 48,
                                height: 48,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: LinearGradient(
                                    begin: Alignment(-0.98, -0.2),
                                    end: Alignment(0.98, 0.2),
                                    colors: [
                                      Color(0xFF25CEC3),
                                      Color(0xFF0E8780)
                                    ],
                                  ),
                                ),
                                child: Center(
                                  child: Image.asset(
                                    'assets/images/notification_icon.png',
                                    width: 22,
                                    height: 22,
                                    color: Colors.white,
                                    errorBuilder: (c, e, s) => Icon(
                                      Icons.confirmation_num,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                  ),
                                ),
                              ),
                              // vertical connector
                              Container(
                                width: 2,
                                height: 80,
                                margin: const EdgeInsets.only(top: 6),
                                color: const Color(0xFFE6E6E6),
                              ),
                            ],
                          ),
                          const SizedBox(width: 12),
                          // content card
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.04),
                                    blurRadius: 10,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      CircleAvatar(
                                        radius: 18,
                                        backgroundImage: null,
                                        backgroundColor:
                                            const Color(0xFFEDEDED),
                                        child: const Icon(Icons.person,
                                            color: Colors.black54),
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: const [
                                            Text(
                                              'Lincoln Donin',
                                              style: TextStyle(
                                                fontFamily: 'Poppins',
                                                fontWeight: FontWeight.w600,
                                                fontSize: 14,
                                                color: Colors.black,
                                              ),
                                            ),
                                            SizedBox(height: 2),
                                            Text(
                                              'Client depuis 2023',
                                              style: TextStyle(
                                                fontFamily: 'Poppins',
                                                fontSize: 12,
                                                color: Color(0xFF9AA0A6),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  const Text(
                                    'Design NFT landing page shot',
                                    style: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w700,
                                      fontSize: 16,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  const Text(
                                    'Ticket# 2023-CS123',
                                    style: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: 12,
                                      color: Color(0xFF9AA0A6),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  const Text(
                                    'Design a simple home pages with clean layout and color based on the guidelin to...',
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: 12,
                                      color: Color(0xFF9AA0A6),
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 6),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFF3F4F6),
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        child: Row(
                                          children: const [
                                            Icon(Icons.access_time,
                                                size: 14,
                                                color: Color(0xFF6B7280)),
                                            SizedBox(width: 6),
                                            Text('13.08.2023 / 10:55',
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    color: Color(0xFF6B7280))),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 6),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFFEECE0),
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        child: Row(
                                          children: const [
                                            Icon(Icons.flag,
                                                size: 14,
                                                color: Color(0xFFE46C09)),
                                            SizedBox(width: 6),
                                            Text('Urgente',
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    color: Color(0xFFE46C09))),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
