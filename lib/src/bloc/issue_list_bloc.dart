import 'dart:async';

import 'package:bugheist/src/data/repository/issue_list_repository.dart';
import 'package:bugheist/src/data/services/api_response.dart';
import 'package:bugheist/src/model/issue_list.dart';
import 'package:bugheist/src/data/services/urls.dart';

class IssueListBloc {
  String basePaginatedUrl = BASE_URL + ISSUES_ENDPOINT;

  String paginatedUrl;

  IssueListRepository _issueListRepository;

  StreamController _issueListController;

  IssueList _issueList;

  StreamSink<ApiResponse<IssueList>> get issueListSink =>
      _issueListController.sink;

  Stream<ApiResponse<IssueList>> get issueListStream =>
      _issueListController.stream;

  IssueListBloc() {
    _issueListController = StreamController<ApiResponse<IssueList>>();
    _issueListRepository = IssueListRepository();
    paginatedUrl = basePaginatedUrl;
    issueListSink.add(ApiResponse.loading('Fetching Issue List'));
    fetchIssueList(false);
  }

   dispose() {
    _issueListController?.close();
  }

  fetchIssueList(bool loadMore) async {
    try {
      if (!loadMore) {
        issueListSink.add(ApiResponse.loading('Fetching Issue List'));
        paginatedUrl = basePaginatedUrl;
        IssueList tempIssueList =
            await _issueListRepository.fetchIssueList(paginatedUrl);
        _issueList = tempIssueList;
        issueListSink.add(ApiResponse.completed(_issueList));
      } else {
        paginatedUrl = _issueList.next;
        IssueList tempIssueList =
            await _issueListRepository.fetchIssueList(paginatedUrl);
        _issueList.next = tempIssueList.next;
        _issueList.results.addAll(tempIssueList.results);
        issueListSink.add(ApiResponse.completed(_issueList));
      }
    } catch (e) {
      issueListSink.add(ApiResponse.error(e.toString()));
    }
  }
}
