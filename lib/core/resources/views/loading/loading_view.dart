import 'package:flutter/material.dart';

class LoadingView extends StatelessWidget {
  const LoadingView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          CircleAvatar(
            backgroundColor: Theme.of(context).primaryColor,
            radius: MediaQuery.of(context).size.shortestSide / 5,
            child: CircleAvatar(
              backgroundImage: const AssetImage("assets/images/loading1.gif"),
              radius: MediaQuery.of(context).size.shortestSide / 5.2,
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(top: 32.0),
            child: Text(
              "Loading...",
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 21.0),
            ),
          )
        ],
      ),
    );
  }
}
