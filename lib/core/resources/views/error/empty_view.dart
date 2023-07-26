import 'package:flutter/material.dart';

class EmptyView extends StatelessWidget {
  const EmptyView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final imageDimension = MediaQuery.of(context).size.shortestSide /
        (MediaQuery.of(context).size.shortestSide ==
                MediaQuery.of(context).size.width
            ? 1.4
            : 2.2);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox.square(
              dimension: imageDimension,
              child: Image.asset(
                "assets/images/not_found.png",
                fit: BoxFit.contain,
              )),
          const SizedBox(
            height: 40,
          ),
          const Text(
            "Your search returned no results.",
            style: TextStyle(fontSize: 21.0, fontWeight: FontWeight.bold),
          ),
          const Text(
            "Try updating the search filters.",
            style: TextStyle(fontSize: 17.0),
          ),
        ],
      ),
    );
  }
}
