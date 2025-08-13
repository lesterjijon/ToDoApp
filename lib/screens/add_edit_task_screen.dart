import 'package:flutter/material.dart';
import 'package:todoapp/app_theme.dart';
import 'package:todoapp/data/mock_tasks.dart';
import 'package:todoapp/models/task.dart';

class AddEditArgs {
  final String? taskId;
  const AddEditArgs({this.taskId});
}

class AddEditTaskScreen extends StatefulWidget {
  final AddEditArgs? args;
  const AddEditTaskScreen({super.key, this.args});

  @override
  State<AddEditTaskScreen> createState() => _AddEditTaskScreenState();
}

class _AddEditTaskScreenState extends State<AddEditTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  final _title = TextEditingController();
  final _desc = TextEditingController();
  DateTime? _date;
  TimeOfDay? _time;
  TaskPriority _priority = TaskPriority.medium;
  bool _reminder = false;
  bool get _isEdit => widget.args?.taskId != null;

  @override
  void initState() {
    super.initState();
    if (_isEdit) {
      final t = mockTasks.firstWhere((e) => e.id == widget.args!.taskId);
      _title.text = t.title;
      _desc.text = t.description ?? '';
      _priority = t.priority;
      _reminder = t.reminder;
      if (t.dueDate != null) {
        _date = DateTime(t.dueDate!.year, t.dueDate!.month, t.dueDate!.day);
        _time = TimeOfDay.fromDateTime(t.dueDate!);
      }
    }
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final res = await showDatePicker(
      context: context,
      firstDate: now,
      lastDate: DateTime(now.year + 2),
      initialDate: _date ?? now,
      helpText: 'Selecciona fecha',
      locale: const Locale('es'),
    );
    if (res != null) setState(() => _date = res);
  }

  Future<void> _pickTime() async {
    final res = await showTimePicker(context: context, initialTime: _time ?? TimeOfDay.now());
    if (res != null) setState(() => _time = res);
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;

    DateTime? due;
    if (_date != null) {
      final t = _time ?? const TimeOfDay(hour: 9, minute: 0);
      due = DateTime(_date!.year, _date!.month, _date!.day, t.hour, t.minute);
    }

    if (_isEdit) {
      final t = mockTasks.firstWhere((e) => e.id == widget.args!.taskId);
      t
        ..title = _title.text.trim()
        ..description = _desc.text.trim().isEmpty ? null : _desc.text.trim()
        ..priority = _priority
        ..reminder = _reminder
        ..dueDate = due;
    } else {
      final newTask = Task(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: _title.text.trim(),
        description: _desc.text.trim().isEmpty ? null : _desc.text.trim(),
        priority: _priority,
        reminder: _reminder,
        dueDate: due,
      );
      mockTasks.insert(0, newTask);
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(_isEdit ? 'Tarea actualizada' : '¡Tarea guardada!')),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
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
                    onPressed: _title.text.trim().isEmpty ? null : _save,
                    child: const Text('Guardar', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                  ),
                ],
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Align(
              alignment: Alignment.center,
              child: Text(
                _isEdit ? 'Editar Tarea' : 'Nueva Tarea',
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
              ),
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 120),
              child: Form(
                key: _formKey,
                onChanged: () => setState(() {}),
                child: Column(
                  children: [
                    TextFormField(
                      controller: _title,
                      decoration: const InputDecoration(labelText: 'Título *', hintText: '¿Qué necesitas hacer?'),
                      maxLength: 100,
                      validator: (v) => (v == null || v.trim().isEmpty) ? 'El título es obligatorio' : null,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _desc,
                      decoration: const InputDecoration(labelText: 'Descripción', hintText: 'Añade más detalles (opcional)'),
                      maxLength: 300,
                      minLines: 3,
                      maxLines: 6,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: _pickDate,
                            icon: const Icon(Icons.calendar_today),
                            label: Text(_date == null ? 'Fecha' : '${_date!.day}/${_date!.month}/${_date!.year}'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: _pickTime,
                            icon: const Icon(Icons.access_time),
                            label: Text(_time == null ? 'Hora' : _time!.format(context)),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // Prioridad
                    Row(
                      children: [
                        Expanded(child: _PriorityTile(label: 'Alta', value: TaskPriority.high, group: _priority, onChanged: (v) => setState(() => _priority = v))),
                        const SizedBox(width: 8),
                        Expanded(child: _PriorityTile(label: 'Media', value: TaskPriority.medium, group: _priority, onChanged: (v) => setState(() => _priority = v))),
                        const SizedBox(width: 8),
                        Expanded(child: _PriorityTile(label: 'Baja', value: TaskPriority.low, group: _priority, onChanged: (v) => setState(() => _priority = v))),
                      ],
                    ),
                    const SizedBox(height: 16),
                    SwitchListTile(
                      value: _reminder,
                      onChanged: (v) => setState(() => _reminder = v),
                      title: const Text('Recordatorio'),
                      subtitle: const Text('Recibir notificación antes de la fecha'),
                    ),
                  ],
                ),
              ),
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
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    child: Text('Cancelar'),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: FilledButton(
                  onPressed: _title.text.trim().isEmpty ? null : _save,
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    child: Text('Guardar Tarea'),
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

class _PriorityTile extends StatelessWidget {
  final String label;
  final TaskPriority value;
  final TaskPriority group;
  final ValueChanged<TaskPriority> onChanged;

  const _PriorityTile({required this.label, required this.value, required this.group, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final selected = value == group;
    return InkWell(
      onTap: () => onChanged(value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: selected ? AppTheme.primary : Colors.white,
          border: Border.all(color: const Color(0xFFE5E7EB), width: 2),
          borderRadius: BorderRadius.circular(12),
        ),
        alignment: Alignment.center,
        child: Text(label, style: TextStyle(color: selected ? Colors.white : const Color(0xFF374151), fontWeight: FontWeight.w600)),
      ),
    );
  }
}