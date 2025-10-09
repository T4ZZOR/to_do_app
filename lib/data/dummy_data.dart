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
    Task(id: "t3", taskName: "Formularz", subTask: [
      Task(id: "st31", taskName: "Data"),
      Task(id: "st32", taskName: "Podpis"),
    ]),
    Task(id: "t4", taskName: "Spotkanie z szefem"),
  ],
  "2": [
    Task(id: "t5", taskName: "Zrób zakupy", subTask: [
      Task(id: "st51", taskName: "Pomidor"),
      Task(id: "st52", taskName: "Ogórek"),
    ]),
    Task(id: "t6", taskName: "Pospzątać piwnicę"),
    Task(id: "t7", taskName: "Zrobić słoiki", subTask: [
      Task(id: "st71", taskName: "Ogórki"),
      Task(id: "st72", taskName: "Papryka"),
    ]),
  ],
};
