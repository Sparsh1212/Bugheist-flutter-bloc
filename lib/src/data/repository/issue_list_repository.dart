import 'package:bugheist/src/data/services/api_provider.dart';
import 'package:bugheist/src/model/issue_list.dart';

class IssueListRepository {
  ApiProvider _apiProvider = ApiProvider();

  Future<IssueList> fetchIssueList(String paginatedUrl) async {
    final issueList = _apiProvider.getIssueList(paginatedUrl);
    return issueList;
  }
}
