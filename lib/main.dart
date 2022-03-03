import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
//import 'package:shared_preferences/shared_preferences.dart';
import 'screens/auth.dart';
import 'screens/home.dart';
import 'settings.dart';
import 'utils.dart';


void main()  {
  runApp( MyApp ( ) );
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: "/",
      routes: {
        "/"                             : (context) => StartScreen(storage: UserDataStorage()),//AuthScreen(),
        Settings().routeAuthScreen      : (context) => AuthScreen(storage: UserDataStorage()),
        Settings().routeRegisterScreen  : (context) => RegisterScreen(storage: UserDataStorage()),
        Settings().routeHomeScreen      : (context) => HomeScreen(),
      },
    );
  }
}

class StartScreen extends StatefulWidget {
  const StartScreen({Key? key, required this.storage}) : super(key: key);
  final UserDataStorage storage;
  final String bnTextReg  = "Создать аккаунт";
  final String bnTextAuth = "Войти в аккаунт";
  final String sAccount   = "";
  @override
  _StartScreenState createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  String? _userData;
  String? _bnText;
  bool?   _canAuth;

  @override
  void initState() {
    super.initState();
    _loadUserDataWithPathProvider();
  }
  void _loadUserDataWithPathProvider () {
    widget.storage.readUserData().then((String value) {
      setState(() {
        _userData = value;
      });
      if ( value == "" || value == null ) {
        setState(() {
          _bnText = widget.bnTextReg;
          _canAuth = false;
        });
      } else {
        setState(() {
          _bnText = widget.bnTextAuth;
          _canAuth = true;
        });
      }
    });
  }

  Future <File> _eraseUserData() {
    setState(() {
      _userData = widget.sAccount;
      _bnText = widget.bnTextReg;
      _canAuth = false;
    });
    return widget.storage.writeUserData( "" );
  }
  _goToScreen() {
    if (_canAuth == true) {
      Navigator.of(context).pushNamedAndRemoveUntil(Settings().routeAuthScreen, (route) => false);
    } else {
      Navigator.of(context).pushNamed(Settings().routeRegisterScreen);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
           child: Column(
             children: [
               SizedBox( height: 150,),
               Text ("Стартовый экран\n(для эмуляции автоперехода)", textAlign: TextAlign.center,),
               SizedBox( height: 50,),
               Text ("${_userData}"),
               ElevatedButton(onPressed: _goToScreen, child: Text ("${_bnText}")),
               SizedBox( height: 10, ),
               ElevatedButton(onPressed: _eraseUserData, child: Text ("Удалить аккаунт")),
             ],
           ),
        ),
      ),
    );//AuthScreen();
  }
}
