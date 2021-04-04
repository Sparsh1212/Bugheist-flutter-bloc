import 'package:bugheist/src/bloc/issue_list_bloc.dart';
import 'package:bugheist/src/data/services/api_response.dart';
import 'package:bugheist/src/model/issue_list.dart';
import 'package:bugheist/src/ui/components/error.dart';
import 'package:bugheist/src/ui/components/issue_intro.dart';
import 'package:bugheist/src/ui/components/loading.dart';
import 'package:flutter/material.dart';

class ListIssues extends StatefulWidget {
  @override
  _ListIssuesState createState() => _ListIssuesState();
}

class _ListIssuesState extends State<ListIssues> {
  IssueListBloc _bloc;
  ScrollController _controller;

  @override
  void initState() {
    super.initState();
    _bloc = IssueListBloc();
    _controller = ScrollController()..addListener(_scrollListener);
  }

  void _scrollListener() {
    if (_controller.position.pixels == _controller.position.maxScrollExtent) {
      _bloc.fetchIssueList(true);
    }
  }

  @override
  void dispose() {
    _bloc.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Recent Issues')),
      body: RefreshIndicator(
        onRefresh: () => _bloc.fetchIssueList(false),
        child: StreamBuilder<ApiResponse<IssueList>>(
          stream: _bloc.issueListStream,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              switch (snapshot.data.status) {
                case Status.LOADING:
                  return Loading(loadingMessage: snapshot.data.message);
                case Status.COMPLETED:
                  return buildIssueList(snapshot);
                case Status.ERROR:
                  return Error(
                    errorMessage: snapshot.data.message,
                    onRetryPressed: () => _bloc.fetchIssueList(false),
                  );
                  break;
              }
            }

            return Container();
          },
        ),
      ),
    );
  }

  ListView buildIssueList(AsyncSnapshot<ApiResponse<IssueList>> snapshot) {
    IssueList issueList = snapshot.data.data;
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
