library todomvc.controller;

import 'dart:html' show Element, KeyCode, querySelector, window;

import 'package:angular/angular.dart';
import 'package:todomvc/model.dart' show Todo;

@NgController(
    selector: '[todo-controller]',
    publishAs: 'ctrl'
)
class TodoController implements NgDetachAware {
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
  String filterString = "";

  RouteHandle activeHandle, completedHandle, allHandle;

  Router router;

  TodoController(this.router) {
    activeHandle = router.root.getRoute(ACTIVE_STRING).newHandle()
        ..onEnter.listen((_) => filterString = 'active');

    completedHandle = router.root.getRoute(COMPLETED_STRING).newHandle()
        ..onEnter.listen((_) => filterString = 'completed');

    allHandle = router.root.getRoute(ALL_STRING).newHandle()
        ..onEnter.listen((_) => filterString = 'all');
  }

  detach() {
    activeHandle.discard();
    completedHandle.discard();
    allHandle.discard();
  }

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