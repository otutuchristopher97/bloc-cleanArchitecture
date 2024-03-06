import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:tdd_tutorial/src/authentication/data/datasources/authentication_remote_data_source.dart';
import 'package:tdd_tutorial/src/authentication/data/repositories/authentication_repository_implementatio.dart';
import 'package:tdd_tutorial/src/authentication/domain/repositories/authentication_repository.dart';
import 'package:tdd_tutorial/src/authentication/domain/usecases/create_user.dart';
import 'package:tdd_tutorial/src/authentication/domain/usecases/get_users.dart';
import 'package:tdd_tutorial/src/authentication/presentation/cubit/authentication_cubit.dart';

final sl = GetIt.instance;


Future<void> init() async {
  // loose coupling
  // Service Locator
  sl
  // App Logic 
  // Bloc/Cubit/Getx
    ..registerFactory(
        () => AuthenticaationCubit(createUser: sl(), getUsers: sl()))

    // Use cases
    ..registerLazySingleton(() => CreateUser(sl()))
    ..registerLazySingleton(() => GetUsers(sl()))

    // Repositories 
    ..registerLazySingleton<AuthenticationRepository>(
        () => AuthenticationRepositoryImplementation(sl()))

    // Data source
    ..registerLazySingleton<AuthenticationRemoteDatasource>(
        () => AuthRemoteDataSrcImpl(sl()))
      
    // Dependencies
    ..registerLazySingleton(http.Client.new);
}
