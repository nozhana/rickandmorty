import 'package:flutter/material.dart';
import 'package:rickandmorty/core/resources/widgets/appbar/base_app_bar.dart';

class LocationListView extends StatelessWidget {
  const LocationListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: const Center(
        child: Text(
          "✨ Coming soon! ✨",
          style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return const BaseAppBar(
      title: Text(
        "Locations",
      ),
    );
  }
}
