import 'package:flutter/material.dart';


class MyPostsScreen extends StatelessWidget {
  const MyPostsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Posts'), centerTitle: true),
      body: const Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('0 posts'),
            Expanded(
              child: Center(child: Text('You have not created any posts yet')),
            ),
          ],
        ),
      ),
    );
  }
}
