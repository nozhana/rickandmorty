import 'package:flutter/material.dart';

const Color _kColor = Color(0xA0B71C1C);
const TextStyle _kTextStyle = TextStyle(
  color: Color(0xFFFFFFFF),
  fontSize: 12 * 0.85,
  fontWeight: FontWeight.w900,
  height: 1.0,
);

class CustomBanner extends StatelessWidget {
  const CustomBanner(
      {Key? key,
      required this.message,
      this.textStyle = _kTextStyle,
      this.color = _kColor,
      required this.location,
      this.onTap,
      required this.child})
      : super(key: key);

  final String message;
  final TextStyle textStyle;
  final Color color;
  final BannerLocation location;
  final Widget child;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Banner(
          message: message,
          location: location,
          color: color,
          textStyle: textStyle,
          child: child,
        ),
        Positioned(
          top: location == BannerLocation.topEnd ||
                  location == BannerLocation.topStart
              ? 0
              : null,
          bottom: location == BannerLocation.bottomEnd ||
                  location == BannerLocation.bottomStart
              ? 0
              : null,
          left: location == BannerLocation.topStart ||
                  location == BannerLocation.bottomStart
              ? 0
              : null,
          right: location == BannerLocation.topEnd ||
                  location == BannerLocation.bottomEnd
              ? 0
              : null,
          child: SizedBox.square(
            dimension: 40,
            child: GestureDetector(
              onTap: onTap,
            ),
          ),
        )
      ],
    );
  }
}
