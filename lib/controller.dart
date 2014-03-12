library todomvc.controller;

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

  bool editing = false;

  bool get allChecked => todos.every((todo) => todo.completed);

  void set allChecked(bool value) {
    todos.forEach((todo) => todo.completed = value);
  }

  void editTodo(event, Todo todo) {
    event.preventDefault();
    editedTodo = todo;
    _titleCache = todo.title;
    editing = true;
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

  cancel(event, Todo todo) {
    if (editing) {
      todo.title = _titleCache;
      // Clean up after editing
      editedTodo = null;
      _titleCache = '';
      editing = false;
    } else {
      if (!todo.isSaved) {
        todo.title = '';
      }
    }
  }

  blurAction(event, Todo todo) {
    if (editing) {
      cancel(event, todo);
    }
  }

  keyupAction(event, todo) {
    if (event.keyCode == KeyCode.ESC) {
      cancel(event, todo);
    }
  }

  keypressAction(event, todo) {
    // This is needed because IE doesn't fire keyup for ENTER.
    if (event.keyCode == KeyCode.ENTER) {
      event.preventDefault();
      save(todo);
    }
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
}