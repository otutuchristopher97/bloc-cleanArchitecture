import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tdd_tutorial/src/authentication/presentation/cubit/authentication_cubit.dart';
import 'package:tdd_tutorial/src/authentication/presentation/widget/add_user_dialog.dart';
import 'package:tdd_tutorial/src/authentication/presentation/widget/loading_column.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController nameController = TextEditingController();

  void getUsers() {
    context.read<AuthenticaationCubit>().getUsers();
  }

  @override
  void initState() {
    super.initState();
    getUsers();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthenticaationCubit, AuthenticationState>(
        listener: (context, state) {
      if (state is AuthenticationError) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(state.message)));
      } else if (state is UserCreated) {
        getUsers();
      }
    }, builder: (context, state) {
      return Scaffold(
        body: state is GettingUsers
            ? const LoadingColumn(
                message: 'Fetching Users',
              )
            : state is CreatingUser
                ? const LoadingColumn(message: 'Creating User')
                : state is UsersLoaded
                    ? Center(
                        child: ListView.builder(
                            itemCount: state.users.length,
                            itemBuilder: (context, index) {
                              final user = state.users[index];
                              return ListTile(
                                leading: Image.network(user.avatar),
                                title: Text(user.name),
                                subtitle: Text(user.createdAt.substring(10)),
                              );
                            }),
                      )
                    : const SizedBox.shrink(),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            await showDialog(
                context: context,
                builder: (context) => AddUserDialog(
                      nameController: nameController,
                    ));
          },
          child: const Icon(Icons.add),
        ),
      );
    });
  }
}
