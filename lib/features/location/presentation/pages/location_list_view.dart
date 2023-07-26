import 'package:flutter/material.dart';

class LocationListView extends StatelessWidget {
  const LocationListView({Key? key}) : super(key: key);

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
        "Locations",
        style: TextStyle(color: Colors.black),
      ),
    );
  }
}
