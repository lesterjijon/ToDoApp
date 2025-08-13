import 'package:todoapp/models/task.dart';

final mockTasks = <Task>[
  Task(
    id: '1',
    title: 'Completar presentación del proyecto',
    description: 'Preparar slides para la reunión del viernes con el equipo',
    dueDate: DateTime.now().copyWith(hour: 14, minute: 0),
    priority: TaskPriority.high,
  ),
  Task(
    id: '2',
    title: 'Comprar ingredientes para cena',
    description: 'Tomates, pasta, queso parmesano',
    completed: true,
    priority: TaskPriority.medium,
    dueDate: DateTime.now().subtract(const Duration(days: 1)),
  ),
  Task(
    id: '3',
    title: 'Llamar al dentista',
    description: 'Agendar cita para limpieza dental',
    priority: TaskPriority.low,
    dueDate: DateTime.now().add(const Duration(days: 1)).copyWith(hour: 10),
  ),
  Task(
    id: '4',
    title: 'Revisar correos pendientes',
    priority: TaskPriority.low,
  ),
  Task(
    id: '5',
    title: 'Hacer ejercicio',
    description: 'Rutina de 30 minutos',
    completed: true,
    priority: TaskPriority.medium,
    dueDate: DateTime.now(),
  ),
];