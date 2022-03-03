import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart';
//import 'package:flutter/services.dart';
import '../settings.dart';
import '../utils.dart';
import 'home.dart';


class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key, required this.storage}) : super(key: key);
  final UserDataStorage storage;
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  String _userPhone = "";
  String _userPass = "";
  String? _userData;
  late User user;
  static const routeName = '/auth';

  void _phoneOnChanged (String val){
    setState(() {
        _userPhone = val;
    });
  }

  void _passOnChanged (String val){
    setState(() {
      _userPass = passEncode(val);
    });
  }

  _login (String userPhone, String userPass) {
    print (_userData);
    Map<String, dynamic> JSON = jsonDecode(_userData!);
    user = User.fromJSON(JSON);
      if (user.pass == userPass && user.phone == userPhone) {
        _goToMainScreen();
      } else {
        _alertLoginFail();
      }
  }

  void _goToMainScreen() {
    {
      Navigator.of(context).pushNamedAndRemoveUntil(Settings().routeHomeScreen, (route) => false);
    }
  }

  void _alertLoginFail() {
    print ("login fail");
  }
  void _loadUserDataWithPathProvider () {
    widget.storage.readUserData().then((String value) {
      setState(() {
        _userData = value;
      });
    });
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadUserDataWithPathProvider();
  }
  @override
  Widget build(BuildContext context) {
     return MaterialApp(
       debugShowCheckedModeBanner: false,
      home: Scaffold(
          body: Container(
            decoration : UI().containerDecoration,
            width      : double.infinity,
            height     : double.infinity,
            padding    : EdgeInsets.symmetric(horizontal: 50),
            child      : SingleChildScrollView(
              child: Column (
                children: [
                  const SizedBox(height: 150,),
                  UI().logo,
                  const SizedBox(height: 20,),
                  Text("Введите логин в виде ${Settings().phoneMaxLength} цифр номера телефона",
                    style: TextStyle(fontSize: 16, color: Color.fromRGBO(0, 0, 0, 0.6)),
                  ),
                  const SizedBox(height: 20,),
                  TextField(
                    maxLength       : Settings().phoneMaxLength,
                    textDirection   : TextDirection.ltr,
                    inputFormatters : [ PhoneFormatter() ],
                    keyboardType    : TextInputType.phone,
                    onChanged       : _phoneOnChanged,
                    decoration      : InputDecoration(
                                        labelText     : "Телефон",
                                        filled        : true,
                                        fillColor     : Color(0xFFECEFF1),
                                        enabledBorder : UI().borderStyle,
                                        focusedBorder : UI().borderStyle,
                    )),
                  const SizedBox(height: 20,),
                  TextField(
                    maxLength       : Settings().passMaxLength,
                    textDirection   : TextDirection.ltr,
                    obscureText     : true,
                    onChanged       : _passOnChanged,
                    decoration      : InputDecoration(
                                        labelText     : "Пароль",
                                        filled        : true,
                                        fillColor     : Color(0xFFECEFF1),
                                        enabledBorder : UI().borderStyle,
                                        focusedBorder : UI().borderStyle,
                    )),
                  Text('${_userPhone}/${_userPass}'), // вывод для отладки
                  const SizedBox(height: 28,),
                  SizedBox(
                      width  : 154,
                      height : 42,
                      child  : ElevatedButton(
                                      child  : Text("Войти"),
                                       style : UI().bnLoginStyle,
                                   onPressed : (){ _login (_userPhone, _userPass); },
                      )),
                  const SizedBox(height: 62,),
                  InkWell(
                    child: Text("Регистрация", style: UI().linkTextStyle),
                    onTap: () {
                      Navigator.of(context).pushNamedAndRemoveUntil(Settings().routeRegisterScreen, (route) => false);
                    }
                  ),
                  const SizedBox(height: 20,),
                  InkWell(
                    child: Text("Забыли пароль?",  style: UI().linkTextStyle),
                    onTap: () {
                      //deleteSharedPref();
                      // setState(() {
                      //     Settings().userData = null;
                      // });
                      Navigator.of(context).pushNamedAndRemoveUntil("/", (route) => false);
                    },),
                ],
              ),
            ),
          )
      ),
    );
  }
}


class RegisterScreen extends StatefulWidget {
  RegisterScreen({Key? key, required this.storage}) : super(key: key);
  final UserDataStorage storage;
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
//  static const routeName = '/register';
  String _userName  = "";
  String _userPhone = "";
  String _userPass1 = "";
  String _userPass2 = "";
  String _msgNoLogin = "Не задан номер телефонав качестве логина";
  String _msgNoPass  = "Не задан пароль";
  String _msgPasswordsAreDifferent   = "Пароли различаются!";
  String _msgCheckResult = "";
  String?   _userData;

  void _userNameOnChanged (String val){
    setState(() {
      _userName = val;
    });
  }

  void _phoneOnChanged (String val){
    setState(() {
      _userPhone = val;
    });
  }

  void _passOnChanged1 (String val){
    setState(() {
      _userPass1 = passEncode(val);
    });
  }
  void _passOnChanged2 (String val){
    setState(() {
      _userPass2 = passEncode(val);
    });
  }
  void _setSharedPref(String value) async {
    final sharedPref = await SharedPreferences.getInstance();
    try {
      sharedPref.setString( Settings().userDataFile, value );
    } catch (e) {}
  }
  Future <File> _writeUserData( String data ) {
    //setState(() {
    //  _userData = widget.sAccount;
    //});
    _msgCheckResult = "writing account...";
    return widget.storage.writeUserData( data );
  }

  /// - выполняется простейшая проверка на заполнение полей формы; ///
  /// - регистрационные данные пользователя упаковываются в JSON;  ///
  /// - JSON-объект сериализуется, результат записывается в файл.  ///
  void _submit () {
    if (_userPhone != "") {             // логин указан
      if (_userPass1 != "") {           // пароль указан
        if (_userPass1 == _userPass2) { // пароль подтвержден
          setState(() {
            _msgCheckResult = "OK!"; // для отладки, удалить
            User user = User( phone: _userPhone, pass: passEncode(_userPass1), name: _userName );
            Map<String, dynamic> JSON = user.toJSON();
            String encodedJSON = jsonEncode( JSON );
            _msgCheckResult = encodedJSON;  // для отладки, удалить
            //_setSharedPref(encodedJSON);
            _writeUserData( encodedJSON );
            _msgCheckResult = "account ${encodedJSON} created, then login";
            Navigator.of(context).pushNamedAndRemoveUntil(Settings().routeAuthScreen, (route) => false);
          });
        } else {
          setState(() {
            _msgCheckResult = _msgPasswordsAreDifferent;
          });
        }
      } else {
        setState(() {
          _msgCheckResult = _msgNoPass;
        });
      }
    } else {
      setState(() {
        _msgCheckResult = _msgNoLogin;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          body: Container(
            decoration : UI().containerDecoration,
            width      : double.infinity,
            height     : double.infinity,
            padding    : EdgeInsets.symmetric(horizontal: 50),
            child      : SingleChildScrollView(
              child: Column (
                children: [
                  const SizedBox(height: 150,),
                  UI().logo,
                  const SizedBox(height: 20,),
                  Text("Введите данные учетной записи,\n(логин в виде ${Settings().phoneMaxLength} цифр номера телефона)",
                    style: TextStyle(fontSize: 14, color: Color.fromRGBO(0, 0, 0, 0.6)),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20,),
                  TextField(
                      maxLength       : Settings().userNameMaxLength,
                      textDirection   : TextDirection.ltr,
                      onChanged       : _userNameOnChanged,
                      decoration      : InputDecoration(
                        labelText     : "Имя пользователя",
                        filled        : true,
                        fillColor     : Color(0xFFECEFF1),
                        enabledBorder : UI().borderStyle,
                        focusedBorder : UI().borderStyle,
                      )),
                  const SizedBox(height: 10,),
                  TextField(
                      maxLength       : Settings().phoneMaxLength,
                      textDirection   : TextDirection.ltr,
                      inputFormatters : [ PhoneFormatter() ],
                      keyboardType    : TextInputType.phone,
                      onChanged       : _phoneOnChanged,
                      decoration      : InputDecoration(
                        labelText     : "Телефон",
                        filled        : true,
                        fillColor     : Color(0xFFECEFF1),
                        enabledBorder : UI().borderStyle,
                        focusedBorder : UI().borderStyle,
                      )),
                  const SizedBox(height: 10,),
                  TextField(
                      maxLength       : Settings().passMaxLength,
                      textDirection   : TextDirection.ltr,
                      obscureText     : true,
                      onChanged       : _passOnChanged1,
                      decoration      : InputDecoration(
                        labelText     : "Пароль",
                        filled        : true,
                        fillColor     : Color(0xFFECEFF1),
                        enabledBorder : UI().borderStyle,
                        focusedBorder : UI().borderStyle,
                      )),
                  const SizedBox(height: 10,),
                  TextField(
                      maxLength       : Settings().passMaxLength,
                      textDirection   : TextDirection.ltr,
                      obscureText     : true,
                      onChanged       : _passOnChanged2,
                      decoration      : InputDecoration(
                        labelText     : "Пароль еще раз",
                        filled        : true,
                        fillColor     : Color(0xFFECEFF1),
                        enabledBorder : UI().borderStyle,
                        focusedBorder : UI().borderStyle,
                      )),
                  Text('${_userName}/${_userPhone}/${_msgCheckResult}'), // вывод для отладки
                  const SizedBox(height: 28,),
                  SizedBox(
                      width  : 174,
                      height : 42,
                      child  : ElevatedButton(
                                   child     : Text("Зарегистрироваться"),
                                   style     : UI().bnLoginStyle,
                                   onPressed : _submit,
                      )),
                  const SizedBox(height: 62,),

                ],
              ),
            ),
          )
      ),
    );
  }
}