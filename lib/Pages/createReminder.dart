
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_secondtest/Model/Reminder.dart';
import 'package:flutter_secondtest/Widgets/BackgroundImage.dart';
import 'package:flutter_secondtest/db/dbHelper.dart';
import 'package:intl/intl.dart';

class createReminder extends StatefulWidget {

  final String appBarTitle;
  final Reminder reminder;

  createReminder(this.reminder , this.appBarTitle);

  @override
  State<StatefulWidget> createState() {

    return createReminderState(this.reminder, this.appBarTitle);
  }
}

class createReminderState extends State<createReminder> {


  DatabaseHelper helper = DatabaseHelper();

  String appBarTitle;
  Reminder reminder;

  TextEditingController contentController = TextEditingController();
  TextEditingController hourController = TextEditingController();


  createReminderState(this.reminder, this.appBarTitle);

  @override
  Widget build(BuildContext context) {

    TextStyle textStyle = Theme.of(context).textTheme.title;

    contentController.text = reminder.content;
    hourController.text = reminder.hour;

    return WillPopScope(

        onWillPop: () {
          moveToLastScreen();
        },

        child: Scaffold(
          appBar: AppBar(
            title: Text(appBarTitle),
            leading: IconButton(icon: Icon(
                Icons.arrow_back),
                onPressed: () {
                  // Write some code to control things, when user press back button in AppBar
                  moveToLastScreen();
                }
            ),
          ),

          body: Stack(
            children: <Widget>[
              BackgroundImage(),
              Padding(
                padding: EdgeInsets.only(top: 15.0, left: 10.0, right: 10.0),
                child: ListView(
                  children: <Widget>[

                    Padding(
                      padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                      child: TextField(
                        controller: contentController,
                        style: textStyle,
                        onChanged: (value) {
                          debugPrint('Something changed in Title Text Field');
                          updateContent();
                        },
                        decoration: InputDecoration(
                            labelText: 'Context',
                            labelStyle: textStyle,
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0)
                            )
                        ),
                      ),
                    ),

                    Padding(
                      padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                      child: TextField(
                        controller: hourController,
                        style: textStyle,
                        onChanged: (value) {
                          debugPrint('Something changed in Description Text Field');
                          updateHour();
                        },
                        decoration: InputDecoration(
                            labelText: 'Description',
                            labelStyle: textStyle,
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0)
                            )
                        ),
                      ),
                    ),

                    // Fourth Element
                    Padding(
                      padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: RaisedButton(
                              color: Theme.of(context).primaryColorDark,
                              textColor: Theme.of(context).primaryColorLight,
                              child: Text(
                                'Save',
                                textScaleFactor: 1.5,
                              ),
                              onPressed: () {
                                setState(() {
                                  debugPrint("Save button clicked");
                                  _save();
                                });
                              },
                            ),
                          ),

                          Container(width: 5.0,),

                          Expanded(
                            child: RaisedButton(
                              color: Theme.of(context).primaryColorDark,
                              textColor: Theme.of(context).primaryColorLight,
                              child: Text(
                                'Delete',
                                textScaleFactor: 1.5,
                              ),
                              onPressed: () {
                                setState(() {
                                  debugPrint("Delete button clicked");
                                  _delete();
                                });
                              },
                            ),
                          ),

                        ],
                      ),
                    ),

                  ],
                ),
              ),
            ],
          )

        ));
  }

  void moveToLastScreen() {
    Navigator.pop(context, true);
  }


  void updateContent(){
    reminder.content = contentController.text;
  }

  void updateHour() {
    reminder.hour = hourController.text;
  }

  void _save() async {

    moveToLastScreen();

    reminder.date = DateFormat.yMMMd().format(DateTime.now());
    int result;
    if (reminder.id != null) {  // Case 1: Update operation
      result = await helper.updateReminder(reminder);
    } else { // Case 2: Insert Operation
      result = await helper.insertReminder(reminder);
    }

    if (result != 0) {
      _showAlertDialog('Status', 'Note Saved Successfully');
    } else {  // Failure
      _showAlertDialog('Status', 'Problem Saving Note');
    }

  }

  void _delete() async {

    moveToLastScreen();
    if (reminder.id == null) {
      _showAlertDialog('Status', 'No Reminder was deleted');
      return;
    }

    int result = await helper.deleteReminder(reminder.id);
    if (result != 0) {
      _showAlertDialog('Status', 'Reminder Deleted Successfully');
    } else {
      _showAlertDialog('Status', 'Error Occured while Deleting Reminder');
    }
  }

  void _showAlertDialog(String title, String message) {

    AlertDialog alertDialog = AlertDialog(
      title: Text(title),
      content: Text(message),
    );
    showDialog(
        context: context,
        builder: (_) => alertDialog
    );
  }

}


