import 'package:equatable/equatable.dart';
import 'package:tdd_tutorial/core/usecase/usecase.dart';
import 'package:tdd_tutorial/core/utils/typedef.dart';
import 'package:tdd_tutorial/src/authentication/domain/repositories/authentication_repository.dart';

class CreateUser extends UsecaseWithParaams<void, CreateUserParams> {
  const CreateUser(this._repository);

  final AuthenticationRepository _repository;

  @override
  ResultFuture call(CreateUserParams params) async => _repository.createUser(
      createdAt: params.createdAt, name: params.name, avatar: params.avatar);
}

class CreateUserParams extends Equatable {
  const CreateUserParams(
      {required this.createdAt, required this.name, required this.avatar});

  const CreateUserParams.empty()
      : this(
            createdAt: '_empty.string',
            name: '_empty.string',
            avatar: '_empty.string');

  final String createdAt;
  final String name;
  final String avatar;

  @override
  List<Object?> get props => [createdAt, name, avatar];
}
