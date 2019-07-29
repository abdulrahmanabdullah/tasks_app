import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/task_database.dart';

class ConfirmDeleteDialog extends StatefulWidget {
  @override
  _ConfirmDeleteDialogState createState() => _ConfirmDeleteDialogState();
}

class _ConfirmDeleteDialogState extends State<ConfirmDeleteDialog> {

  bool isTableEmpty = true;


  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _checkBeforeDelete();
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text("Delete All"),
      leading: Icon(Icons.warning),
      onTap: () {
        _showDialog(context);
      },
    );
  }



  Future _showDialog(context) {
    return showDialog(
        context: context,
        builder: (context) {
          return _buildAlertDialog(isTableEmpty);
        });
  }

  Widget _buildAlertDialog(bool status) {
    _checkBeforeDelete();
    return status ? AlertDialog(
      title: Text("Not found data"),
      content: Text("You dont have task, Please add some"),
      actions: <Widget>[
        FlatButton(
          textColor: Theme
              .of(context)
              .accentColor,
          child: Text("Ok!"),
          onPressed: () => Navigator.pop(context),
        ),
      ],
    ) : AlertDialog(
      title: Text("Are you sure ?"),
      content: Text("This well be remove all data"),
      actions: <Widget>[
        FlatButton(
          textColor: Theme
              .of(context)
              .accentColor,
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text("Cancel"),
        ),
        FlatButton(
          textColor: Colors.red,
          onPressed: () {
            _deleteRows(context);
            Navigator.pop(context);
          },
          child: Text("Delete"),
        ),
      ],
    );
  }

  _deleteRows(context) {
    final dao = Provider.of<TaskDao>(context);
    dao.deleteAllRows();
  }




  _checkBeforeDelete(){
    final dao = Provider.of<TaskDao>(context);
    var allTask = dao.getAllTask();
    allTask.then((tasks){
        print("Call check before delete");
        isTableEmpty = tasks.isEmpty ;
    });
  }
}
