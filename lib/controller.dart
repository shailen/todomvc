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
  String _titleCache;
  Todo newTodo = new Todo();
  Todo editedTodo;

  cacheTitle(Todo todo) {
    _titleCache = todo.title;
  }

  List<Todo> get completed => todos.where((todo) => todo.completed).toList();

  bool get allChecked => todos.every((todo) => todo.completed);

  void set allChecked(bool value) {
    todos.forEach((todo) => todo.completed = value);
  }

  void editTodo(Todo todo) {
    editedTodo = todo;
    _titleCache = todo.title;
  }

  _save(Todo todo) {
    todos.add(newTodo);
    newTodo = new Todo();
  }

  _reset(Todo todo) {
    todo.title = _titleCache;
    _titleCache = '';
    editedTodo = null;
  }

  saveOrCancel(event, todo) {
    if (event.keyCode == KeyCode.ENTER) {
      var title = todo.title.trim();
      if (title.isNotEmpty) {
        // TODO: use better test for whether this is a new or existing todo.
        if (todo == newTodo) {
          _save(todo);
        } else {
          editedTodo = null;
          _titleCache = "";
        }
      }
    } else if (event.keyCode == KeyCode.ESC) {
      _reset(todo);
    }
  }



  void clearCompleted() {
    todos.removeWhere((todo) => todo.completed);
  }

  edit(Todo todo) {
    print('editing..........');
  }
}