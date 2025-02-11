import 'package:equatable/equatable.dart';

abstract class ConnectivityEvent extends Equatable{
  @override
  List<Object> get props =>[];
}

class ConnectivityInitialEvent extends ConnectivityEvent {}

class UpdateConnectivityEvent extends ConnectivityEvent {
  final bool result;

  UpdateConnectivityEvent({
    required this.result,
  });

  @override
  List<Object> get props => [result];
}