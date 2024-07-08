// To parse this JSON data, do
//
//     final userEnabelCourse = userEnabelCourseFromJson(jsonString);

import 'dart:convert';

List<UserEnabelCourse> userEnabelCourseFromJson(String str) => List<UserEnabelCourse>.from(json.decode(str).map((x) => UserEnabelCourse.fromJson(x)));

String userEnabelCourseToJson(List<UserEnabelCourse> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class UserEnabelCourse {
    int utid;
    int uid;
    int tid;
    int week;
    int day;

    UserEnabelCourse({
        required this.utid,
        required this.uid,
        required this.tid,
        required this.week,
        required this.day,
    });

    factory UserEnabelCourse.fromJson(Map<String, dynamic> json) => UserEnabelCourse(
        utid: json["utid"],
        uid: json["uid"],
        tid: json["tid"],
        week: json["week"],
        day: json["day"],
    );

    Map<String, dynamic> toJson() => {
        "utid": utid,
        "uid": uid,
        "tid": tid,
        "week": week,
        "day": day,
    };
}
