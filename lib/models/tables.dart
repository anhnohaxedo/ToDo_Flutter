class Task {
  final int? id;
  final String title;
  final String description;
  final int priority;
  final bool done;
  final int? listId;
  const Task(
      {this.id,
      required this.title,
      required this.description,
      required this.priority,
      required this.done,
      required this.listId});
  Map<String, Object?> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'priority': priority,
        'done': done ? 1 : 0,
        'list_id': listId,
      };
  static Task fromJson(Map<String, Object?> json) => Task(
        id: json['id'] as int?,
        title: json['title'] as String,
        description: json['description'] as String,
        priority: json['priority'] as int,
        done: json['done'] == 1,
        listId: json['list_id'] as int,
      );
}

class TaskList {
  final int? id;
  final String title;
  final int amount;
  final double workload;
  const TaskList(
      {this.id,
      required this.title,
      required this.amount,
      required this.workload});
  Map<String, Object?> toJson() => {
        'id': id,
        'title': title,
        'amount': amount,
        'workload': workload,
      };
  static TaskList fromJson(Map<String, Object?> json) => TaskList(
        id: json['id'] as int?,
        title: json['title'] as String,
        amount: json['amount'] as int,
        workload: json['workload'] as double,
      );
}
