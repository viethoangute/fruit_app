import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:training_example/features/search/bloc/search_bloc.dart';
import 'package:training_example/features/search/bloc/search_event.dart';

import '../../../generated/assets.dart';
import '../../../translations/locale_keys.g.dart';
import '../../home/widgets/fruit_item.dart';
import '../bloc/search_state.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  late final SearchBloc searchBloc;
  Timer? _searchTimer;

  void _startSearchTimer(String searchText) {
    _searchTimer?.cancel();
    _searchTimer = Timer(const Duration(milliseconds: 500), () {
      searchBloc.add(SearchRequestEvent(keyword: searchText));
    });
  }

  @override
  void initState() {
    searchBloc = context.read<SearchBloc>();
    searchBloc.add(SearchRequestEvent(keyword: ''));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        elevation: 0,
        title: Text(
          LocaleKeys.search.tr(),
        ),
      ),
      body: SafeArea(
        child: Center(
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(
                      horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.grey[200],
                  ),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Icon(
                          Icons.search,
                          color: Colors.grey[600],
                        ),
                      ),
                      Expanded(
                        child: TextField(
                          onChanged: (text) {
                            setState(() {});
                            _startSearchTimer(text);
                          },
                          decoration: InputDecoration(
                            hintText: LocaleKeys.searchHint.tr(),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                BlocBuilder<SearchBloc, SearchState>(
                  builder: (context, state) {
                    if (state is SearchResultState) {
                      if (state.result.isEmpty) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Image(
                              width: 180,
                              height: 180,
                              image: AssetImage(
                                Assets.assetsKitten
                              ),
                            ),
                            const SizedBox(height: 20),
                            Text(LocaleKeys.noItemMatched.tr())
                          ],
                        );
                      } else {
                        return Expanded(
                          child: Scrollbar(
                            thickness: 1.5,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10.0),
                              child: GridView.builder(
                                  gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisSpacing: 10,
                                      mainAxisSpacing: 10,
                                      crossAxisCount: 2,
                                      childAspectRatio: 3 / 5),
                                  itemCount: state.result.length,
                                  itemBuilder: (context, index) {
                                    return FruitItem(
                                        item: state.result[index],
                                        onTap: () {
                                          GoRouter.of(context).pushNamed('detail',
                                              extra: state.result[index]);
                                        });
                                  }),
                            ),
                          ),
                        );
                      }
                    } else if (state is SearchLoadingState) {
                      return const Center(child: CircularProgressIndicator());
                    } else {
                      return const Center(
                        child: Image(
                          width: 180,
                          height: 180,
                          image: AssetImage(Assets.assetsSearching),
                        ),
                      );
                    }
                  },
                )
              ],
            )),
      ),
    );
  }

  @override
  void dispose() {
    _searchTimer?.cancel();
    super.dispose();
  }
}
