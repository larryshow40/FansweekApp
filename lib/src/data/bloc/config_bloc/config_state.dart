part of 'config_bloc.dart';

abstract class ConfigState extends Equatable {}

class ConfigLoadingState extends ConfigState {
  @override
  List<Object> get props => [];
}

//success_state
class ConfigSuccessState extends ConfigState {
  final ConfigData configData;
  ConfigSuccessState({required this.configData});
  ConfigData getConfigData() {
    return configData;
  }

  @override
  List<Object> get props => [configData];
}
//error_state
class ConfigErrorState extends ConfigState {
  final String message;
  ConfigErrorState({required this.message});
  @override
  List<Object> get props => [message];
}
//Internet_connection_not_available_state
class ConfigNoInternetState extends ConfigState {
  @override
  List<Object> get props => [];
}
//retry_state
class ConfigRetryState extends ConfigState {
  @override
  List<Object> get props => [];
}
