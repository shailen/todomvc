library todomvc.router;

import 'package:angular/angular.dart';
import 'package:todomvc/controller.dart' show TodoController;

todoRouteInitializer(Router router, ViewFactory views) {
    router.root
        ..addRoute(
            name: '${TodoController.ACTIVE_STRING}',
            path: '/${TodoController.ACTIVE_STRING}')
        ..addRoute(
            name: '${TodoController.COMPLETED_STRING}',
            path: '/${TodoController.COMPLETED_STRING}')
        ..addRoute(
            name: '${TodoController.ALL_STRING}',
            path: '/');
}
