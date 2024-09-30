import 'package:flutter/material.dart';

class CustomRoute<T> extends MaterialPageRoute<T> {
  CustomRoute({
    required WidgetBuilder builder,
    RouteSettings? settings,
  }) : super(builder: builder, settings: settings);

  @override
  Widget buildTransition(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secoundaryAnimation,
    Widget child,
  ) {
    // if (settings != '/') {
    //   return child;
    // }

    return FadeTransition(opacity: animation, child: child);
  }
}

class CustomPageTransitionsBuilder extends PageTransitionsBuilder {
  Widget buildTransitions<T>(
    PageRoute<T> route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    // if (route.settings != '/') {
    //   return child;
    // }

    return FadeTransition(opacity: animation, child: child);
  }
}
