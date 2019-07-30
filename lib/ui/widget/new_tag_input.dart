import 'package:flutter/material.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';
import 'package:provider/provider.dart';
import 'package:moor/moor.dart';
import '../../data/task_database.dart';

class NewTagInputWidget extends StatefulWidget {
  @override
  _NewTagInputWidgetState createState() => _NewTagInputWidgetState();
}

class _NewTagInputWidgetState extends State<NewTagInputWidget> {

  static const Color DEFAULT_COLOR = Colors.red ;

  Color pickerTagColor = DEFAULT_COLOR ;

  TextEditingController controller ;

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
        children: <Widget>[
        _buildTextField(context),
        SizedBox(width: 15,),
        _buildColorPickerButton(context),
        ],
      ),
    );
  }

  //TextField Widget
  Flexible _buildTextField(BuildContext context){
    return Flexible(
      flex: 1,
      child: TextField(
        controller: controller,
        decoration: InputDecoration(hintText: 'Tag name'),
        onSubmitted: (inputName){
          final dao = Provider.of<TagDao>(context) ;
          final tag = TagsCompanion(name: Value(inputName),color: Value(pickerTagColor.value));
          dao.insertTag(tag);
          _resetFields();
        },
      ),
    );
  }

  // Color picker widget
  Widget _buildColorPickerButton(BuildContext context) {
    return Flexible(
      flex: 1,
      child: GestureDetector(
        child: Container(
          width: 25,
          height: 25,
          decoration:
          BoxDecoration(shape: BoxShape.circle, color: pickerTagColor),
        ),
        onTap: () {
          _showColorPickerDialog(context);
        },
      ),
    );
  }
  // build color picker widget
  Future _showColorPickerDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: MaterialColorPicker(
              allowShades: false,
              selectedColor: DEFAULT_COLOR,
              onMainColorChange: (newColor) {
                setState(() {
                  pickerTagColor = newColor;
                });
                Navigator.of(context).pop();
              },
            ),
          );
        });
  }

  void _resetFields(){
    setState(() {
      controller.clear();
      pickerTagColor = DEFAULT_COLOR;
    });
  }
}
