import 'package:flutter/material.dart';
import 'package:todoapp/app_theme.dart';
import 'package:todoapp/data/mock_tasks.dart';
import 'package:todoapp/models/task.dart';
import 'package:todoapp/routes.dart';
import 'package:todoapp/widgets/task_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

enum _Filter { all, pending, completed }

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _search = TextEditingController();
  _Filter _filter = _Filter.all;
  late List<Task> _tasks;

  @override
  void initState() {
    super.initState();
    _tasks = List.of(mockTasks);
  }

  List<Task> get _visibleTasks {
    final q = _search.text.toLowerCase().trim();
    Iterable<Task> list = _tasks;
    if (q.isNotEmpty) {
      list = list.where((t) =>
          t.title.toLowerCase().contains(q) ||
          (t.description ?? '').toLowerCase().contains(q));
    }
    switch (_filter) {
      case _Filter.pending: list = list.where((t) => !t.completed);
      case _Filter.completed: list = list.where((t) => t.completed);
      case _Filter.all: break;
    }
    return list.toList();
  }

  void _toggle(Task t) {
    setState(() => t.completed = !t.completed);
  }

  @override
  Widget build(BuildContext context) {
    final completedCount = _tasks.where((t) => t.completed).length;

    return Scaffold(
      body: Column(
        children: [
          // Header con gradiente
          Container(
            decoration: AppTheme.headerGradient(),
            padding: const EdgeInsets.only(top: 64, left: 20, right: 20, bottom: 20),
            width: double.infinity,
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text('Mis Tareas', style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.w700)),
                SizedBox(height: 6),
                Opacity(
                  opacity: 0.9,
                  child: Text('Organiza tu día', style: TextStyle(color: Colors.white, fontSize: 16)),
                ),
              ],
            ),
          ),

          // Buscador + filtros
          Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
            child: Column(
              children: [
                TextField(
                  controller: _search,
                  onChanged: (_) => setState(() {}),
                  decoration: const InputDecoration(
                    hintText: 'Buscar tareas...',
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    _FilterChip(
                      label: 'Todas',
                      selected: _filter == _Filter.all,
                      onSelected: () => setState(() => _filter = _Filter.all),
                    ),
                    const SizedBox(width: 8),
                    _FilterChip(
                      label: 'Pendientes',
                      selected: _filter == _Filter.pending,
                      onSelected: () => setState(() => _filter = _Filter.pending),
                    ),
                    const SizedBox(width: 8),
                    _FilterChip(
                      label: 'Completadas',
                      selected: _filter == _Filter.completed,
                      onSelected: () => setState(() => _filter = _Filter.completed),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Contador
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            width: double.infinity,
            child: Text('${_tasks.length} tareas • $completedCount completadas',
                style: const TextStyle(color: Color(0xFF6B7280), fontSize: 14)),
          ),

          // Lista
          Expanded(
            child: _visibleTasks.isEmpty
                ? const Center(
                    child: Padding(
                      padding: EdgeInsets.all(24),
                      child: Text('Sin resultados', style: TextStyle(color: Color(0xFF6B7280))),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.only(bottom: 100),
                    itemCount: _visibleTasks.length,
                    itemBuilder: (ctx, i) {
                      final t = _visibleTasks[i];
                      return TaskCard(
                        task: t,
                        onToggle: () => _toggle(t),
                        onTap: () => Navigator.pushNamed(context, AppRoutes.details, arguments: t.id),
                      );
                    },
                  ),
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, AppRoutes.addEdit)
            .then((value) => setState(() {})),
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onSelected;
  const _FilterChip({required this.label, required this.selected, required this.onSelected, super.key});

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) => onSelected(),
      selectedColor: AppTheme.primary,
      labelStyle: TextStyle(color: selected ? Colors.white : const Color(0xFF374151)),
      side: const BorderSide(color: Color(0xFFE2E8F0), width: 2),
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    );
  }
}