library todomvc.controller;

import 'dart:html' show KeyCode;

import 'package:angular/angular.dart';
import 'package:todomvc/model.dart' show Todo;

@NgController(
    selector: '[todo-controller]',
    publishAs: 'ctrl'
)
class TodoController {
  List<Todo> todos = [];
  String title;

  List<Todo> get completed => todos.where((todo) => todo.completed).toList();

  bool get allChecked => todos.every((todo) => todo.completed);

  void set allChecked(bool value) {
    todos.forEach((todo) => todo.completed = value);
  }

  create(event) {
    if (event.keyCode == KeyCode.ENTER) {
      if (title.trim().isNotEmpty) {
        todos.add(new Todo(title));
        title = '';
      }
    }
  }

  void clearCompleted() {
    todos.removeWhere((todo) => todo.completed);
  }

  edit(Todo todo) {
    print('editing..........');
  }
}