class Todo {
  int? id;
  String title;
  bool isDone;
  String? userId;

  Todo({
    this.id,
    required this.title,
    required this.isDone,
    this.userId,
  });

  // Veritabanına eklemek için Todo nesnesini Map'e dönüştür
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'isDone': isDone ? 1 : 0,
      'userId': userId,
    };
  }

  // Veritabanından okuduktan sonra Map'i Todo nesnesine dönüştür
  factory Todo.fromMap(Map<String, dynamic> json) => new Todo(
    id: json['id'],
    title: json['title'],
    isDone: json['isDone'] == 1,
    userId: json['userId'],

  );

}
