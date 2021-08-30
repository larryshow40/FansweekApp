import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:onoo/src/data/model/all_tags.dart';
import 'package:onoo/src/data/repository.dart';
import 'package:onoo/src/utils/connection_status.dart';
part 'all_tags_event.dart';
part 'all_tags_state.dart';

class AllTagsBloc extends Bloc<AllTagsEvent, AllTagsState> {
  final Repository repository;
  AllTagsBloc({required this.repository}) : super(AllTagsLoadingState());

  @override
  Stream<AllTagsState> mapEventToState(AllTagsEvent event) async* {
    if (event is GetAllTagsEvent) {
      yield AllTagsLoadingState();
      bool isConnected = await ConnectionStatusSingleton.getInstance().checkConnection();//check_internnet_connection
      if (!isConnected) {
        yield AllTagsNoInternetState();
      }
      try {
        AllTags? allTags = await repository.getAllTags();//calling_get_all_tags_api
        if (allTags != null) {
          yield AllTagsSuccessState(allTags: allTags);
        } else {
          yield AllTagsErrorState(message: "Data loading failed");
        }
      } catch (e) {
        yield AllTagsErrorState(message: "Data loading failed: $e");
      }
    } else if (event is AllTagsNoInternetEvent) {
      yield AllTagsNoInternetState();
    }
  }
}
