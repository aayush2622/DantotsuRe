import 'dart:ui';

import 'package:flutter/cupertino.dart';

Widget ScrollConfig(BuildContext context, {required Widget child}) {
  return ScrollConfiguration(
    behavior: ScrollConfiguration.of(context).copyWith(
      dragDevices: {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
        PointerDeviceKind.trackpad,
      },
    ),

    child: child,
  );
}

Widget CustomScrollConfig(BuildContext context, { required List<Widget> children, Axis scrollDirection = Axis.vertical , ScrollPhysics? physics}) {
 return CustomScrollView(
   scrollBehavior: ScrollConfiguration.of(context).copyWith(
     dragDevices: {
       PointerDeviceKind.touch,
       PointerDeviceKind.mouse,
       PointerDeviceKind.trackpad
     },
   ),
   physics: physics,
   scrollDirection: scrollDirection,
   slivers: children,
 );
}