import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';
import 'package:tdd_tutorial/core/errors/exceptions.dart';
import 'package:tdd_tutorial/core/utils/constants.dart';
import 'package:tdd_tutorial/src/authentication/data/datasources/authentication_remote_data_source.dart';
import 'package:tdd_tutorial/src/authentication/data/models/user_model.dart';

class MockClient extends Mock implements http.Client {}

void main() {
  late http.Client client;
  late AuthenticationRemoteDatasource remoteDatasource;

  setUp(() {
    client = MockClient();
    remoteDatasource = AuthRemoteDataSrcImpl(client);
    registerFallbackValue(Uri());
  });

  group('createUser', () {
    test('should complete successfully when the status code is 200 or 201',
        () async {
      // arrange
      when(() => client.post(any(), body: any(named: 'body'))).thenAnswer(
          (_) async => http.Response('User created successfully', 201));

      // act
      final methodcall = remoteDatasource.createUser;

      //
      expect(
          methodcall(
            createdAt: 'createdAt',
            name: 'name',
            avatar: 'avatar',
          ),
          completes);

      verify(() => client.post(Uri.https(KBaseUrl, kCreateUserEndpoint),
          body: jsonEncode({
            'createdAt': 'createdAt',
            'name': 'name',
            'avatar': 'avatar'
          }))).called(1);

      verifyNoMoreInteractions(client);
    });

    test('should throw [APIExpection] when the status code is not 200',
        () async {
      when(() => client.post(any(), body: any(named: 'body'))).thenAnswer(
          (_) async => http.Response('Invalid email addressss', 400));

      final methodcall = remoteDatasource.createUser;

      expect(
          () async => methodcall(
                createdAt: 'createdAt',
                name: 'name',
                avatar: 'avatar',
              ),
          throwsA(
            const APIException(
                message: 'Invalid email addressss', statusCode: 400),
          ));

      verify(() => client.post(Uri.https(KBaseUrl, kCreateUserEndpoint),
          body: jsonEncode({
            'createdAt': 'createdAt',
            'name': 'name',
            'avatar': 'avatar'
          }))).called(1);

      verifyNoMoreInteractions(client);
    });
  });

  group('getUsers', () {
    const tUsers = [UserModel.empty()];
    const tmessage = 'Server down, Server'
        'down, I reppeat server down. Mayday Mayday Mayday';

    test('should return [List<User>] when the status code is 200', () async {
      when(() => client.get(any())).thenAnswer(
        (_) async {
          return http.Response(jsonEncode(tUsers.first.toMap()), 200);
        },
      );

      final result = await remoteDatasource.getUser();

      expect(result, equals(tUsers));

      verify(() => client.get(Uri.https(KBaseUrl, KGetUserEndpoint))).called(1);

      verifyNoMoreInteractions(client);
    });

    test('should return [APIExpection] when the status is not 200', () async {
      when(() => client.get(any())).thenAnswer(
        (_) async {
          return http.Response(tmessage, 500);
        },
      );

      final methodcall = remoteDatasource.getUser;

      expect(() => methodcall(),
          throwsA(const APIException(message: tmessage, statusCode: 500)));

      verify(() => client.get(Uri.https(KBaseUrl, KGetUserEndpoint))).called(1);

      verifyNoMoreInteractions(client);
    });
  });
}
