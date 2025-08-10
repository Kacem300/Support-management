import 'package:flutter/material.dart';
import '../common/placeholder_view.dart';

class ChatView extends StatelessWidget {
  const ChatView({super.key});

  @override
  Widget build(BuildContext context) {
    return const PlaceholderView(
      title: 'Messages',
      message: 'Your chat conversations',
      icon: Icons.chat,
      availableRoutes: ['Go to Home'],
    );
  }
}

class FilterView extends StatelessWidget {
  const FilterView({super.key});

  @override
  Widget build(BuildContext context) {
    return const PlaceholderView(
      title: 'Filter',
      message: 'Filter your data',
      icon: Icons.filter_list,
      availableRoutes: ['Go to Home'],
    );
  }
}

class MenuView extends StatelessWidget {
  const MenuView({super.key});

  @override
  Widget build(BuildContext context) {
    return const PlaceholderView(
      title: 'Menu',
      message: 'App settings and options',
      icon: Icons.menu,
      availableRoutes: ['Go to Home'],
    );
  }
}
