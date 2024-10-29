import 'package:flutter/material.dart';
import 'package:untitled1/utils/todo_list.dart';
import 'package:untitled1/utils/completed_list.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'dart:async';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _controller = TextEditingController();

  List<List<dynamic>> toDoList = [];
  List<String> completedList = [];
  bool areNew = true;

  @override
  void initState() {
    super.initState();
    // _startTimer(); // Запускаем таймер
    loadLists(); // Загружаем списки при инициализации
  }

  Future<void> loadLists() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Загрузка списка задач
    String? toDoJson = prefs.getString('toDoList');
    if (toDoJson != null) {
      List<dynamic> decodedList = jsonDecode(toDoJson);
      setState(() {
        toDoList = decodedList.map((item) => [item[0], item[1]]).toList();
      });
    }

    // Загрузка списка выполненных задач
    String? completedJson = prefs.getString('completedList');
    if (completedJson != null) {
      setState(() {
        completedList = List<String>.from(jsonDecode(completedJson));
      });
    }
  }

  Future<void> saveLists() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(
        'toDoList', jsonEncode(toDoList)); // Сохраняем список задач
    await prefs.setString('completedList',
        jsonEncode(completedList)); // Сохраняем список выполненных задач
  }

  void checkBoxChanged(int index) {
    setState(() {
      toDoList[index][1] = !toDoList[index][1];
      if (toDoList[index][1] == true) {
        completedList.add(toDoList[index][0]);
        toDoList.removeAt(index);
      }
      saveLists(); // Сохраняем изменения
    });
  }

  void addNewTask() {
    if (_controller.text.trim().isNotEmpty) {
      setState(() {
        toDoList.add([_controller.text, false]);
        _controller.clear();
        saveLists(); // Сохраняем изменения
      });
    }
  }

  void deleteTask(int index) {
    setState(() {
      toDoList.removeAt(index);
      saveLists(); // Сохраняем изменения
    });
  }

  void taskEdit(int index, String newTaskName) {
    if (newTaskName.isNotEmpty) {
      setState(() {
        toDoList[index][0] = newTaskName;
        saveLists(); // Сохраняем изменения
      });
    }
  }

  void taskReboot(int index) {
    setState(() {
      toDoList.add([completedList[index], false]);
      completedList.removeAt(index);
      saveLists(); // Сохраняем изменения
    });
  }

  /* Timer? _timer;

  void _startTimer() {
    _timer = Timer.periodic(Duration(minutes: 1), (timer) {
      final now = DateTime.now();
      if (now.hour == 0 && now.minute == 0) {
        _clearCompletedTasks();
      }
    });
  }

  void _clearCompletedTasks() async {
    setState(() {
      completedList.clear();
    });
    await saveLists(); // Сохраняем изменения
  } */

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.pink[200],
        appBar: AppBar(
          backgroundColor: Colors.pink[300],
          title: Text(
            'Todo',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          centerTitle: true,
          foregroundColor: Colors.white,
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  areNew
                      ? ElevatedButton(
                          onPressed: () {
                            areNew = true;
                            setState(() {});
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.pink[400],
                            padding: EdgeInsets.all(16),
                            splashFactory: InkRipple.splashFactory,
                          ),
                          child: Text(
                            'Новые задачи',
                            style: TextStyle(color: Colors.white),
                          ),
                        )
                      : TextButton(
                          onPressed: () {
                            areNew = true;
                            setState(() {});
                          },
                          child: Text(
                            'Новые задачи',
                            style: TextStyle(color: Colors.pink[400]),
                          ),
                        ),
                  !areNew
                      ? ElevatedButton(
                          onPressed: () {
                            areNew = false;
                            setState(() {});
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.pink[400],
                            padding: EdgeInsets.all(16),
                            splashFactory: InkRipple.splashFactory,
                          ),
                          child: Text(
                            'Выполненные задачи',
                            style: TextStyle(color: Colors.white),
                          ),
                        )
                      : TextButton(
                          onPressed: () {
                            areNew = false;
                            setState(() {});
                          },
                          child: Text(
                            'Выполненные задачи',
                            style: TextStyle(color: Colors.pink[400]),
                          ),
                        ),
                ],
              ),
            ),
            if (toDoList.isEmpty && areNew)
              Center(
                child: Text(
                  'Новых задач нет',
                  style: TextStyle(
                    color: Colors.pink,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            if (areNew)
              Expanded(
                child: ListView.builder(
                  itemCount: toDoList.length,
                  itemBuilder: (BuildContext context, index) {
                    return TodoList(
                      taskName: toDoList[index][0],
                      taskCompleted: toDoList[index][1],
                      createdAt: DateTime.now(),
                      onChanged: (value) => checkBoxChanged(index),
                      deleteFunction: (context) => deleteTask(index),
                      editTask: (context, newTaskName) =>
                          taskEdit(index, newTaskName),
                    );
                  },
                ),
              ),
            if (completedList.isEmpty && !areNew)
              Center(
                child: Text(
                  'Выполненных задач нет',
                  style: TextStyle(
                    color: Colors.pink,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            if (!areNew)
              Expanded(
                child: ListView.builder(
                  itemCount: completedList.length,
                  itemBuilder: (BuildContext context, index) {
                    return CompletedList(
                      taskName: completedList[index],
                      returnTask: (context) => IconButton(
                        onPressed: () => taskReboot(index),
                        icon: Icon(
                          Icons.restart_alt_rounded,
                          color: Colors.white,
                        ),
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
        floatingActionButton: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              if (areNew)
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: TextField(
                      maxLength:
                          (MediaQuery.of(context).size.width / 14.0).floor(),
                      controller: _controller,
                      decoration: InputDecoration(
                        hintText: 'Добавить задачу',
                        hintStyle: TextStyle(color: Colors.pink),
                        filled: true,
                        fillColor: Colors.pink[100],
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Colors.pinkAccent,
                          ),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Colors.pink,
                          ),
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                    ),
                  ),
                ),
              if (areNew)
                FloatingActionButton(
                  backgroundColor: Colors.pinkAccent,
                  onPressed: addNewTask,
                  child: const Icon(
                    Icons.add,
                    color: Colors.white,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
