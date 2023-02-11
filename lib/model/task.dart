class Task {
  String content; //title
  DateTime timestamp; //time
  bool done; //boolean key
//constructor
  Task({
    required this.content,
    required this.timestamp,
    required this.done,
  });
//factory is a constructor that provide the value from the cache or it's sub class
  factory Task.fromMap(Map task) {
    return Task(
      content: task["content"],
      timestamp: task["timestamp"],
      done: task["done"],
    );
  }

//the toMap function will provide the value in form of map in it for hive
  Map toMap() {
    return {
      "content": content,
      "timestamp": timestamp,
      "done": done,
    };
  }
}
