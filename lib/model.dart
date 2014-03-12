library todomvc.model;

class Todo {
  String uid;
  String title;
  bool completed;
  Todo([this.title="", this.completed=false]);
  bool get isSaved => uid != null;

  normalize() {
    title = title.trim();
  }

  bool get isValid => title.trim().isNotEmpty;
  bool get isNotValid => !isValid;
}
