import 'package:flutter/material.dart';
import 'package:todo/templates/builder.dart';
import 'package:todo/helpers/database.dart';
import 'package:todo/models/tables.dart';
import 'package:todo/view/list_screen.dart';

final db = DatabaseHelper.instance;

class TaskDoneScreen extends StatefulWidget {
  @override
  _DoneState createState() => _DoneState();
}

class _DoneState extends State<TaskDoneScreen> {
  late Future<List<TaskList>> list;
  @override
  void initState() {
    super.initState();
    list = db.getCompletedList();
  }

  void onRefresh() {
    setState(() {
      list = db.getCompletedList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: Column(children: [
      titleBuilder('Done', 'List'),
      FutureBuilder<List<TaskList>>(
          future: list,
          builder:
              (BuildContext context, AsyncSnapshot<List<TaskList>> snapshot) {
            if (snapshot.hasData) {
              return BuildList(snapshot.data!, onRefresh);
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}');
            }
            return const CircularProgressIndicator();
          }),
    ])));
  }
}
