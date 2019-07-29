import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import '../data/task_database.dart';
import 'widget/new_task_input_widget.dart';
import 'widget/warning_dialog.dart';
import 'widget/when_screen_empty.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isCompleteTask = false;
  bool isEmpty;

   String _message = "Add some";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Tasks"),
        actions: <Widget>[
          _buildCompleteOnlySwitch(),
          PopupMenuButton<PopupChoice>(
            onSelected: (PopupChoice pChoice) {},
            itemBuilder: (context) => [
                  PopupMenuItem<PopupChoice>(
                    value: PopupChoice.deleteAll,
                    child: ConfirmDeleteDialog(),
                  ),
                ],
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          Expanded(child: _buildTaskList(context)),
          // Input field -> task name and date ..
          NewTaskInput(),
        ],
      ),
    );
  }

  StreamBuilder<List<Task>> _buildTaskList(context) {
    final dao = Provider.of<TaskDao>(context);
    print("Call berfore Stream builder ");
    return StreamBuilder(
      stream: isCompleteTask
          ? dao.watchCompletedTaskGeneratedQueryStatement()
          : dao.watchAllTask(),
      builder: (context, AsyncSnapshot<List<Task>> snapshot) {
        final tasks = snapshot.data ?? List();
        // check table empty or not if it's build beaut shape 😃
        isEmpty = _isTableEmpty(tasks);
        return isEmpty
            ? WhenScreenEmptyWidget(_message)
            : ListView.builder(
                itemCount: tasks.length,
                itemBuilder: (_, index) {
                  final task = tasks[index];
                  return _buildListItem(task, dao);
                });
      },
    );
  }

  Widget _buildListItem(Task task, TaskDao database) {
    return Slidable(
      actionPane: SlidableDrawerActionPane(),
      secondaryActions: <Widget>[
        IconSlideAction(
          caption: 'delete',
          color: Colors.red,
          icon: Icons.delete,
          onTap: () => database.deleteTask(task),
        ),
      ],
      child: CheckboxListTile(
          title: Text(task.name),
          subtitle: Text(task.dueDate?.toString() ?? 'No Date'),
          value: task.isCompleted,
          onChanged: (value) {
            database.updateTask(task.copyWith(isCompleted: value));
          }),
    );
  }

  Widget _buildCompleteOnlySwitch() {
    return Row(
      children: <Widget>[
        Text("Compete Only"),
        Switch(
          value: isCompleteTask,
          activeColor: Colors.white,
          onChanged: (value) {
            setState(() {
              isCompleteTask = value;
            });
          },
        ),
      ],
    );
  }

  // check table - tasks - it's empty or not.
  bool _isTableEmpty(List<Task> tasks) {
    return tasks.isEmpty ;
  }
}

enum PopupChoice { deleteAll }
