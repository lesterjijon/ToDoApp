import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Mis Tareas',
      home: const TaskListScreen(),
    );
  }
}

class TaskListScreen extends StatelessWidget {
  const TaskListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final tasks = [
      {
        "title": "Completar presentación del proyecto",
        "description": "Preparar slides para la reunión del viernes con el equipo",
        "date": "📅 Hoy 14:00",
        "priority": "Alta",
        "priorityColor": Colors.red,
        "completed": false
      },
      {
        "title": "Comprar ingredientes para cena",
        "description": "Lista: tomates, pasta, queso parmesano",
        "date": "📅 Ayer",
        "priority": "Media",
        "priorityColor": Colors.orange,
        "completed": true
      },
      {
        "title": "Llamar al dentista",
        "description": "Agendar cita para limpieza dental",
        "date": "📅 Mañana 10:00",
        "priority": "Baja",
        "priorityColor": Colors.green,
        "completed": false
      },
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Mis Tareas',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text(
              'Organiza tu día',
              style: TextStyle(fontSize: 14),
            ),
          ],
        ),
        centerTitle: false,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: tasks.length,
        itemBuilder: (context, index) {
          final task = tasks[index];
          return Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            margin: const EdgeInsets.only(bottom: 12),
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Checkbox visual
                  Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      color: task["completed"] as bool
                          ? Colors.green
                          : Colors.white,
                      border: Border.all(
                        color: task["completed"] as bool
                            ? Colors.green
                            : Colors.grey.shade400,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: task["completed"] as bool
                        ? const Icon(Icons.check,
                            size: 14, color: Colors.white)
                        : null,
                  ),
                  const SizedBox(width: 12),
                  // Texto
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          task["title"] as String,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            decoration: task["completed"] as bool
                                ? TextDecoration.lineThrough
                                : null,
                            color: task["completed"] as bool
                                ? Colors.grey
                                : Colors.black87,
                          ),
                        ),
                        if ((task["description"] as String).isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Text(
                              task["description"] as String,
                              style: const TextStyle(
                                  fontSize: 14, color: Colors.grey),
                            ),
                          ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: (task["priorityColor"] as Color)
                                    .withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                task["priority"] as String,
                                style: TextStyle(
                                  color: task["priorityColor"] as Color,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              task["date"] as String,
                              style: const TextStyle(
                                  fontSize: 12, color: Colors.grey),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: const Color(0xFF667EEA),
        child: const Icon(Icons.add),
      ),
    );
  }
}