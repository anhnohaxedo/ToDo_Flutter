import 'package:flutter/material.dart';
import 'package:todo/templates/builder.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class SettingScreen extends StatefulWidget {
  @override
  _SettingState createState() => _SettingState();
}

class _SettingState extends State<SettingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: Column(children: [
      titleBuilder('Task', 'Settings'),
      Container(
          height: 200.0,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 5,
                blurRadius: 7,
                offset: const Offset(0, 3), // changes position of shadow
              ),
            ],
          ),
          padding: const EdgeInsets.all(10.0),
          margin: const EdgeInsets.all(10.0),
          child: ListView(
            children: [
              const ListTile(
                leading: Icon(Icons.verified),
                title: Text('Version'),
                trailing: Text('1.0.0'),
              ),
              ListTile(
                leading: const Icon(Icons.star),
                title: const Text('Rating'),
                trailing: IconButton(
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                              title: const Text(
                                'Ratings',
                                textAlign: TextAlign.center,
                              ),
                              content: RatingBar.builder(
                                initialRating: 3,
                                minRating: 1,
                                direction: Axis.horizontal,
                                allowHalfRating: true,
                                itemCount: 5,
                                itemPadding:
                                    const EdgeInsets.symmetric(horizontal: 4.0),
                                itemBuilder: (BuildContext context, _) =>
                                    const Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                ),
                                onRatingUpdate: (rating) {},
                              ),
                              actions: [
                                ElevatedButton(
                                  child: const Text('Submit'),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            ));
                  },
                  icon: const Icon(Icons.arrow_right),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.share),
                title: const Text('Share'),
                trailing: IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.arrow_right),
                ),
              )
            ],
          )),
    ])));
  }
}
