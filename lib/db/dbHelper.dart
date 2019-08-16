import 'dart:async';
import 'dart:io';
import 'package:flutter_secondtest/Model/Reminder.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';


class DatabaseHelper {

  static DatabaseHelper _databaseHelper;    // Singleton DatabaseHelper
  static Database _database;                // Singleton Database

  String ReminderTable = 'Reminder_table';
  String colId = 'id';
  String colContent = 'content';
  String colDate = 'date';
  String colHour = 'hour';


  DatabaseHelper._createInstance(); // Named constructor to create instance of DatabaseHelper

  factory DatabaseHelper() {

    if (_databaseHelper == null) {
      _databaseHelper = DatabaseHelper._createInstance(); // This is executed only once, singleton object
    }
    return _databaseHelper;
  }

  Future<Database> get database async {

    if (_database == null) {
      _database = await initializeDatabase();
    }
    return _database;
  }

  Future<Database> initializeDatabase() async {
    // Get the directory path for both Android and iOS to store database.
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + 'Reminders.db';

    // Open/create the database at a given path
    var RemindersDatabase = await openDatabase(path, version: 1, onCreate: _createDb);
    return RemindersDatabase;
  }

  void _createDb(Database db, int newVersion) async {

    await db.execute('CREATE TABLE $ReminderTable($colId INTEGER PRIMARY KEY AUTOINCREMENT, $colContent TEXT, '
        '$colDate TEXT, $colHour INTEGER)');
  }

  Future<List<Map<String, dynamic>>> getReminderMapList() async {
    Database db = await this.database;

    var result = await db.query(ReminderTable);
    return result;
  }

  Future<int> insertReminder(Reminder reminder) async {
    Database db = await this.database;
    var result = await db.insert(ReminderTable, reminder.toMap());
    return result;
  }

  Future<int> updateReminder(Reminder reminder) async {
    var db = await this.database;
    var result = await db.update(ReminderTable, reminder.toMap(), where: '$colId = ?', whereArgs: [reminder.date]);
    return result;
  }

  Future<int> deleteReminder(int id) async {
    var db = await this.database;
    int result = await db.rawDelete('DELETE FROM $ReminderTable WHERE $colId = $id');
    return result;
  }

  Future<int> getCount() async {
    Database db = await this.database;
    List<Map<String, dynamic>> x = await db.rawQuery('SELECT COUNT (*) from $ReminderTable');
    int result = Sqflite.firstIntValue(x);
    return result;
  }

  Future<List<Reminder>> getReminderList() async {

    var ReminderMapList = await getReminderMapList();
    int count = ReminderMapList.length;

    List<Reminder> reminderList = List<Reminder>();
    for (int i = 0; i < count; i++) {
      reminderList.add(Reminder.fromMapObject(ReminderMapList[i]));
    }

    return reminderList;
  }

}