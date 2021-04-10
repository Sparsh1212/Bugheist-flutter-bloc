import 'package:bugheist/src/data/services/api_provider.dart';
import 'package:bugheist/src/data/services/api_response.dart';
import 'package:bugheist/src/model/issue_list.dart';
import 'package:flutter/material.dart';
import 'package:bugheist/src/data/services/urls.dart';

class IssueNotifier extends ChangeNotifier {
  String basePaginatedUrl = BASE_URL + ISSUES_ENDPOINT;
  ApiProvider apiProvider = ApiProvider();

  String paginatedUrl;
  IssueList _issueList;
  ApiResponse _apiResponse;

  ApiResponse getApiResponse() {
    return _apiResponse;
  }

  fetchIssueList(bool loadMore) async {
    try {
      if (!loadMore) {
        _apiResponse = ApiResponse.loading('Fetching Issues');
        notifyListeners();
        
        paginatedUrl = basePaginatedUrl;
        IssueList tempIssueList = await apiProvider.getIssueList(paginatedUrl);
        _issueList = tempIssueList;
        _apiResponse = ApiResponse.completed(_issueList);
        notifyListeners();
      } else {
        paginatedUrl = _issueList.next;
        IssueList tempIssueList = await apiProvider.getIssueList(paginatedUrl);
        _issueList.next = tempIssueList.next;
        _issueList.results.addAll(tempIssueList.results);
        _apiResponse = ApiResponse.completed(_issueList);
        notifyListeners();
      }
    } catch (e) {
      _apiResponse = ApiResponse.error(e.toString());
      notifyListeners();
    }
  }
}
