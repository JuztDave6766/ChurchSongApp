import 'package:flutter/material.dart';

/// Maps the icon keys used by the (Flutter-free) domain layer to Material
/// icons.
IconData functionIcon(String iconName) => switch (iconName) {
      'church' => Icons.church_rounded,
      'route' => Icons.route_rounded,
      'sun' => Icons.wb_sunny_rounded,
      'hands' => Icons.volunteer_activism_rounded,
      _ => Icons.auto_stories_rounded,
    };
