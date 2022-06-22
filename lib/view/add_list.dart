import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:todo/helpers/database.dart';
import 'package:todo/models/tables.dart';
import 'package:todo/templates/builder.dart';

final db = DatabaseHelper.instance;

class AddList extends StatefulWidget {
  @override
  _AddListState createState() => _AddListState();
}

class _AddListState extends State<AddList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          title: const Text('New List'),
          titleTextStyle: const TextStyle(
              fontSize: 30, color: Colors.black, fontWeight: FontWeight.bold),
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back),
            color: Colors.black,
          ),
        ),
        body: Column(children: [
          Container(
              //margin: const EdgeInsets.all(30.0),
              padding: const EdgeInsets.all(10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: const [
                  Text(
                    'Add the name of your list ',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 18,
                    ),
                  ),
                  MyCustomForm(),
                ],
              )),
        ]));
  }
}

/// Create a Form widget.
class MyCustomForm extends StatefulWidget {
  const MyCustomForm({super.key});

  @override
  MyCustomFormState createState() {
    return MyCustomFormState();
  }
}

// Create a corresponding State class.
// This class holds data related to the form.
class MyCustomFormState extends State<MyCustomForm> {
  String? title;
  late int listColor;
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a GlobalKey<FormState>,
  // not a GlobalKey<MyCustomFormState>.
  final _formKey = GlobalKey<FormState>();
  final myController = TextEditingController();
  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    listColor = Colors.blue.value;
    super.initState();
  }

  void onColor(Color color) {
    setState(() {
      listColor = color.value;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            style: const TextStyle(fontSize: 40),
            controller: myController,
            // The validator receives the text that the user has entered.
            decoration: const InputDecoration(
              // labelText: "List Title",
              // labelStyle: TextStyle(color: Color(listColor)),
              hintText: 'Your Title',
              border: InputBorder.none,
              hintStyle: TextStyle(color: Colors.grey),
            ),
            cursorColor: Color(listColor),
            keyboardType: TextInputType.text,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter some text';
              }
              return null;
            },
          ),
          ColorBuilder(onColor),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: ElevatedButton(
                onPressed: () {
                  // Validate returns true if the form is valid, or false otherwise.
                  if (_formKey.currentState!.validate()) {
                    // MyNotification(myController.text).dispatch(context);
                    Navigator.pop(context, [myController.text, listColor]);
                  }
                },
                style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(Color(listColor)),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50.0),
                            side: BorderSide(color: Color(listColor))))),
                child: const Text('Create List')),
          ),
        ],
      ),
    );
  }
}

class MyNotification extends Notification {
  final String title;
  MyNotification(this.title);
}
