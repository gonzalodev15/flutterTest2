import 'dart:convert';

Reminder reminderFromJson(String str) {
  final jsonData = json.decode(str);
  return Reminder.fromJson(jsonData);
}

class Reminder {
  String content;
  DateTime date;
  String hour;


  Reminder({this.content, this.date, this.hour});

  factory Reminder.fromJson(Map<String, dynamic> json){
    return Reminder(
      content : json['content'],
      date : json['date'],
      hour : json['hout'],
    );
  }

  Map<String, dynamic> toJson() => {
    'content': content,
    'date': date,
    'hour': hour,

  };

  Map<String, dynamic> toMap() => {
    "content": content,
    "date": date,
    "hour": hour,
  };
}