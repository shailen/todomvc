library todomvc.controller;

import 'dart:async';
import 'dart:html' show Element, KeyCode, querySelector;

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

  List<Todo> get completed => todos.where(
      (todo) => todo.completed).toList();

  List<Todo> get remaining => todos.where(
      (todo) => !completed.contains(todo)).toList();

  bool _editing = false;
  bool get editing => _editing;
  void set editing(value) {
    print('setting value of editing');
    // Do the caching here.
    _editing = value;
  }

  cacheTitle(Todo todo) {
    _titleCache = todo.title;
  }

  bool get allChecked => todos.every((todo) => todo.completed);

  void set allChecked(bool value) {
    todos.forEach((todo) => todo.completed = value);
  }

  void editTodo(event, Todo todo) {
    event.preventDefault();
    editedTodo = todo;
    _titleCache = todo.title;
  }

  save(Todo todo) {
    todo.normalize();
    if (todo.isValid) {
      // Assume new Todo for now.
      todo.title = newTodo.title.trim();
      todos.add(newTodo);
      newTodo = new Todo();
    }
  }

  cancel(Todo todo) {
    todo.title = '';
  }

  keyupAction(event, todo) {
    if (event.keyCode == KeyCode.ESC) {
      cancel(todo);
    }
  }

  keypressAction(event, todo) {
    // This is needed because IE doesn't fire keyup for ENTER.
    if (event.keyCode == KeyCode.ENTER) {
      event.preventDefault();
      save(todo);
    }
  }

  saveOrCancel(event, todo) {
//    if (event.keyCode == KeyCode.ENTER) {
//      var title = todo.title.trim();
//      // TODO: move validaton to model.
//      if (title.isNotEmpty) {
//        // TODO: use better test for whether this is a new or existing todo.
//        if (todo == newTodo) {
//          newTodo.title = newTodo.title.trim();
//          todos.add(newTodo);
//          newTodo = new Todo();
//        } else {
//          editedTodo = null;
//          _titleCache = "";
//        }
//      } else {
//        // TODO: remove todo from todos
//      }
//    } else if (event.keyCode == KeyCode.ESC) {
//      todo.title = _titleCache;
//      _titleCache = '';
//      editedTodo = null;
//    }
  }

  doneEditing(Todo todo) {
    if (todo.title.trim().isEmpty) {
      todos.remove(todo);
    }
    editedTodo = null;
  }

  remove(Todo todo) {
    todos.remove(todo);
  }

  void clearCompleted() {
    todos.removeWhere((todo) => todo.completed);
  }

  edit(Todo todo) {
    print('editing..........');
  }
}