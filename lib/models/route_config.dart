import 'package:flutter/material.dart';

class RouteConfig {
  final String title;
  final Widget Function() screenBuilder;

  const RouteConfig({
    required this.title,
    required this.screenBuilder,
  });
}
