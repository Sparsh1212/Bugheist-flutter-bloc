import 'package:flutter/material.dart';
import 'issue_intro.dart';

class IssueList {
  final String count;
  String next;
  final String previous;
  final List<IssueIntro> results;

  IssueList(
      {@required this.count,
      @required this.next,
      @required this.previous,
      @required this.results});

  factory IssueList.fromJson(Map<String, dynamic> json) {
    return IssueList(
        count: json['count'].toString(),
        next: json['next'].toString(),
        previous: json['previous'].toString(),
        results: parseIssueIntroList(json));
  }
  static List<IssueIntro> parseIssueIntroList(json) {
    var list = json['results'] as List;
    List<IssueIntro> resultsList =
        list.map((data) => IssueIntro.fromJson(data)).toList();
    return resultsList;
  }
}
