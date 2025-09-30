import 'package:dental_booking_app/service/authentication_repository.dart';
import 'package:dental_booking_app/view/sign_in/bloc/auth_cubit.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'app.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final authRepo = AuthRepository();

  runApp(
    MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(value: authRepo),
      ],
      child: BlocProvider(
        create: (_) => AuthCubit(authRepo),
        child: MyApp(),
      ),
    ),
  );
}
