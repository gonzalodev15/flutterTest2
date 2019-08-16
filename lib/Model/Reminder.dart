import 'dart:convert';

Reminder reminderFromJson(String str) {
  final jsonData = json.decode(str);
  return Reminder.fromMapObject(jsonData);
}

class Reminder {

  int _id;
  String content;
  String date;
  String hour;



  Reminder(this.content,this.date, this.hour);
  Reminder.withId(this._id, this.content, this.date, this.hour);


  int get id => _id;


  Map<String, dynamic> toMap() {

    var map = Map<String, dynamic>();
    if (id != null) {
      map['id'] = _id;
    }
    map['content'] = content;
    map['date'] = date;
    map['hour'] = hour;

    return map;
  }

  // Extract a Note object from a Map object
  Reminder.fromMapObject(Map<String, dynamic> map) {
    this._id = map['id'];
    this.content = map['content'];
    this.date = map['date'];
    this.hour = map['hour'];

  }
}