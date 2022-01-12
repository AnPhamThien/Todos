class Todos {
  int? id;
  String? content;
  int? isDone;
  Todos({
    this.id,
    this.content,
    this.isDone,
  });

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{'id': id, 'content': content, 'isDone': isDone};
    return map;
  }

  Todos.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    content = map['content'];
    isDone = map['isDone'];
  }
}
