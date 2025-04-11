import 'package:bloc/bloc.dart';
import 'package:firebase_exam_app/ui/repository/user_repository.dart';

import 'user_event.dart';
import 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final UserRepository userRepository;

  UserBloc(this.userRepository) : super(UserInitial()) {
    on<CreateUser>((event, emit) async {
      emit(UserLoading());
      try {
        await userRepository.createUser(event.userId, event.user);
        emit(UserSuccess());
      } catch (e) {
        emit(UserError(e.toString()));
      }
    });

    on<ReadUser>((event, emit) async {
      emit(UserLoading());
      try {
        final user = await userRepository.readUser(event.userId);
        if (user != null) {
          emit(UserLoaded(user));
        } else {
          emit(const UserError('User not found.'));
        }
      } catch (e) {
        emit(UserError(e.toString()));
      }
    });

    on<UpdateUser>((event, emit) async {
      emit(UserLoading());
      try {
        await userRepository.updateUser(event.userId, event.user);
        emit(UserSuccess());
      } catch (e) {
        emit(UserError(e.toString()));
      }
    });

    on<DeleteUser>((event, emit) async {
      emit(UserLoading());
      try {
        await userRepository.deleteUser(event.userId);
        emit(UserSuccess());
      } catch (e) {
        emit(UserError(e.toString()));
      }
    });
  }
}
