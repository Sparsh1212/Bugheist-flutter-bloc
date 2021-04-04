import 'package:flutter/material.dart';

class IssueIntro {
  final String id;
  final String description;
  final String screenshot;
  IssueIntro({ @required this.id, @required this.description, @required this.screenshot});

  factory IssueIntro.fromJson(Map<String, dynamic> json) {
    return IssueIntro(
        id: json['id'].toString(),
        description: json['description'],
        screenshot: json['screenshot']);
  }
}
