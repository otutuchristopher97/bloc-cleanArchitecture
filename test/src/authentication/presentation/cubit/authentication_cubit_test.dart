import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tdd_tutorial/core/errors/failure.dart';
import 'package:tdd_tutorial/src/authentication/domain/usecases/create_user.dart';
import 'package:tdd_tutorial/src/authentication/domain/usecases/get_users.dart';
import 'package:tdd_tutorial/src/authentication/presentation/cubit/authentication_cubit.dart';

class MockGetUsers extends Mock implements GetUsers {}

class MockCreateUsers extends Mock implements CreateUser {}

void main() {
  late GetUsers getUsers;
  late CreateUser createUser;
  late AuthenticaationCubit cubit;

  const tCreateUserParams = CreateUserParams.empty();
  const tAPIFailure = APIFailure(message: 'message', statusCode: 400);

  setUp(() {
    getUsers = MockGetUsers();
    createUser = MockCreateUsers();
    cubit = AuthenticaationCubit(createUser: createUser, getUsers: getUsers);
    registerFallbackValue(tCreateUserParams);
  });

  tearDown(() => cubit.close());

  test('initial state should be [AuthenticationInitial]', () {
    expect(cubit.state, const AuthenticationInitial());
  });

  group('createUser', () {
    blocTest<AuthenticaationCubit, AuthenticationState>(
        'should emit [CreatingUser, UserCreated] when successful',
        // arrange
        build: () {
          when(() => createUser(any()))
              .thenAnswer((_) async => const Right(null));

          return cubit;
        },
        // act
        act: (cubit) => cubit.createUser(
            createdAt: tCreateUserParams.createdAt,
            name: tCreateUserParams.name,
            avatar: tCreateUserParams.avatar),
        // Example for a bloc scenaro
        // act: (bloc) => bloc.add(CreateUserEvent(createdAt: 'createdAt', name: 'name', avatar: 'avatar')),
        expect: () => const [
              CreatingUser(),
              UserCreated(),
            ],
        verify: (_) {
          verify(() => createUser(tCreateUserParams)).called(1);
          verifyNoMoreInteractions(createUser);
        });

    blocTest<AuthenticaationCubit, AuthenticationState>(
        'should emit [CreatingUser, AuthenticationError] when unsuccessful',
        // stub
        build: () {
          when(() => createUser(any())).thenAnswer(
            (_) async => const Left(tAPIFailure),
          );
          return cubit;
        },
        // act
        act: (cubit) => cubit.createUser(
            createdAt: tCreateUserParams.createdAt,
            name: tCreateUserParams.name,
            avatar: tCreateUserParams.avatar),
        // expect
        expect: () => [
              const CreatingUser(),
              AuthenticationError(tAPIFailure.errorMessage),
            ],
        verify: (_) {
          verify(() => createUser(tCreateUserParams)).called(1);
          verifyNoMoreInteractions(createUser);
        });
  });

  group('getUsers', () {
    blocTest<AuthenticaationCubit, AuthenticationState>(
      'should emit [GettingUser, UsersLoaded] when successful',
      build: () {
        when(() => getUsers()).thenAnswer((_) async => const Right([]));
        return cubit;
      },
      // act
      act: (cubit) => cubit.getUsers(),
      expect: () => const [
        GettingUsers(),
        UsersLoaded([]),
      ],
      verify: (_) {
        verify(() => getUsers()).called(1);
        verifyNoMoreInteractions(getUsers);
      },
    );

    blocTest<AuthenticaationCubit, AuthenticationState>(
      'should emit [GettingUsers, AuthenticationError] when unsuccessful',
      build: () {
        when(() => getUsers()).thenAnswer((_) async => const Left(tAPIFailure));
        return cubit;
      },
      act: (cubit) => cubit.getUsers(),
      expect: () => [
        const GettingUsers(),
        AuthenticationError(tAPIFailure.errorMessage),
      ],
      verify: (_) {
        verify(() => getUsers()).called(1);
        verifyNoMoreInteractions(getUsers);
      },
    );
  });
}
