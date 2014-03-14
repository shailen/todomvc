library todomvc.filter;

import 'package:angular/angular.dart';

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
