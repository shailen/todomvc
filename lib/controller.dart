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
  String tempTitle;

  List<Todo> get completed => todos.where((todo) => todo.completed).toList();

  bool get allChecked => todos.every((todo) => todo.completed);

  void set allChecked(bool value) {
    todos.forEach((todo) => todo.completed = value);
  }


  // Listen for KeyCode.ENTER on keypress but KeyCode.ESC on keyup, because
  // IE doesn't fire keyup for ENTER.
  keypressHandler(event) {
    if (event.keyCode == KeyCode.ENTER) {
      var title = tempTitle.trim();
      if (title.isNotEmpty) {
        todos.add(new Todo(title.trim()));
        tempTitle = '';
      }
    }
  }

  keyupHandler(event) {
    if (event.keyCode == KeyCode.ESC) {
      tempTitle = '';
    }
  }

  void clearCompleted() {
    todos.removeWhere((todo) => todo.completed);
  }

  edit(Todo todo) {
    print('editing..........');
  }
}