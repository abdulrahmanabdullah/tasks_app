import 'package:flutter/material.dart';
import 'package:moor/moor.dart';
import 'package:provider/provider.dart';
import '../../data/todo_database.dart';

class NewTaskInput extends StatefulWidget {
  @override
  _NewTaskInputState createState() => _NewTaskInputState();
}

class _NewTaskInputState extends State<NewTaskInput> {
  // date value
  DateTime taskDate;

  // Controller of task name
  TextEditingController controller;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      child: Row(
        // set full width
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          _buildTextField(context),
          _buildDateButton(context),
        ],
      ),
    );
  }

  // Build text field widget ...
  Expanded _buildTextField(context) {
    return Expanded(
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: "Task name",
        ),
        onSubmitted: (newTaskName) {
          final database = Provider.of<TaskDao>(context);
          final task = TasksCompanion(
              name: Value(newTaskName), dueDate: Value(taskDate));
          database.insertTask(task);
          _resetValuesAfterSubmit();
        },
      ),
    );
  }

  // Build date icon
  IconButton _buildDateButton(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.calendar_today),
      onPressed: () async {
        taskDate = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2018),
            lastDate: DateTime(2020));
      },
    );
  }

  // set empty value in text filed and null of date ...
  void _resetValuesAfterSubmit() {
    setState(() {
      taskDate = null;
      controller.clear();
    });
  }
}
