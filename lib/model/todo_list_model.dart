// import 'dart:convert';
// import 'dart:io';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

// import 'package:objectdb/objectdb.dart';

import 'package:todo/model/todo_model.dart';
import 'package:todo/model/task_model.dart';
import 'package:todo/db/db_provider.dart';

class TodoListModel extends Model {
  // ObjectDB db;
  var _db = DBProvider.db;
  List<Todo> get todos => _todos.toList();
  List<Task> get tasks => _tasks.toList();
  int getTaskCompletionPercent(Task task) => _taskCompletionPercentage[task.id];
  int getTotalTodosFrom({@required Task task}) => todos.where((it) => it.parent == task.id).length;

  List<Task> _tasks = [];
  List<Todo> _todos = [];
  Map<String, int> _taskCompletionPercentage =  Map();

  static TodoListModel of(BuildContext context) =>
      ScopedModel.of<TodoListModel>(context);

  @override
  void addListener(listener) {
    super.addListener(listener);
    // update data for every subscriber, especially for the first one
    loadTodos();
  }

  void loadTodos() async {

    var isNew = !await DBProvider.db.dbExists();
    if (isNew) {
      await _db.insertBulkTask(_db.tasks);
      await _db.insertBulkTodo(_db.todos);
    }

    _tasks = await _db.getAllTask();
    _todos = await _db.getAllTodo();
    // var databasesPath = await getDatabasesPath();
    // final path = await _localPath;
    // final dbPath = [path, 'todo.db'].join('/');
    // final dbPath = [databasesPath, 'todo.db'].join('/');

    // File dbFile = File(dbPath);
    // var isNew = await dbFile.exists();

    // db = ObjectDB(dbPath);
    // db.open();

    // if (isNew) {
    //   var todos = [
    //     Todo(id: 234, parent: 1, text: "Meet Clients", isCompleted: 0),
    //     Todo(id: 827, parent: 1, text: "Design Sprint", isCompleted: 0),
    //     Todo(id: 914, parent: 1, text: "Icon set design for Mobile App", isCompleted: 1),

    //     Todo(id: 83, parent: 2, text: "20 pushups", isCompleted: 0),
    //     Todo(id: 3, parent: 2, text: "3 sets squats", isCompleted: 0),
    //     Todo(id: 23, parent: 2, text: "15 burpees (3 sets)", isCompleted: 0),
    //   ];

    //   _todos = todos;

    //   var tasks = [
    //     Task(id: 1, name: 'Shopping', color: 8, codePoint: Icons.work.codePoint),
    //     Task(id: 2, name: 'Workout', color: 7, codePoint: Icons.fitness_center.codePoint),
    //   ];
    //   _tasks = tasks;

    //   await db.insert({
    //     "user": "guest",
    //     "todos": todos,
    //     "tasks": tasks,
    //   });
    // }

    // var result = await db.first({'user': 'guest'});
    // print("result :: ${result.toString()}");

    // _todos = (result['todos'] as List).map((json) => Todo.fromJson(json)).toList();
    // _tasks = (result['tasks'] as List).map((json) => Task.fromJson(json)).toList();


    // _todos = result['todos'] as List<Todo>;
    // _tasks = result['tasks'] as List<Task>;

    // print("sabinDB :: ${_todos.toString()}");

    // await db.close();

    tasks.forEach((it) {
      _calcTaskCompletionPercent(it.id);
    });

    notifyListeners();
  }

  @override
  void removeListener(listener) {
    super.removeListener(listener);
    print("remove listner called");
    // DBProvider.db.closeDB();
  }

  void removeTodo(Todo todo) {
    _todos.removeWhere((it) => it.id == todo.id);
    _syncJob(todo);
    _db.removeTodo(todo);
    notifyListeners();
  }

  void addTodo(Todo todo) {
    _todos.add(todo);
    _syncJob(todo);
    _db.insertTodo(todo);
    notifyListeners();
  }

  void updateTodo(Todo todo) {
    var oldTodo = _todos.firstWhere((it) => it.id == todo.id);
    var replaceIndex = _todos.indexOf(oldTodo);
    _todos.replaceRange(replaceIndex, replaceIndex + 1, [todo]);

    _syncJob(todo);
    _db.updateTodo(todo);

    notifyListeners();
  }

  _syncJob(Todo todo) {
    _calcTaskCompletionPercent(todo.parent);
   // _syncTodoToDB();
  }

  void _calcTaskCompletionPercent(String taskId) {
    var todos = this.todos.where((it) => it.parent == taskId);
    var totalTodos = todos.length;

    if (totalTodos == 0) {
      _taskCompletionPercentage[taskId] = 0;
    } else {
      var totalCompletedTodos = todos.where((it) => it.isCompleted == 1).length;
     _taskCompletionPercentage[taskId] = (totalCompletedTodos / totalTodos * 100).toInt();
    }
    // return todos.fold(0, (total, todo) => todo.isCompleted ? total + scoreOfTask : total);
  }

  // Future<int> _syncTodoToDB() async {
  //   return await db.update({'user': 'guest'}, {'todos': _todos});
  // }
}