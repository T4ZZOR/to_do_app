import 'package:flutter/material.dart';
import '../constans/colors.dart';
import 'dart:math';

class Category {
  final String id;
  final String name;
  Color color;
  final IconData icon;

  Category({
    required this.id, 
    required this.name,
    Color? color,
    this.icon = Icons.folder,
    }) : color = color ?? categoryColors[Random().nextInt(categoryColors.length)];
}