import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tdd_tutorial/core/services/inject_container.dart';
import 'package:tdd_tutorial/src/authentication/presentation/cubit/authentication_cubit.dart';
import 'package:tdd_tutorial/src/authentication/presentation/views/home_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
   
  await init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<AuthenticaationCubit>(),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: const HomeScreen(),
      ),
    );
  }
}
