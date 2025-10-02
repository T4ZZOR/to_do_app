import 'package:flutter/material.dart';
import '../models/category.dart';
import '../models/task.dart';

final dummyCategories = [
  Category(id: "1", name: "Praca", color: Colors.blue, icon: Icons.work),
  Category(id: "2", name: "Dom", color: Colors.green, icon: Icons.home),
];

final dummyTasks = {
  "1": [
    Task(id: "t1", taskName: "Wyślij raport"),
    Task(id: "t2", taskName: "Spotkanie z klientem"),
  ],
  "2": [
    Task(id: "t3", taskName: "Zrób zakupy", subTask: [
      Task(id: "st1", taskName: "Pomidor"),
      Task(id: "st2", taskName: "Ogórek"),
    ]),
  ],
};
