import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:training_example/features/general_page/bloc/connectivity_event.dart';
import 'package:training_example/features/general_page/bloc/connectivity_state.dart';

import '../../../utils/my_connectivity.dart';

@singleton
class ConnectivityBloc extends Bloc<ConnectivityEvent, ConnectivityState> {
  ConnectivityBloc() : super(OnlineState()) {
    on<ConnectivityInitialEvent>(_onConnectivityInitialRequest);
    on<UpdateConnectivityEvent>(_onUpdateConnectivityStatusRequest);
  }

  Future<void> _onUpdateConnectivityStatusRequest(
      UpdateConnectivityEvent event, Emitter<ConnectivityState> emit) async {
        if (event.result) {
          emit(OnlineState());
        } else {
          emit(OfflineState());
    }
  }

  void _onConnectivityInitialRequest(
      ConnectivityInitialEvent event, Emitter<ConnectivityState> emit) {
    final MyConnectivity connectivity = MyConnectivity.instance;
    connectivity.initialise();
    connectivity.myStream.listen((source) {
      add(UpdateConnectivityEvent(result: source));
    });
  }
}
