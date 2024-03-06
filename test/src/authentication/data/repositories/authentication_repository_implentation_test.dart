import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tdd_tutorial/core/errors/exceptions.dart';
import 'package:tdd_tutorial/core/errors/failure.dart';
import 'package:tdd_tutorial/src/authentication/data/datasources/authentication_remote_data_source.dart';
import 'package:tdd_tutorial/src/authentication/data/repositories/authentication_repository_implementatio.dart';
import 'package:tdd_tutorial/src/authentication/domain/entities/user.dart';

class MockAuthRemoteDataSrc extends Mock
    implements AuthenticationRemoteDatasource {}

void main() {
  late AuthenticationRemoteDatasource remoteDataSource;
  late AuthenticationRepositoryImplementation repoImpl;
  setUp(() {
    remoteDataSource = MockAuthRemoteDataSrc();
    repoImpl = AuthenticationRepositoryImplementation(remoteDataSource);
  });

  const tException =
      APIException(message: 'Unknown Error Occur', statusCode: 500);
  group('createUser', () {
    const createdAt = 'whatever.createdAt';
    const name = 'whatever.name';
    const avatar = 'whatever.avatar';
    test(
      'should call the [RemoteDataSource.createUser] and complete'
      'successfully when the call to the remote source is successful',
      () async {
        // arrange
        when(() => remoteDataSource.createUser(
                createdAt: any(named: 'createdAt'),
                name: any(named: 'name'),
                avatar: any(named: 'avatar')))
            .thenAnswer((_) async => Future.value());

        // act
        final result = await repoImpl.createUser(
            createdAt: createdAt, name: name, avatar: avatar);

        // assert
        expect(result, equals(const Right(null)));
        verify(() => remoteDataSource.createUser(
            createdAt: createdAt, name: name, avatar: avatar)).called(1);
        verifyNoMoreInteractions(remoteDataSource);
      },
    );

    test(
        'should return a [ServerFailure] when the call to the remote source is unseccessful',
        () async {
      // arrange
      when(() => remoteDataSource.createUser(
          createdAt: any(named: 'createdAt'),
          name: any(named: 'name'),
          avatar: any(named: 'avatar'))).thenThrow(tException);

      final result = await repoImpl.createUser(
          createdAt: createdAt, name: name, avatar: avatar);

      expect(
          result,
          equals(Left(APIFailure(
              message: tException.message,
              statusCode: tException.statusCode))));

      verify(() => remoteDataSource.createUser(
          createdAt: createdAt, name: name, avatar: avatar)).called(1);

      verifyNoMoreInteractions(remoteDataSource);
    });
  });

  group('getUsers', () {
    test(
        'should call the [RemoteDataSource.getUsers] and return [List<User>]'
        'when call to remote source is successful', () async {
      when(() => remoteDataSource.getUser()).thenAnswer((_) async => []);

      final result = await repoImpl.getUsers();

      expect(result, isA<Right<dynamic, List<User>>>());
      verify(() => remoteDataSource.getUser()).called(1);
      verifyNoMoreInteractions(remoteDataSource);
    });

    test(
        'should return a [APIFailure] when the call to the remote source is unseccessful',
        () async {
      // arrange
      when(() => remoteDataSource.getUser()).thenThrow(tException);

      final result = await repoImpl.getUsers();

      expect(result, equals(Left(APIFailure.fromException(tException))));
      verify(() => remoteDataSource.getUser()).called(1);
      verifyNoMoreInteractions(remoteDataSource);
    });
  });
}
