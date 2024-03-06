import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tdd_tutorial/src/authentication/domain/entities/user.dart';
import 'package:tdd_tutorial/src/authentication/domain/usecases/create_user.dart';
import 'package:tdd_tutorial/src/authentication/domain/usecases/get_users.dart';

part 'authentication_state.dart';

class AuthenticaationCubit extends Cubit<AuthenticationState> {
  AuthenticaationCubit({
    required CreateUser createUser,
    required GetUsers getUsers,
  })  : _createUser = createUser,
        _getUsers = getUsers,
        super(AuthenticationInitial());

  final CreateUser _createUser;
  final GetUsers _getUsers;

  Future<void> createUser({
    required String createdAt,
    required String name,
    required String avatar,
  }) async {
    emit(const CreatingUser());

    final result = await _createUser(
        CreateUserParams(createdAt: createdAt, name: name, avatar: avatar));

    result.fold((failure) => emit(AuthenticationError(failure.errorMessage)),
        (_) => emit(const UserCreated()));
  }

  Future<void> getUsers() async {
    emit(const GettingUsers());

    final result = await _getUsers();

    result.fold((failure) => emit(AuthenticationError(failure.errorMessage)),
        (users) => emit(UsersLoaded(users)));
  }
}
