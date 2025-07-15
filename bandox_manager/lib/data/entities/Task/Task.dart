class Task {
  String jobID;
  String createdAt;
  bool isAssigned; // userID-isAssigned
  String taskHeader;
  String taskID;
  String? taskTitle;

  Task(
      {required this.jobID,
      required this.createdAt,
      required this.isAssigned,
      required this.taskHeader,
      required this.taskID,
      this.taskTitle});

  factory Task.fromJson(String key, Map<dynamic, dynamic> json) {
    return Task(
        jobID: json["jobID"],
        taskID: key,
        taskTitle: json["taskTitle"] ?? "",
        isAssigned: json["isAssigned"] ?? false,
        createdAt: json["createdAt"],
        taskHeader: json["taskHeader"],
    );
  }
}
