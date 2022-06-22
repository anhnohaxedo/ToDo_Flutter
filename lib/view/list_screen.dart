import 'package:flutter/material.dart';
import 'package:todo/helpers/database.dart';
import 'package:todo/models/tables.dart';
import 'package:todo/view/add_list.dart';
import 'package:todo/view/task_screen.dart';
import 'package:todo/templates/builder.dart';
import 'package:todo/models/models.dart';
import 'package:todo/view/done_screen.dart';

final db = DatabaseHelper.instance;

class HomeScreen extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<HomeScreen> {
  late Future<List<TaskList>> list;
  @override
  void initState() {
    list = db.getIncompleteList();
    super.initState();
  }

  @override
  void didUpdateWidget(covariant HomeScreen oldWidget) {
    list = db.getIncompleteList();
    super.didUpdateWidget(oldWidget);
  }

  void onChange() {
    setState(() {
      list = db.getIncompleteList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            titleBuilder('ToDo', 'List'),
            ElevatedButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => AddList())).then(
                    (value) {
                      db.insertList(TaskList(
                          title: value[0], amount: value[1], workload: 0));
                      onChange();
                    },
                  );
                },
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.white),
                    elevation: MaterialStateProperty.all(5),
                    side: MaterialStateProperty.all(
                        const BorderSide(color: Colors.black))),
                child: const Icon(
                  Icons.add,
                  color: Colors.black,
                )),
            FutureBuilder<List<TaskList>>(
                future: list,
                builder: (BuildContext context,
                    AsyncSnapshot<List<TaskList>> snapshot) {
                  if (snapshot.hasData) {
                    return BuildList(snapshot.data!, onChange);
                  } else if (snapshot.hasError) {
                    return Text('${snapshot.error}');
                  }
                  return const CircularProgressIndicator();
                }),
          ],
        ),
      ),
    );
  }
}

class BuildList extends StatefulWidget {
  final List<TaskList> list;
  BuildList(this.list, this.onChange) : super(key: ObjectKey(list));
  final Function onChange;
  @override
  _ListState createState() => _ListState();
}

class _ListState extends State<BuildList> {
  late List<TaskList> list;
  @override
  void initState() {
    super.initState();
    list = widget.list;
  }

  @override
  Widget build(BuildContext context) {
    // NotificationListener<MyNotification>(
    //   onNotification: onInsertList,
    //   child: Container(),
    // );
    return SizedBox(
        height: 300.0,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemBuilder: (BuildContext context, int index) {
            return ListItem(db.getTaskOfList(widget.list[index].id),
                widget.list[index], widget.onChange);
          },
          separatorBuilder: (BuildContext context, int index) => const Divider(
            indent: 10.0,
            thickness: 10.0,
          ),
          itemCount: widget.list.length,
        ));
  }
}

class ListItem extends StatefulWidget {
  final Future<List<Task>> tasks;
  final TaskList list;
  final Function onRefresh;
  ListItem(this.tasks, this.list, this.onRefresh) : super(key: ValueKey(tasks));
  @override
  _ItemState createState() => _ItemState();
}

class _ItemState extends State<ListItem> {
  late Future<List<Task>> tasks;
  @override
  void initState() {
    super.initState();
    tasks = widget.tasks;
  }

  void onTask(String action, List<Task> values) {
    switch (action) {
      case 'delete':
        for (var task in values) {
          db.deleteTask(task);
        }
        db.deleteList(widget.list);
        widget.onRefresh();
        break;
      case 'add':
        setState(() {
          tasks = db.getTaskOfList(widget.list.id);
          widget.onRefresh();
        });
        break;
      case 'update':
        db.updateTask(Task(
            id: values[0].id,
            title: values[0].title,
            description: values[0].description,
            priority: values[0].priority,
            done: values[0].done,
            listId: values[0].listId));
        setState(() {
          tasks = db.getTaskOfList(widget.list.id);
        });
        break;
      default:
        tasks = db.getTaskOfList(widget.list.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Task>>(
      future: tasks,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          return GestureDetector(
              onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  TaskScreen(snapshot.data, widget.list)))
                      .then((value) {
                    if (value != null) {
                      onTask(value[0], value[1]);
                    }
                  }),
              child: _buildTask(snapshot.data, widget.list,
                  (Task task) => onTask('update', [task])));
        } else if (snapshot.data == null) {
          return const Text("You haven't created any list yet!");
        } else if (snapshot.hasError) {
          return Text('${snapshot.error}');
        }
        return const CircularProgressIndicator();
      },
    );
  }
}

Widget _buildTask(List<Task> tasks, TaskList list, Function onUpdate) {
  return Container(
      // decoration: const BoxDecoration(
      //     borderRadius: BorderRadius.all(Radius.circular(0.5))),
      margin: const EdgeInsets.all(8.0),
      //height: 200.0,
      width: 150.0,
      decoration: BoxDecoration(
        color: Color(list.amount),
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: const [
          BoxShadow(
            color: Colors.grey,
            spreadRadius: 1,
            blurRadius: 2,
            offset: Offset(0.0, 0.05),
          ),
        ],
      ),
      child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(list.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    fontSize: 19.0,
                  )),
              const Divider(
                thickness: 3,
                color: Colors.white,
                indent: 60,
              ),
              ColumnBuilder(
                  itemBuilder: (BuildContext context, int index) =>
                      BlockBuilder(
                        tasks[index],
                        onUpdate,
                        disable: true,
                        colorText: Colors.white,
                        //colorTheme: Color(list.amount),
                      ),
                  itemCount: tasks.length > 3 ? 3 : tasks.length),
            ],
          )));
}
