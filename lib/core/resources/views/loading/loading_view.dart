import 'package:flutter/material.dart';
import 'package:rickandmorty/config/theme/app_themes.dart';

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
            backgroundColor: theme().primaryColor,
            radius: MediaQuery.of(context).size.shortestSide / 5,
            child: CircleAvatar(
              backgroundImage: const AssetImage("assets/images/loading1.gif"),
              radius: MediaQuery.of(context).size.shortestSide / 5.2,
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(top: 16.0),
            child: Text(
              "Loading...",
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          )
        ],
      ),
    );
  }
}
