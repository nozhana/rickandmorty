import 'package:flutter/material.dart';

class EpisodeListView extends StatelessWidget {
  const EpisodeListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: const Center(
        child: Text(
          "✨ Coming soon! ✨",
          style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  AppBar _appBar() {
    return AppBar(
      title: const Text(
        "Episodes",
        style: TextStyle(color: Colors.black),
      ),
    );
  }
}
