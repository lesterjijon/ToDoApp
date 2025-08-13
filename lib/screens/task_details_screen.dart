import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todoapp/app_theme.dart';
import 'package:todoapp/data/mock_tasks.dart';
import 'package:todoapp/models/task.dart';
import 'package:todoapp/routes.dart';

class TaskDetailsScreen extends StatefulWidget {
  final String taskId;
  const TaskDetailsScreen({super.key, required this.taskId});

  @override
  State<TaskDetailsScreen> createState() => _TaskDetailsScreenState();
}

class _TaskDetailsScreenState extends State<TaskDetailsScreen> {
  Task get task => mockTasks.firstWhere((e) => e.id == widget.taskId);

  String _dateLabel(DateTime? dt) {
    if (dt == null) return 'Sin fecha';
    final df = DateFormat('EEE d MMM, HH:mm', 'es');
    return df.format(dt);
  }

  void _toggleComplete() => setState(() => task.completed = !task.completed);

  void _delete() {
    mockTasks.removeWhere((e) => e.id == task.id);
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Tarea eliminada')));
  }

  @override
  Widget build(BuildContext context) {
    final completed = task.completed;

    return Scaffold(
      body: Column(
        children: [
          // Header
          Container(
            decoration: AppTheme.headerGradient(),
            padding: const EdgeInsets.only(top: 48, left: 12, right: 12, bottom: 16),
            width: double.infinity,
            child: SafeArea(
              bottom: false,
              child: Row(
                children: [
                  IconButton(
                    color: Colors.white,
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(
                        context,
                        AppRoutes.addEdit,
                        arguments: AddEditArgs(taskId: task.id),
                      ).then((_) => setState(() {}));
                    },
                    child: const Text('Editar', style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 8),
          const Text('Detalles', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),

          Expanded(
            child: ListView(
              padding: const EdgeInsets.only(bottom: 120),
              children: [
                Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(children: [
                          GestureDetector(
                            onTap: _toggleComplete,
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 150),
                              width: 24, height: 24,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: completed ? const Color(0xFF10B981) : const Color(0xFFCBD5E1),
                                  width: 3,
                                ),
                                color: completed ? const Color(0xFF10B981) : Colors.white,
                              ),
                              alignment: Alignment.center,
                              child: completed ? const Icon(Icons.check, size: 16, color: Colors.white) : null,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            completed ? 'Completada' : 'Pendiente',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: completed ? const Color(0xFF10B981) : const Color(0xFF6B7280),
                            ),
                          ),
                        ]),
                        const SizedBox(height: 12),
                        Text(
                          task.title,
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                            decoration: completed ? TextDecoration.lineThrough : null,
                            color: completed ? const Color(0xFF6B7280) : const Color(0xFF1F2937),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            Chip(
                              label: Text(
                                switch (task.priority) {
                                  TaskPriority.high => '🔴 Alta',
                                  TaskPriority.medium => '🟡 Media',
                                  TaskPriority.low => '🟢 Baja',
                                },
                              ),
                            ),
                            Chip(label: Text('📅 ${_dateLabel(task.dueDate)}')),
                          ],
                        ),
                        const SizedBox(height: 16),
                        const Divider(),
                        const SizedBox(height: 16),
                        const Text('📝 Descripción', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                        const SizedBox(height: 8),
                        Text(task.description?.isNotEmpty == true
                            ? task.description!
                            : 'Sin descripción',
                            style: const TextStyle(fontSize: 15)),
                        const SizedBox(height: 24),
                        const Text('🔔 Recordatorio', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: task.reminder ? const Color(0xFFF0F9FF) : const Color(0xFFF3F4F6),
                            border: Border.all(color: task.reminder ? const Color(0xFFBAE6FD) : const Color(0xFFE5E7EB)),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(task.reminder ? 'Activo - Te notificaremos 30 minutos antes' : 'Recordatorio desactivado'),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),

      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          child: Row(
            children: [
              Expanded(
                child: FilledButton(
                  onPressed: _toggleComplete,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Text(task.completed ? '↩️ Reabrir' : '✅ Completar'),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: FilledButton.tonal(
                  onPressed: () {
                    Navigator.pushNamed(context, AppRoutes.addEdit, arguments: AddEditArgs(taskId: task.id))
                        .then((_) => setState(() {}));
                  },
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    child: Text('✏️ Editar'),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: FilledButton(
                  style: FilledButton.styleFrom(backgroundColor: Colors.red),
                  onPressed: _delete,
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    child: Text('🗑️ Eliminar'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}