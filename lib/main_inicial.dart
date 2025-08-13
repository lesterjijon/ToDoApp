import 'package:flutter/material.dart';
import 'package:todoapp/app_theme.dart';
import 'package:todoapp/routes.dart';

void main() {
  runApp(const ToDoApp());
}

class ToDoApp extends StatelessWidget {
  const ToDoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mis Tareas',
      theme: AppTheme.light(),
      initialRoute: AppRoutes.home,
      routes: AppRoutes.builders,
      debugShowCheckedModeBanner: false,
    );
  }
}