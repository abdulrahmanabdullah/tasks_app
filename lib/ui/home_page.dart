import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import '../data/todo_database.dart';
import 'widget/new_task_input_widget.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  bool isCompleteTask = false;

  PopupChoice _select ;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("ToDo App"),
        actions: <Widget>[
          _buildCompleteOnlySwitch(),
          PopupMenuButton<PopupChoice>(
            onSelected:(PopupChoice pChoice){
              setState(() {
                _select = pChoice ;
                _deleteAllTask(_select);
              });
            },
            itemBuilder: (context)=>[
              PopupMenuItem<PopupChoice>(
                value: PopupChoice.deleteAll,
                child: Text("Delete All"),
              ),
              PopupMenuItem<PopupChoice>(
                value: PopupChoice.add,
                child: Text("Add "),
              ),
            ] ,
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          Expanded(child: _buildTaskList(context)),
          NewTaskInput(),
        ],
      ),
    );
  }

  StreamBuilder<List<Task>> _buildTaskList(context) {
    final dao = Provider.of<TaskDao>(context);
    return StreamBuilder(
      stream: isCompleteTask ? dao.watchCompletedTaskGeneratedQueryStatement() : dao.watchAllTask(),
      builder: (context, AsyncSnapshot<List<Task>> snapshot) {
        final tasks = snapshot.data ?? List();

        return ListView.builder(
            itemCount: tasks.length,
            itemBuilder: (_, index) {
              final task = tasks[index];
              return _buildListItem(task, dao);
            }
        );
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
            setState(() => isCompleteTask = value );
          },
        ),
      ],
    );
  }

  void _deleteAllTask(PopupChoice choice){
    print(choice);
  }
}

enum PopupChoice{deleteAll,add}

