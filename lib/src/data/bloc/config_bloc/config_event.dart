part of 'config_bloc.dart';

abstract class ConfigEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class GetConfigEvent extends ConfigEvent {}
class ConfigNoInternetEvent extends ConfigEvent {}
class ConfigRetryEvent extends ConfigEvent {}
