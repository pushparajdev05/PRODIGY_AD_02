import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/models/todo.dart';
import 'package:todo_app/services/database_services.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late DatabaseServices databaseServices;
  late TextEditingController _textEditingController;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    databaseServices = DatabaseServices();
    _textEditingController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Todo App"),
        backgroundColor: Theme.of(context).colorScheme.primary,
        centerTitle: true,
      ),
      body: _buildUI(),
      floatingActionButton: FloatingActionButton(
        onPressed: _displayTextInputDialog,
        backgroundColor: Theme.of(context).colorScheme.primary,
        child: const Text("Add",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            )),
      ),
    );
  }

  Widget _buildUI() {
    return SafeArea(
      child: _messageBuilder(),
    );
  }

  Widget _messageBuilder() {
    return StreamBuilder(
        stream: databaseServices.getDocument(),
        builder: (context, snapshot) {
          List document = snapshot.data?.docs ?? [];
          if (document.isEmpty) {
            return const Text(
              "Create task",
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
              ),
            );
          }
          return ColoredBox(
            color: const Color.fromARGB(255, 255, 255, 255),
            child: Expanded(
              child: ListView.builder(
                  itemCount: document.length,
                  itemBuilder: (context, index) {
                    Todo todo = document[index].data();
                    String id = document[index].id;
                    return Container(
                      margin:
                          const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      decoration: ShapeDecoration.fromBoxDecoration(BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: const Color.fromARGB(180, 146, 237, 255),
                      )),
                      child: ListTile(
                        shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(20))),
                        title: Text(
                          todo.task,
                          style: const TextStyle(
                              color: Color.fromARGB(255, 3, 4, 9),
                              fontSize: 20,
                              fontWeight: FontWeight.w500),
                        ),
                        subtitle: Text(DateFormat("dd-MM-yyyy h:mm a")
                            .format(todo.updatedOn.toDate())),
                        trailing: Checkbox(
                          value: todo.isdone,
                          onChanged: (value) {
                            Todo updatedTodo = todo.copyWith(
                                isdone: value, updatedOn: Timestamp.now());
                            databaseServices.update(updatedTodo, id);
                          },
                        ),
                        onLongPress: () {
                          databaseServices.delete(id);
                        },
                      ),
                    );
                  }),
            ),
          );
        });
  }

  void _displayTextInputDialog() async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add a todo'),
          content: TextField(
            controller: _textEditingController,
            decoration: const InputDecoration(hintText: "Todo...."),
          ),
          actions: <Widget>[
            MaterialButton(
              color: Theme.of(context).colorScheme.primary,
              textColor: Colors.white,
              child: const Text('Ok'),
              onPressed: () {
                Todo todo = Todo(
                    task: _textEditingController.text,
                    isdone: false,
                    createdOn: Timestamp.now(),
                    updatedOn: Timestamp.now());
                databaseServices.add(todo);
                Navigator.pop(context);
                _textEditingController.clear();
              },
            ),
          ],
        );
      },
    );
  }
}
