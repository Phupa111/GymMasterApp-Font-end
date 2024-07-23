class UserEnabelCourse {
  int utid;
  int uid;
  int tid;
  int week;
  int day;
  DateTime? weekStartDate;
  int isSuccess;

  UserEnabelCourse({
    required this.utid,
    required this.uid,
    required this.tid,
    required this.week,
    required this.day,
    required this.weekStartDate,
    required this.isSuccess,
  });

  factory UserEnabelCourse.fromJson(Map<String, dynamic> json) => UserEnabelCourse(
    utid: json["utid"],
    uid: json["uid"],
    tid: json["tid"],
    week: json["week"],
    day: json["day"],
    weekStartDate: json["week_start_date"] != null ? DateTime.parse(json["week_start_date"]) : null,
    isSuccess: json["is_success"],
  );

  Map<String, dynamic> toJson() => {
    "utid": utid,
    "uid": uid,
    "tid": tid,
    "week": week,
    "day": day,
    "week_start_date": weekStartDate?.toIso8601String(),
    "is_success": isSuccess,
  };
}
