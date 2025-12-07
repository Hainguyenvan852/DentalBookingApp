import 'package:dental_booking_app/firebase_options.dart';
import 'package:dental_booking_app/data/repository/authentication_repository.dart';
import 'package:dental_booking_app/view/user_screen/sign_in_page/bloc/auth_cubit.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:open_mail/open_mail.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MaterialApp(
    home: NewMailPicker(),
  ));
}


class NewMailPicker extends StatelessWidget {
  final authRepo = AuthRepository(); 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: () => Navigator.pop(context), icon: Icon(Icons.arrow_back_ios, size: 19,)),
      ),
      body: RepositoryProvider(create: (_) => authRepo,
        child: BlocProvider(create: (_) => AuthCubit(authRepo)..signOut(),
          child: Center(
          ),
        ),
      )
      );
  }

  Future<void> _openMailApp(BuildContext context) async {
    final apps = await OpenMail.getMailApps();
    
    if (apps.isEmpty) {
      _showNoAppsDialog(context);
      return;
    }
    
    if (apps.length == 1) {
      // Single app - open directly
      await OpenMail.openMailApp();
      return;
    }
    
    // Multiple apps - show picker
    final selectedApp = await showDialog<MailApp>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Email App'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: apps.length,
            itemBuilder: (context, index) {
              final app = apps[index];
              return ListTile(
                leading: const Icon(Icons.email, color: Colors.blue),
                title: Text(app.name),
                onTap: () => Navigator.of(context).pop(app),
              );
            },
          ),
        ),
      ),
    );
    
    if (selectedApp != null) {
      await OpenMail.openSpecificMailApp(selectedApp.name);
    }
  }
  
  void _showNoAppsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('No Email Apps Found'),
        content: const Text('Please install an email app to continue.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}