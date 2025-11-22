import 'package:dental_booking_app/service/authentication_repository.dart';
import 'package:dental_booking_app/view/user_screen/sign_in_page/bloc/auth_cubit.dart';
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
      child: MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (_) => AuthCubit(authRepo),
            )
          ],
          child: MyApp()
      )
    ),
  );
}
