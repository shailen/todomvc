import 'package:angular/angular.dart';
import 'dart:html';

/**
 * Provides focus to an element. Meant to be used with an <input type='text'>
 */
@NgDirective(
  selector: '[todo-focus]'
)
class TodoFocus {
  Element el;
  TodoFocus(this.el);

  @NgOneWay('todo-focus')
  set todoFocus(value) {
   if (value) {
     el.focus();
   }
  }
}