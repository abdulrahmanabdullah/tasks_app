import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import '../data/task_database.dart';
import 'widget/new_task_input_widget.dart';
import 'widget/warning_dialog.dart';
import 'widget/when_screen_empty.dart';
import 'widget/new_tag_input.dart';
import '../app_localizations.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // to filter completed and not completed task
  bool isCompleteTask = false;
  // check  table empty or not
  bool isEmpty = false;

  // when empty table appear this message
  String _message = "Empty Add/OR compete some";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          // Localization this text
            AppLocalizations.of(context).translate("app_title")),
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
          NewTagInputWidget(),
        ],
      ),
    );
  }

  StreamBuilder<List<TaskWithTag>> _buildTaskList(context) {
    final dao = Provider.of<TaskDao>(context);
    return StreamBuilder(
      stream: isCompleteTask
          ? dao.watchAllCompletedTaskWithTag()
          : dao.watchAllTaskWithTag(),
      builder: (context, AsyncSnapshot<List<TaskWithTag>> snapshot) {
        final tasks = snapshot.data ?? List();
        // check table empty or not if yes build beaut shape 😃
        isEmpty = _isTableEmpty(tasks);
        return isEmpty
            ? WhenScreenEmptyWidget(_message)
            : ListView.builder(
                itemCount: tasks.length,
                itemBuilder: (_, index) {
                  final task = tasks[index];
                  return _buildListItem(task, dao,index + 1);
                });
      },
    );
  }

  Widget _buildListItem(TaskWithTag item, TaskDao database,int index) {
    return Slidable(
      actions: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(item.tag.name),
        ),
      ],
      actionPane: SlidableDrawerActionPane(),
      secondaryActions: <Widget>[
        IconSlideAction(
          caption: 'delete',
          color: Colors.red,
          icon: Icons.delete,
          onTap: () => database.deleteTask(item.task),
        ),
      ],
      child: CheckboxListTile(
          title: Text(item.task.name),
          subtitle: Text(item.task.dueDate?.toString() ?? 'No Date'),
          value: item.task.isCompleted,
          secondary: _buildTag(item.tag,index),
          onChanged: (value) {
            database.updateTask(item.task.copyWith(isCompleted: value));
          }),
    );
  }

  Column _buildTag(Tag tag,int index) {
    assert(tag != null);
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
//      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        if (tag != null) ...[
          Container(
            child: Center(
              child: Text(index.toString(),style: TextStyle(color: Colors.white),),

            ),
            width: 35,
            height: 35,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Color(tag.color),
            ),
          ),
        ]
      ],
    );
  }

  Widget _buildCompleteOnlySwitch() {
    return Row(
      children: <Widget>[
        Text(AppLocalizations.of(context).translate("complete_task")),
        Switch(
          value: isCompleteTask,
          activeColor: Colors.white,
          onChanged: (value) {
            setState(() => isCompleteTask = value);
          },
        ),
      ],
    );
  }

  // check table - tasks - it's empty or not.
  bool _isTableEmpty(List<TaskWithTag> tasks) {
    return tasks.isEmpty;
  }
}

// For PopupMenuItem, you can add more if you need.
enum PopupChoice { deleteAll }
