library todomvc.module;

import 'package:angular/angular.dart';

import 'package:todomvc/controller.dart' show TodoController, CapitalizeFilter;
import 'package:todomvc/router.dart' show todoRouteInitializer;
import 'package:todomvc/directive.dart' show ActsAsFormFor;

class TodoModule extends Module {
  TodoModule() {
    type(TodoController);
    type(CapitalizeFilter);
    type(ActsAsFormFor);
    value(RouteInitializerFn, todoRouteInitializer);
       factory(NgRoutingUsePushState,
           (_) => new NgRoutingUsePushState.value(false));
  }
}
