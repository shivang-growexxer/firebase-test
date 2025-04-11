import 'package:equatable/equatable.dart';
import '../models/user_model.dart';

abstract class UserEvent extends Equatable {
  const UserEvent();
}

class CreateUser extends UserEvent {
  final String userId;
  final User user;

  const CreateUser(this.userId, this.user);

  @override
  List<Object?> get props => [userId, user];
}

class ReadUser extends UserEvent {
  final String userId;

  const ReadUser(this.userId);

  @override
  List<Object?> get props => [userId];
}

class UpdateUser extends UserEvent {
  final String userId;
  final User user;

  const UpdateUser(this.userId, this.user);

  @override
  List<Object?> get props => [userId, user];
}

class DeleteUser extends UserEvent {
  final String userId;

  const DeleteUser(this.userId);

  @override
  List<Object?> get props => [userId];
}
