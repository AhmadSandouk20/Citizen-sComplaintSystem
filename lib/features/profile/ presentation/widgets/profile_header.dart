import 'package:flutter/material.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        CircleAvatar(radius: 45, child: Icon(Icons.person, size: 45)),
        SizedBox(height: 24),
      ],
    );
  }
}
