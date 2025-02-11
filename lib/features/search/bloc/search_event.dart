import 'package:equatable/equatable.dart';

abstract class SearchEvent extends Equatable{
  @override
  List<Object> get props =>[];
}

class SearchRequestEvent extends SearchEvent {
  final String keyword;

  SearchRequestEvent({
    required this.keyword,
  });
}