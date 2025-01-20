import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');

final router = GoRouter(
  navigatorKey: _rootNavigatorKey,
  routes: [
    // StatefulShellRoute(
    //     branches: branches,
    //     navigatorContainerBuilder: navigatorContainerBuilder),
  ],
);
