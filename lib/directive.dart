import 'package:angular/angular.dart';
import 'dart:html';

import 'package:todomvc/model.dart' show Todo;


@NgDirective(selector: '[acts-as-form-for]')
class ActsAsFormFor implements NgAttachAware{
  @NgOneWay("acts-as-form-for")
  Todo todo;
  Element el;

  ActsAsFormFor(this.el);


  attach(){
    el.focus();
  }
}