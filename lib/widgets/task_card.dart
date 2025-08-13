import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todoapp/models/task.dart';

class TaskCard extends StatelessWidget {
  final Task task;
  final VoidCallback onToggle;
  final VoidCallback onTap;

  const TaskCard({
    super.key,
    required this.task,
    required this.onToggle,
    required this.onTap,
  });

  Color _priorityBg(TaskPriority p) {
    switch (p) {
      case TaskPriority.high: return const Color(0xFFFEE2E2);
      case TaskPriority.medium: return const Color(0xFFFFF7ED);
      case TaskPriority.low: return const Color(0xFFF0FDF4);
    }
  }

  Color _priorityFg(TaskPriority p) {
    switch (p) {
      case TaskPriority.high: return const Color(0xFFDC2626);
      case TaskPriority.medium: return const Color(0xFFD97706);
      case TaskPriority.low: return const Color(0xFF16A34A);
    }
  }

  String _dateLabel(DateTime? dt) {
    if (dt == null) return '📅 Sin fecha';
    final now = DateTime.now();
    final df = DateFormat('EEE d MMM, HH:mm', 'es');
    if (DateUtils.isSameDay(dt, now)) return '📅 Hoy ${DateFormat('HH:mm').format(dt)}';
    if (DateUtils.isSameDay(dt, now.subtract(const Duration(days: 1)))) return '📅 Ayer';
    if (DateUtils.isSameDay(dt, now.add(const Duration(days: 1)))) return '📅 Mañana ${DateFormat('HH:mm').format(dt)}';
    return '📅 ${df.format(dt)}';
  }

  @override
  Widget build(BuildContext context) {
    final completed = task.completed;

    return InkWell(
      onTap: onTap,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: onToggle,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  width: 22, height: 22,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                      color: completed ? const Color(0xFF10B981) : const Color(0xFFCBD5E1),
                      width: 2,
                    ),
                    color: completed ? const Color(0xFF10B981) : Colors.white,
                  ),
                  alignment: Alignment.center,
                  child: completed ? const Icon(Icons.check, size: 16, color: Colors.white) : null,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      task.title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        decoration: completed ? TextDecoration.lineThrough : null,
                        color: completed ? const Color(0xFF6B7280) : const Color(0xFF1F2937),
                      ),
                    ),
                    if ((task.description ?? '').isNotEmpty) ...[
                      const SizedBox(height: 6),
                      Text(
                        task.description!,
                        style: const TextStyle(fontSize: 14, color: Color(0xFF6B7280)),
                      ),
                    ],
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: _priorityBg(task.priority),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            switch (task.priority) {
                              TaskPriority.high => 'Alta',
                              TaskPriority.medium => 'Media',
                              TaskPriority.low => 'Baja',
                            },
                            style: TextStyle(
                              fontSize: 12,
                              color: _priorityFg(task.priority),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(_dateLabel(task.dueDate), style: const TextStyle(fontSize: 12, color: Color(0xFF9CA3AF))),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}