import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/todo.dart';

class DatabaseServices {
  final collection = "todos";

  late final CollectionReference todos_;

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  DatabaseServices() {
    todos_ = firestore.collection(collection).withConverter<Todo>(
        fromFirestore: (snapshot, _) {
      return Todo.fromJson(snapshot.data());
    }, toFirestore: (todos, _) {
      return todos.toJson();
    });
  }

  Stream<QuerySnapshot> getDocument() {
    return todos_.snapshots();
  }

  void add(Todo todo) {
    todos_.add(todo);
  }

  void update(
    Todo todo,id
  ) {
    todos_.doc(id).update(todo.toJson());
  }

  void delete(id) {
    todos_.doc(id).delete();
  }
}
