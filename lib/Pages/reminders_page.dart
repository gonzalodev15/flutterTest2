import 'package:flutter/material.dart';
import 'package:flutter_secondtest/Model/Reminder.dart';
import 'package:flutter_secondtest/Pages/createReminder.dart';
import 'package:flutter_secondtest/Widgets/BackgroundImage.dart';
import 'package:flutter_secondtest/db/dbHelper.dart';
import 'package:sqflite/sqflite.dart';

class RemindersPage extends StatefulWidget {
  @override
  _RemindersPageState createState() => _RemindersPageState();
}



class _RemindersPageState extends State<RemindersPage> {

  DatabaseHelper databaseHelper = DatabaseHelper();
  List<Reminder> reminderList;
  int count = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Stack(
        children: <Widget>[
          BackgroundImage(),
          getReminderListView(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          debugPrint('FAB clicked');
          navigateToDetail(Reminder('', '', ''), 'Add Reminder');
        },

        tooltip: 'Add Reminder',

        child: Icon(Icons.add),

      ),
    );
  }


  ListView getReminderListView() {

    TextStyle titleStyle = Theme.of(context).textTheme.subhead;

    return ListView.builder(
      itemCount: count,
      itemBuilder: (BuildContext context, int position) {
        return Card(
          color: Colors.white,
          elevation: 2.0,
          child: ListTile(

            title: Text(this.reminderList[position].content, style: titleStyle,),

            subtitle: Text(this.reminderList[position].date),

            trailing: GestureDetector(
              child: Icon(Icons.delete, color: Colors.grey,),
              onTap: () {
                _delete(context, reminderList[position]);
              },
            ),


            onTap: () {
              debugPrint("ListTile Tapped");
              navigateToDetail(this.reminderList[position],'Edit Reminder');
            },

          ),
        );
      },
    );
  }


  void _delete(BuildContext context, Reminder note) async {

    int result = await databaseHelper.deleteReminder(note.id);
    if (result != 0) {
      _showSnackBar(context, 'Reminder Deleted Successfully');
      updateListView();
    }
  }

  void _showSnackBar(BuildContext context, String message) {

    final snackBar = SnackBar(content: Text(message));
    Scaffold.of(context).showSnackBar(snackBar);
  }

  void navigateToDetail(Reminder reminder, String title) async {
    bool result = await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return createReminder(reminder, title);
    }));

    if (result == true) {
      updateListView();
    }
  }

  void updateListView() {

    final Future<Database> dbFuture = databaseHelper.initializeDatabase();
    dbFuture.then((database) {

      Future<List<Reminder>> reminderListFuture = databaseHelper.getReminderList();
      reminderListFuture.then((reminderList) {
        setState(() {
          this.reminderList = reminderList;
          this.count = reminderList.length;
        });
      });
    });
  }
}
