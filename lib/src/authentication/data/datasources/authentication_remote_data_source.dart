import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:tdd_tutorial/core/errors/exceptions.dart';
import 'package:tdd_tutorial/core/utils/constants.dart';
import 'package:tdd_tutorial/core/utils/typedef.dart';
import 'package:tdd_tutorial/src/authentication/data/models/user_model.dart';

abstract class AuthenticationRemoteDatasource {
  Future<void> createUser(
      {required String createdAt,
      required String name,
      required String avatar});

  Future<List<UserModel>> getUser();
}

const kCreateUserEndpoint = '/test-api/users';
const KGetUserEndpoint = '/test-api/users';

class AuthRemoteDataSrcImpl implements AuthenticationRemoteDatasource {
  const AuthRemoteDataSrcImpl(this._client);

  final http.Client _client;

  @override
  Future<void> createUser(
      {required String createdAt,
      required String name,
      required String avatar}) async {
    //1. check to make sure that it return the right data when the status
    // is 200 or the proper reponse code
    // 2. check to make sure that it "THROWS A CUSTOM EXCEPTION" with the
    // right message when status code is the bad one

    try {
      final response =
          await _client.post(Uri.https(KBaseUrl, kCreateUserEndpoint),
              body: jsonEncode({
                'createdAt': createdAt,
                'name': name,
              }),
              headers: {'Content-Type': 'application/json'});

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw APIException(
            message: response.body, statusCode: response.statusCode);
      }
    } on APIException {
      rethrow;
    } catch (e) {
      throw APIException(message: e.toString(), statusCode: 505);
    }
  }

  @override
  Future<List<UserModel>> getUser() async {
    // Note that in some case we might have
    // final responseJson = jsonDecode(response.body)
    // final List<dynamic> value = responseJson
    // or
    // final List<dynal> value = responseJson[data]
    // All observe the response

    try {
      final response = await _client.get(Uri.https(KBaseUrl, KGetUserEndpoint));

      if (response.statusCode != 200) {
        throw APIException(
            message: response.body, statusCode: response.statusCode);
      }
      print(response.body);
      return List<DataMap>.from(jsonDecode(response.body) as List)
          .map((userData) => UserModel.fromMap(userData))
          .toList();
    } on APIException {
      rethrow;
    } catch (e) {
      throw APIException(message: e.toString(), statusCode: 505);
    }
  }
}
