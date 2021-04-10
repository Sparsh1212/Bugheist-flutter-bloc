import 'package:bugheist/src/data/services/api_response.dart';
import 'package:bugheist/src/model/issue_list.dart';
import 'package:bugheist/src/provider/issue_notifier.dart';
import 'package:bugheist/src/ui/components/error.dart';
import 'package:bugheist/src/ui/components/issue_intro.dart';
import 'package:bugheist/src/ui/components/loading.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ListIssues extends StatefulWidget {
  @override
  _ListIssuesState createState() => _ListIssuesState();
}

class _ListIssuesState extends State<ListIssues> {
  ScrollController _controller;

  @override
  void initState() {
    super.initState();
    Provider.of<IssueNotifier>(context, listen: false).fetchIssueList(false);
    _controller = ScrollController()..addListener(_scrollListener);
  }

  void _scrollListener() {
    if (_controller.position.pixels == _controller.position.maxScrollExtent) {
      Provider.of<IssueNotifier>(context, listen: false).fetchIssueList(true);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Recent Issues')),
        body: Consumer<IssueNotifier>(builder: (context, issueNotifier, child) {
          ApiResponse apiResponse = issueNotifier.getApiResponse();
          if (apiResponse == null) {
            return Container();
          } 
          return RefreshIndicator(
              onRefresh: () =>
                  Provider.of<IssueNotifier>(context, listen: false)
                      .fetchIssueList(false),
              child: apiResponse.status == Status.LOADING
                  ? Loading(
                      loadingMessage: apiResponse.message,
                    )
                  : apiResponse.status == Status.ERROR
                      ? Error(
                          onRetryPressed: () async {
                            Provider.of<IssueNotifier>(context, listen: false)
                                .fetchIssueList(false);
                          },
                          errorMessage: apiResponse.message,
                        )
                      : buildIssueList(apiResponse.data));
        }));
  }

  ListView buildIssueList(IssueList issueList) {
    return ListView.builder(
        controller: _controller,
        itemCount: issueList.results.length + 1,
        itemBuilder: (context, index) {
          return index >= issueList.results.length
              ? Loading(loadingMessage: 'Fetching more issues')
              : IssueIntro(
                  description: issueList.results[index].description,
                  imageSrc: issueList.results[index].screenshot,
                );
        });
  }
}
