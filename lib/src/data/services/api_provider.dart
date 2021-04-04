import 'dart:io';
import 'package:bugheist/src/model/issue_list.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'app_exceptions.dart';
import 'urls.dart';

class ApiProvider {
  Future<IssueList> getIssueList(String paginatedUrl) async {
    var responseJson;
    try {
      final response = await http.get(Uri.parse(paginatedUrl));
      responseJson = _returnIssueListResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  IssueList _returnIssueListResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
        var responseJson =
            IssueList.fromJson(json.decode(response.body.toString()));
        return responseJson;
      case 400:
        throw BadRequestException(response.body.toString());
      case 401:
      case 403:
        throw UnauthorisedException(response.body.toString());
      case 500:
      default:
        throw FetchDataException(
            'Error occured while Communication with Server with StatusCode : ${response.statusCode}');
    }
  }
}
