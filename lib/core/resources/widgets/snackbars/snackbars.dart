import 'package:flutter/material.dart';

SnackBar comingSoonSnackbar(BuildContext context) {
  return SnackBar(
    backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
    behavior: SnackBarBehavior.floating,
    dismissDirection: DismissDirection.down,
    elevation: 4.0,
    padding: const EdgeInsets.all(16.0),
    content: Row(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Icon(Icons.hourglass_full,
              color: Theme.of(context).colorScheme.onSecondaryContainer),
        ),
        Text("Coming soon!",
            style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.onSecondaryContainer)),
      ],
    ),
  );
}
