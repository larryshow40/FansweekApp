import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:onoo/src/data/model/config/config_model.dart';
import 'package:onoo/src/data/repository.dart';
import 'package:onoo/src/utils/connection_status.dart';
part 'config_event.dart';
part 'config_state.dart';

class ConfigBloc extends Bloc<ConfigEvent, ConfigState> {
  final Repository repository;
  ConfigBloc({required this.repository}) : super(ConfigLoadingState());

  @override
  Stream<ConfigState> mapEventToState(
    ConfigEvent event,
  ) async* {
    if (event is GetConfigEvent) {
      yield ConfigLoadingState();
      //check interner connection
      bool isConnected = await ConnectionStatusSingleton.getInstance().checkConnection();
      if (!isConnected) {
        yield ConfigNoInternetState();
      }
      try {
        ConfigData? configData = await repository.getConfigData();
        if (configData != null) {
          yield ConfigSuccessState(configData: configData);
        } else {
          yield ConfigErrorState(message: "Data loading failed");
        }
      } catch (e) {
        yield ConfigErrorState(message: "Data loading failed: $e");
      }
    } else if (event is ConfigNoInternetEvent) {
      yield ConfigNoInternetState();
    } else if (event is ConfigRetryEvent) {
      yield ConfigRetryState();
    }
  }
}
