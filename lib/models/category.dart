import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Category {
  final String id;
  final String name;
  final Color color;
  final IconData icon;

  Category({
    required this.id, 
    required this.name,
    this.color = Colors.blueAccent,
    this.icon = Icons.folder,
    });
}