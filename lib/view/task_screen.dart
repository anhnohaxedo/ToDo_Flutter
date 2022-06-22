import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:todo/models/tables.dart';
import 'package:todo/templates/builder.dart';
import 'package:todo/helpers/database.dart';

final db = DatabaseHelper.instance;

class TaskScreen extends StatefulWidget {
  final List<Task> tasks;
  final TaskList list;
  TaskScreen(this.tasks, this.list) : super(key: ObjectKey(tasks));
  @override
  _TaskState createState() => _TaskState();
}

class _TaskState extends State<TaskScreen> {
  late List<Task> tasks;
  late TaskList list;
  late TextEditingController dialogController;
  late Future<List<Task>> futureTasks;
  late double workload;
  late Color currentColor;
  @override
  void initState() {
    futureTasks = db.getTaskOfList(widget.list.id);
    tasks = widget.tasks;
    list = widget.list;
    workload = widget.list.workload;
    currentColor = Color(list.amount);
    dialogController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    dialogController.dispose();
    super.dispose();
  }

  void add(Task task) {
    db.insertTask(task);
    Navigator.of(context).pop();
    dialogController.clear();
    setState(() {
      workload = (workload * tasks.length) / (tasks.length + 1);
      tasks.add(task);
      futureTasks = db.getTaskOfList(widget.list.id);
    });
  }

  void onUpdate(Task task) {
    db.updateTask(task);
    double count = workload;
    if (task.done == true) {
      count += 1 / tasks.length;
    } else {
      count -= 1 / tasks.length;
    }
    setState(() {
      workload = count;
      futureTasks = db.getTaskOfList(widget.list.id);
    });
  }

  void onColor(Color color) {
    setState(() {
      currentColor = color;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 18.0),
          child: Column(children: [
            ListTile(
              leading: ColorBuilder(
                onColor,
                color: currentColor,
              ),
              trailing: IconButton(
                  onPressed: () {
                    db.updateList(TaskList(
                        id: widget.list.id,
                        title: widget.list.title,
                        amount: currentColor.value,
                        workload: workload));
                    Navigator.pop(context, ['add', tasks]);
                  },
                  tooltip: 'Go back',
                  icon: Icon(Icons.backspace_rounded, color: currentColor)),
            ),
            Container(
                margin: const EdgeInsets.all(20.0),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            widget.list.title,
                            style: const TextStyle(
                              fontSize: 36,
                              fontWeight: FontWeight.w900,
                              color: Colors.black,
                            ),
                          ),
                          IconButton(
                              onPressed: () =>
                                  Navigator.pop(context, ['delete', tasks]),
                              icon: Icon(Icons.delete, color: currentColor)),
                        ],
                      ),
                      Text(
                        '${(tasks.length * workload).round()} of ${tasks.length} tasks',
                        textAlign: TextAlign.start,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                            fontSize: 20.0),
                      ),
                      Row(children: [
                        Flexible(
                            fit: FlexFit.loose,
                            child: LinearProgressIndicator(
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(currentColor),
                              backgroundColor: currentColor.withAlpha(50),
                              value: workload,
                            )),
                        Text(
                          '   ${(workload * 100).round()} %',
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              fontSize: 20.0),
                        )
                      ]),
                    ])),
            FutureBuilder(
                future: futureTasks,
                builder:
                    (BuildContext context, AsyncSnapshot<List<Task>> snapshot) {
                  if (snapshot.hasData) {
                    return Expanded(
                        child: ListView.separated(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) => BlockBuilder(
                        snapshot.data![index],
                        onUpdate,
                        colorText: Colors.black,
                        //colorTheme: Color(list.amount),
                      ),
                      separatorBuilder: (context, index) => const Divider(
                        indent: 10.0,
                      ),
                    ));
                  } else if (snapshot.hasError) {
                    return Text('${snapshot.error}');
                  }
                  return const CircularProgressIndicator();
                }),
            ElevatedButton.icon(
                style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50.0),
                            side: BorderSide(color: currentColor))),
                    backgroundColor: MaterialStateProperty.all(currentColor)),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                      title: const Text('Add more task'),
                      content: TextField(
                        controller: dialogController,
                        decoration: const InputDecoration(hintText: 'Task'),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => add(Task(
                              title: dialogController.text,
                              description: 'Nothing',
                              priority: 1,
                              done: false,
                              listId: list.id)),
                          style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(currentColor)),
                          child: const Text('Add',
                              style: TextStyle(color: Colors.white)),
                        )
                      ],
                    ),
                    useSafeArea: true,
                  );
                },
                icon: const Icon(Icons.add),
                label: const Text('New Task'))
          ]),
        ),
      ),
    );
  }
}
