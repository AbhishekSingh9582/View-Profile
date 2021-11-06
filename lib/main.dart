import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import './screens/all_users_overview.dart';
import './provider/profile_provider.dart';
import './screens/users_detail_screen.dart';
import './screens/user_detail_form.dart';
import './screens/auth_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ProfileProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
            primarySwatch: Colors.lightGreen, primaryColor: Colors.pinkAccent),
        home: const InitializerWidget(),
        routes: {
          UserDetailForm.routeArgs: (ctx) => UserDetailForm(),
          UsersDetailScreen.routeArgs: (ctx) => const UsersDetailScreen(),
          AllUsersOverview.routeArgs: (ctx) => AllUsersOverview(),
        },
      ),
    );
  }
}

class InitializerWidget extends StatefulWidget {
  const InitializerWidget({Key? key}) : super(key: key);

  @override
  _InitializerWidgetState createState() => _InitializerWidgetState();
}

class _InitializerWidgetState extends State<InitializerWidget> {
  FirebaseAuth? _auth;
  User? _user;
  @override
  void initState() {
    super.initState();
    _auth = FirebaseAuth.instance;
    _user = _auth!.currentUser;
  }

  @override
  Widget build(BuildContext context) {
    print(_user);
    // return _user != null ? AllUsersOverview() : const AuthScreen();
    return UserDetailForm();
  }
}
