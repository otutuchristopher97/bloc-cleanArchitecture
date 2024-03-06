import 'package:tdd_tutorial/core/usecase/usecase.dart';
import 'package:tdd_tutorial/core/utils/typedef.dart';
import 'package:tdd_tutorial/src/authentication/domain/entities/user.dart';
import 'package:tdd_tutorial/src/authentication/domain/repositories/authentication_repository.dart';

class GetUsers extends UsecaseWithoutParams<List<User>> {
  const GetUsers(this._repository);

  final AuthenticationRepository _repository;

  @override
  ResultFuture<List<User>> call() async => _repository.getUsers();
}
