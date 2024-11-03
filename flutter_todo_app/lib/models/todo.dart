import 'package:cloud_firestore/cloud_firestore.dart';

class Todo {
  String task;
  bool isdone;
  Timestamp createdOn;
  Timestamp updatedOn;

  Todo(
      {required this.task,
      required this.isdone,
      required this.createdOn,
      required this.updatedOn});
  Todo.fromJson(Map<String, dynamic>? json)
      : this(
            task: json!["task"] as String,
            isdone: json["isdone"] as bool,
            createdOn: json["createdOn"] as Timestamp,
            updatedOn: json["updatedOn"] as Timestamp);

  Todo copyWith(
      {String? task,
      bool? isdone,
      Timestamp? createdOn,
      Timestamp? updatedOn}) {
    return Todo(
        task: task ?? this.task,
        isdone: isdone ?? this.isdone,
        createdOn: createdOn ?? this.createdOn,
        updatedOn: updatedOn ?? this.updatedOn);
  }

  Map<String, Object> toJson() {
    return {
      "task": task,
      "isdone": isdone,
      "createdOn": createdOn,
      "updatedOn": updatedOn
    };
  }
}
