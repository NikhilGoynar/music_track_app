import 'dart:async';

import 'package:connectivity/connectivity.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_track_app/blocs/internet_event.dart';
import 'package:music_track_app/blocs/internet_state.dart';

class InternetBloc extends Bloc<InternetEvent,InternetState> {
  Connectivity _connectivity=Connectivity();
  StreamSubscription? connectivitysubscription;
  InternetBloc():super(InitialInternetState()){
    on<InternetLostEvent>((event, emit) =>emit(InternetLostState()) );
    on<InternetGainedEvent>((event, emit) => emit(InternetGainedState()));
    connectivitysubscription=_connectivity.onConnectivityChanged.listen((result) {
      if(result==ConnectivityResult.mobile||result==ConnectivityResult.wifi){
        add(InternetGainedEvent());
      }
      else{
        add(InternetLostEvent());
      }

    });
  }
  @override
  Future<void> close() {
    connectivitysubscription?.cancel();
    return super.close();
  }

}

