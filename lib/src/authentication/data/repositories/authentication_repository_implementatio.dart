import 'package:dartz/dartz.dart';
import 'package:tdd_tutorial/core/errors/exceptions.dart';
import 'package:tdd_tutorial/core/errors/failure.dart';
import 'package:tdd_tutorial/core/utils/typedef.dart';
import 'package:tdd_tutorial/src/authentication/data/datasources/authentication_remote_data_source.dart';
import 'package:tdd_tutorial/src/authentication/domain/entities/user.dart';
import 'package:tdd_tutorial/src/authentication/domain/repositories/authentication_repository.dart';

class AuthenticationRepositoryImplementation
    implements AuthenticationRepository {
  const AuthenticationRepositoryImplementation(this._remoteDataSource);

  final AuthenticationRemoteDatasource _remoteDataSource;

  @override
  ResultVoid createUser(
      {required String createdAt,
      required String name,
      required String avatar}) async {
    // The Test-Driven Development
    // call the remote data source
    // check if the method returns the proper data
    // make sure it returns the proper data if there is no exception
    // // check if when the remoteDataSource throws an exception, we return a
    // failure
    try {
      await _remoteDataSource.createUser(
          createdAt: createdAt, name: name, avatar: avatar);
      return const Right(null);
    } on APIException catch (e) {
      return Left(APIFailure.fromException(e));
    }
  }

  @override
  ResultFuture<List<User>> getUsers() async {
    try {
      final result = await _remoteDataSource.getUser();
      return Right(result);
    } on APIException catch (e) {
      return Left(APIFailure.fromException(e));
    }
  }
}
