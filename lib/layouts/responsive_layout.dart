import 'package:flutter/material.dart';

class ResponsiveLayout extends StatelessWidget {
  final Widget drawer;
  final Widget body;

  const ResponsiveLayout({
    super.key,
    required this.drawer,
    required this.body,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= 1200) {
          // Wide layout with permanent drawer
          return Row(
            children: [
              SizedBox(
                width: 280,
                child: drawer,
              ),
              Expanded(child: body),
            ],
          );
        }
        // Regular layout with drawer menu button
        return body;
      },
    );
  }
} 