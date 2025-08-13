import 'package:flutter/material.dart';
import 'package:todoapp/screens/add_edit_task_screen.dart';
import 'package:todoapp/screens/home_screen.dart';
import 'package:todoapp/screens/task_details_screen.dart';

class AppRoutes {
  static const home = '/';
  static const addEdit = '/add-edit';
  static const details = '/details';

  static Map<String, WidgetBuilder> builders = {
    home: (_) => const HomeScreen(),
    addEdit: (ctx) {
      final args = ModalRoute.of(ctx)!.settings.arguments as AddEditArgs?;
      return AddEditTaskScreen(args: args);
    },
    details: (ctx) {
      final id = ModalRoute.of(ctx)!.settings.arguments as String;
      return TaskDetailsScreen(taskId: id);
    },
  };
}