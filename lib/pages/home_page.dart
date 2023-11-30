// ignore_for_file: no_leading_underscores_for_local_identifiers
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
// ignore: depend_on_referenced_packages
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import '../model/task.dart';

class HomePage extends StatefulWidget {
  //the reason behins using the stateful widget is there gonna be something change in our app after appling some opration on it
  //in Stateful widget we dont use an override method but createState Method
  HomePage();

  @override
  State<StatefulWidget> createState() {
    return _HomePageState();
  }
}

//Private class we cants access it out of its area
//since we are using HomePage in our main file
//we wrap this _HomePageState in HomePage class
class _HomePageState extends State<HomePage> {
  late double _deviceHeight;

  String? _newTaskContent; //input value from add tasak

  Box? _box;
  _HomePageState();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(116, 123, 254, 0.736),
        toolbarHeight: _deviceHeight * 0.10,
        centerTitle: true,
        title: const Text(
          "To-Do",
          style: TextStyle(
            fontSize: 25,
          ),
        ),
      ),
      body: _tasksView(),
      floatingActionButton: _addTaskButton(),
    );
  }

//to adding elements in form of list we use Listview property in our widget
  Widget _tasksView() {
    return FutureBuilder(
      future: Hive.openBox('tasks'),
      builder: (BuildContext _context, AsyncSnapshot _snapshot) {
        if (_snapshot.hasData) {
          _box = _snapshot.data;
          return Container(
            padding: const EdgeInsets.all(20),
            child: _tasksList(),
          );
        } else {
          return const Center(
            //since it's a UI part so we cant add async and await here
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  Widget _tasksList() {
    //value add to a box of Hive through object of Task class
    // Task _newtask =
    //     new Task(content: "Gym", timestamp: DateTime.now(), done: false);
    // _box?.add(_newtask.toMap());
    List tasks = _box!.values.toList();
    //now we have the list of task we entered in our Box
    //we need to add a task with our list data
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
      itemCount: tasks.length,
      itemBuilder: (BuildContext _context, int _index) {
        var task = Task.fromMap(tasks[_index]);
        DateTime date = task.timestamp;

        return Slidable(
          endActionPane: ActionPane(
            motion: const ScrollMotion(),
            children: [
              SlidableAction(
                onPressed: ((context) => {
                      //delete
                      _box!.deleteAt(_index),
                      setState(() {}),
                    }),
                backgroundColor: const Color.fromARGB(255, 252, 53, 39),
                foregroundColor: Colors.black,
                icon: Icons.delete_forever,
              ),
            ],
          ),
          startActionPane: ActionPane(
            motion: const ScrollMotion(),
            children: [
              SlidableAction(
                onPressed: ((context) => {
                      //add
                      task.done = !task.done,
                      _box!.putAt(
                        _index,
                        task.toMap(),
                      ),
                      setState(() {}),
                    }),
                backgroundColor: const Color.fromARGB(255, 111, 249, 69),
                icon: Icons.add_task_sharp,
              ),
            ],
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.fromLTRB(25, 17, 25, 17),
            tileColor: const Color.fromRGBO(116, 123, 254, 0.533),
            title: Text(
              task.content,
              style: TextStyle(
                decoration: task.done ? TextDecoration.lineThrough : null,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(
              DateFormat(
                'hh:mm a || '
                'dd-mm-yyyy',
              ).format(date),
            ),

            //datetime prop give the actual time
            trailing: Icon(
              task.done
                  ? Icons.check_box_outlined
                  : Icons.check_box_outline_blank_outlined,
              color: const Color.fromRGBO(15, 27, 252, 0.733),
            ),
            onTap: () {
              task.done = !task.done;
              _box!.putAt(
                _index,
                task.toMap(),
              );
              setState(() {});
            },
            onLongPress: () {
              _box!.deleteAt(_index);
              setState(() {});
            },
          ),
        );
      },
      separatorBuilder: (BuildContext context, int index) {
        return Container(
          height: 15,
        );
      },
    );
  }

  Widget _addTaskButton() {
    return FloatingActionButton(
      backgroundColor: const Color.fromRGBO(116, 123, 254, 0.736),
      onPressed: _displayTaskPopup,
      child: const Icon(
        Icons.add,
      ),
    );
  }

  void _displayTaskPopup() {
    showDialog(
      barrierColor: const Color.fromARGB(73, 111, 190, 247),
      context: context,
      builder: (BuildContext _context) {
        return AlertDialog(
          backgroundColor: const Color.fromARGB(186, 0, 128, 219),
          //contentPadding: ,
          title: const Text("Add New Task!"),
          actions: [
            TextButton(
              onPressed: () {
                if (_newTaskContent != null) {
                  var _task = Task(
                      content: _newTaskContent!,
                      timestamp: DateTime.now(),
                      done: false);
                  _box!.add(_task.toMap());
                  setState(() {
                    _newTaskContent = null;
                    Navigator.of(context).pop();
                  });
                }
              },
              child: const Text(
                "Save",
                style: TextStyle(color: Color.fromARGB(255, 12, 3, 84)),
                //style:ButtonStyle. ,
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                "Cancel",
                style: TextStyle(color: Color.fromARGB(255, 12, 3, 84)),
              ),
              //style:ButtonStyle. ,
            ),
          ],
          content: TextField(
            onSubmitted: (_) {},
            onChanged: (_value) {
              setState(() {
                _newTaskContent = _value;
              });
            },
          ),
        );
      },
    );
  }
}
