import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:onoo/src/data/model/auth/auth_model.dart';
import '../../repository.dart';
import 'firebase_auth_event.dart';
import 'firebase_auth_state.dart';

class FirebaseAuthBloc extends Bloc<FirebaseAuthEvent, FirebaseAuthState> {
  final Repository repository;
  FirebaseAuthBloc(this.repository) : super(FirebaseAuthIsNotStartState());
  FirebaseAuthState get initialState => FirebaseAuthIsNotStartState();
  @override
  Stream<FirebaseAuthState> mapEventToState(FirebaseAuthEvent event) async* {
    if (event is FirebaseAuthFailed) {
      yield FirebaseAuthFailedState();
    } else if (event is FirebaseAuthCompleting) {
      print("inside_event");
      print(event.phone);
      print(event.uid);

      AuthModel? userServerData = await repository.firebaseAuthPhone(
        uid: event.uid,
        phoneNumber: event.phone,
      );
      yield FirebaseAuthStateCompleted(userServerData);
    } else if (event is FirebaseAuthNotStarted) {
      yield FirebaseAuthIsNotStartState();
    } else if (event is FirebaseAuthStarted) {
      yield FirebaseAuthStartedState();
    }
  }
}
