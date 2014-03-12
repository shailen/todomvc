library todomvc.controller;

import 'dart:html' show Element, KeyCode, querySelector, window;

import 'package:angular/angular.dart';
import 'package:todomvc/model.dart' show Todo;

import 'dart:async';

/**
 * Capitalizes string.
 *
 * Usage:
 *
 *     {{ uppercase_expression | capitalize }}
 */
@NgFilter(name:'capitalize')
class CapitalizeFilter {
  call(String text) => text == null ? text :
    '${text.substring(0, 1).toUpperCase()}${text.substring(1)}';
}


@NgController(
    selector: '[todo-controller]',
    publishAs: 'ctrl'
)
class TodoController {
  static const ACTIVE_STRING = 'active';
  static const COMPLETED_STRING = 'completed';
  static const ALL_STRING = 'all';

  get activeString => ACTIVE_STRING;
  get completedString => COMPLETED_STRING;
  get allString => ALL_STRING;

  List<Todo> todos = [];
  String _titleCache;
  Todo newTodo = new Todo();
  Todo editedTodo;

  Http http;
  Scope scope;
  Router router;

  TodoController(this.http, this.scope, this.router) {
    router.onRouteStart.listen((RouteStartEvent event) {
      event.completed.then((result) {
        if (result) {
          if (event.uri == '/') {
            filterString = '';
          } else if (event.uri == '/$activeString') {
            filterString = '$activeString';
          } else if (event.uri == '/$completedString') {
            filterString = '$completedString';
          } else {
            filterString = '';
          }
        }
      });
    });
  }

  String filterString = "";

  bool filter(Todo todo) {
    if (filterString.isEmpty || filterString == ALL_STRING) {
      return true;
    }
    if (filterString == ACTIVE_STRING) {
      return active.contains(todo);
    } else if (filterString == COMPLETED_STRING) {
      return completed.contains(todo);
    }
    return false;
  }

  List<Todo> get completed => todos.where(
      (todo) => todo.completed).toList();

  List<Todo> get active => todos.where(
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
    // This doesn't work correctly.
    event.target.parent.querySelector('input').focus();
  }

  _cleanup() {
    editedTodo = null;
    _titleCache = '';
    editing = false;
  }

  // When ESC is pressed.
  keyupAction(event, todo) {
    if (event.keyCode == KeyCode.ESC) {
      if (editing) {
        _preventUpdate(todo);
      } else {
        _preventSave(todo);
      }
    }
  }

  // When ENTER is pressed.
  keypressAction(event, todo) {
    // This is needed because IE doesn't fire keyup for ENTER.
    if (event.keyCode == KeyCode.ENTER) {
      print('you pressed enter');
      todo.normalize();
      if (editing) {
        _updateOrRemove(todo);
      } else {
        if (todo.isValid) {
          _save(todo);
        }
      }
    }
  }

  // When ng-blur is called.
  blurAction(event, Todo todo) {
    todo.normalize();
    _updateOrRemove(todo);
  }

  remove(Todo todo) {
    todos.remove(todo);
  }

  void clearCompleted() {
    todos.removeWhere((todo) => todo.completed);
  }

  _save(Todo todo) {
    if (!todo.isSaved) {
      todos.add(newTodo);
      newTodo = new Todo();
    }
  }

  _update(Todo todo) {
    // TODO: implement persistence.
    _cleanup();
  }

  _preventSave(todo) {
    todo.title = '';
  }

  _preventUpdate(todo) {
    todo.title = _titleCache;
    // Clean up after editing
    _cleanup();
  }

  _updateOrRemove(Todo todo) {
    if (todo.isValid) {
      _update(todo);
    } else {
      remove(todo);
    }
  }
}