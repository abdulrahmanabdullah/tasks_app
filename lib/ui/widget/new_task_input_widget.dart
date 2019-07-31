import 'package:flutter/material.dart';
import 'package:moor/moor.dart';
import 'package:provider/provider.dart';
import '../../data/task_database.dart';
import '../../app_localizations.dart';

class NewTaskInput extends StatefulWidget {
  @override
  _NewTaskInputState createState() => _NewTaskInputState();
}

class _NewTaskInputState extends State<NewTaskInput> {
  // date value
  DateTime taskDate;

  // Tag name
  Tag selectTag;

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
          _buildTagSelector(context),
          _buildDateButton(context),
        ],
      ),
    );
  }

  // Build text field widget ...
  Expanded _buildTextField(context) {
    return Expanded(
      flex: 1,
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText:AppLocalizations.of(context).translate("task_name"),
        ),
        onSubmitted: (newTaskName) {
          if(selectTag == null){
            _showDialogWhenTagEmpty(context);
          }
          final dao = Provider.of<TaskDao>(context);
          final task = TasksCompanion(
              name: Value(newTaskName),
              dueDate: Value(taskDate),
              tagName: Value(selectTag.name));
          dao.insertTask(task);
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
      selectTag = null;
    });
  }

  // observe tags
  StreamBuilder<List<Tag>> _buildTagSelector(BuildContext context) {
    return StreamBuilder(
      stream: Provider.of<TagDao>(context).watchTags(),
      builder: (context, snapshot) {
        final tags = snapshot.data ?? List();

        final dropdownMenuItems =
        tags.map((tag) => _dropdownMenuFromTag(tag)).toList()
          ..insert(
              0,
              DropdownMenuItem(
                value: null,
                child: Text(AppLocalizations.of(context).translate("no_tag")),
              ));

        return Expanded(
          flex: 1,
          child: Container(
            alignment: Alignment.topCenter,
            padding: EdgeInsets.only(top: 10),
            child: DropdownButton(
              items: dropdownMenuItems,
              onChanged: (Tag tag) {
                setState(() => selectTag = tag);
              },
              isExpanded: false,
              value: selectTag,
            ),
          ),
        );
      },
    );
  }

  // layout of drop down menu tags ..
  DropdownMenuItem<Tag> _dropdownMenuFromTag(Tag tag) {
    return DropdownMenuItem(
      value: tag,
      child: Row(
        children: <Widget>[
          Text(tag.name),
          SizedBox(
            width: 5,
          ),
          Container(
            width: 15,
            height: 15,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Color(tag.color),
            ),
          ),
        ],
      ),
    );
  }

  // alert dialog when user leave tag  empty.
  Future _showDialogWhenTagEmpty(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Fialed adding "),
            content: Text("Please add tag name"),
            actions: <Widget>[
              FlatButton(
                child: Text("Ok"),
                textColor: Colors.indigo,
                onPressed: (){
                Navigator.of(context).pop();
              },),
            ],
          ) ;
        }
    );
  }
}
