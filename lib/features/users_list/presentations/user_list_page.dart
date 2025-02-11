import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:training_example/features/users_list/bloc/load_more/load_more_cubit.dart';

import '../../../models/users.dart';
import '../bloc/remote_user/remote_user_bloc.dart';
import '../bloc/remote_user/remote_user_event.dart';
import '../bloc/remote_user/remote_user_state.dart';
import 'remote_user_widget.dart';

class UsersRemotePage extends StatefulWidget {
  const UsersRemotePage({Key? key}) : super(key: key);

  @override
  State<UsersRemotePage> createState() => _UsersRemotePageState();
}

class _UsersRemotePageState extends State<UsersRemotePage> {
  late RemoteUsersBloc remoteUsersBloc;
  final ScrollController _listController = ScrollController();
  bool _showUpButton = false;
  List<RemoteUser> users = [];
  int loadingThreshold = 10;

  int get count => users.length;

  @override
  void initState() {
    _listController.addListener(_scrollListener);
    remoteUsersBloc = context.read<RemoteUsersBloc>();
    remoteUsersBloc.add(FetchRemoteUsersEvent(isFirstTime: true));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text('Users'),
        leading: IconButton(
          onPressed: () {
            GoRouter.of(context).pop();
          },
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      floatingActionButton: Visibility(
        visible: _showUpButton,
        child: FloatingActionButton(
          mini: true,
          elevation: 0,
          backgroundColor: Colors.grey.shade500,
          onPressed: () {
            _listController.jumpTo(0);
            setState(() {
              _showUpButton = false;
            });
          },
          child: const Icon(Icons.vertical_align_top_outlined,
              color: Colors.white),
        ),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            BlocBuilder<RemoteUsersBloc, RemoteUsersState>(
              buildWhen: (previous, current) {
                return current is! RemoteUsersLoadingMoreState;
              },
              builder: (context, state) {
                if (state is RemoteUsersLoadingState) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is RemoteUsersFetchedState) {
                  return RefreshIndicator(
                    onRefresh: () async {
                      remoteUsersBloc.add(
                          FetchRemoteUsersEvent(isFirstTime: true));
                    },
                    child: NotificationListener<ScrollNotification>(
                      onNotification: (notification) {
                        if (notification is ScrollUpdateNotification) {
                          setState(() {
                            _showUpButton = true;
                          });
                        }
                        return false;
                      },
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height,
                        child: ListView.builder(
                          controller: _listController,
                          itemCount: state.users.length,
                          itemBuilder: (BuildContext context, int index) {
                            return RemoteUserWidget(
                                user: state.users[index]);
                          },
                        ),
                      ),
                    ),
                  );
                } else if (state is RemoteUsersErrorState) {
                  return Center(
                    child: Text('Some thing went wrong\n${state.error}'),
                  );
                } else {
                  return Container();
                }
              },
            ),
            Positioned(
              bottom: 0,
              right: 0,
              left: 0,
              child: BlocBuilder<LoadMoreCubit, bool>(
                buildWhen: (previous, current) => previous != current,
                builder: (context, isLoading) {
                  return Visibility(
                    visible: isLoading,
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(),
                        ),
                        SizedBox(width: 15),
                        Text('Loading...'),
                      ],
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<bool> loadMore() async {
    remoteUsersBloc.add(FetchRemoteUsersEvent(isFirstTime: false));
    return true;
  }

  void _scrollListener() {
    if (_listController.position.pixels ==
        _listController.position.maxScrollExtent) {
      loadMore();
    }
  }
}
