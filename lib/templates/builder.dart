import 'package:flutter/material.dart';
import 'package:todo/models/tables.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:todo/helpers/database.dart';

final db = DatabaseHelper.instance;
Widget titleBuilder(String title, String sub) {
  return Row(children: [
    const Expanded(
      child: Divider(
        height: 20,
        thickness: 1,
        color: Colors.black,
      ),
    ),
    Padding(
      padding: const EdgeInsets.all(40.0),
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: title,
              style: const TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.w900,
                color: Colors.black,
              ),
            ),
            TextSpan(
              text: sub,
              style: const TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.normal,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    ),
    const Expanded(
      child: Divider(
        height: 20,
        thickness: 1,
        color: Colors.black,
      ),
    )
  ]);
}

class ColumnBuilder extends StatelessWidget {
  final IndexedWidgetBuilder itemBuilder;
  final MainAxisAlignment mainAxisAlignment;
  final MainAxisSize mainAxisSize;
  final CrossAxisAlignment crossAxisAlignment;
  final TextDirection textDirection;
  final VerticalDirection verticalDirection;
  final int itemCount;

  ColumnBuilder({
    required this.itemBuilder,
    required this.itemCount,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.mainAxisSize = MainAxisSize.max,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.textDirection = TextDirection.ltr,
    this.verticalDirection = VerticalDirection.down,
  }) : super(key: ObjectKey(itemBuilder));

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(itemCount, (index) => itemBuilder(context, index))
          .toList(),
    );
  }
}

class BlockBuilder extends StatefulWidget {
  Task task;
  //final Color colorTheme;
  final Color colorText;
  final Function onCallBack;
  final bool disable;
  BlockBuilder(
    this.task,
    this.onCallBack, {
    this.disable = false,
    //required this.colorTheme,
    required this.colorText,
  }) : super(key: ObjectKey(task));
  @override
  _BlockState createState() => _BlockState();
}

class _BlockState extends State<BlockBuilder> {
  late bool check;
  @override
  void initState() {
    check = widget.task.done;
    super.initState();
  }

  onTick() {
    widget.onCallBack(Task(
        id: widget.task.id,
        title: widget.task.title,
        description: widget.task.description,
        priority: widget.task.priority,
        done: check,
        listId: widget.task.listId));
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(
          shape: const CircleBorder(),
          value: check,
          fillColor:
              MaterialStateProperty.resolveWith((states) => widget.colorText),
          onChanged: (value) {
            if (widget.disable == false) {
              setState(() {
                check = !check;
                onTick();
              });
            }
          },
        ),
        Column(
          children: [
            Text(
              widget.task.title,
              style: TextStyle(
                color: widget.colorText,
                fontWeight: FontWeight.w500,
                fontSize: 19.0,
                decoration: check ? TextDecoration.lineThrough : null,
                decorationThickness: 3.0,
              ),
            ),
            Text(
              widget.task.description.toString(),
              style: TextStyle(
                color: widget.colorText,
                fontWeight: FontWeight.w300,
                fontSize: 10.0,
                decoration: check ? TextDecoration.lineThrough : null,
                decorationThickness: 1.0,
              ),
            ),
          ],
        )
      ],
    );
  }
}

class ColorBuilder extends StatefulWidget {
  final Function onColor;
  Color? color;
  ColorBuilder(this.onColor, {this.color}) : super(key: ValueKey(onColor));
  @override
  _ColorState createState() => _ColorState();
}

class _ColorState extends State<ColorBuilder> {
  Color pickerColor = Colors.blue;
  Color currentColor = Colors.blue;
  @override
  void initState() {
    if (widget.color != null) {
      pickerColor = widget.color!;
      currentColor = widget.color!;
    }
    super.initState();
  }

  void changeColor(Color color) {
    setState(() => pickerColor = color);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: () {
        showDialog(
            context: context,
            useSafeArea: true,
            builder: (BuildContext context) => AlertDialog(
                  title: const Text('Pick a color!'),
                  content: SingleChildScrollView(
                    child: ColorPicker(
                      pickerColor: pickerColor,
                      onColorChanged: changeColor,
                    ),
                  ),
                  actions: [
                    ElevatedButton(
                      child: const Text('Got it'),
                      onPressed: () {
                        setState(() => currentColor = pickerColor);
                        Navigator.of(context).pop(widget.onColor(currentColor));
                      },
                    ),
                  ],
                ));
      },
      shape: const CircleBorder(),
      color: currentColor,
    );
  }
}


// ValueChanged<Color> callback


// raise the [showDialog] widget
