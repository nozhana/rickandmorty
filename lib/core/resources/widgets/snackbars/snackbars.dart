import 'package:flutter/material.dart';

SnackBar comingSoonSnackbar() {
  return const SnackBar(
    behavior: SnackBarBehavior.floating,
    dismissDirection: DismissDirection.down,
    elevation: 4.0,
    padding: EdgeInsets.all(16.0),
    content: Row(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.0),
          child: Icon(Icons.hourglass_full, color: Colors.white70),
        ),
        Text("Coming soon!", style: TextStyle(fontWeight: FontWeight.w600)),
      ],
    ),
  );
}
