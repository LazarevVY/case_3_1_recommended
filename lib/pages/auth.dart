import 'package:case_3_1_recommended/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PhoneFormatter extends TextInputFormatter {
  PhoneFormatter(){}

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    String newValueText = newValue.text.replaceAll(RegExp("[^0-9]"), "");
    return TextEditingValue(
      text: '${newValueText}',
      selection: TextSelection.collapsed(offset: newValueText.length,),
    );
  }
}


class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  String _userName = "";
  String _userPass = "";
  final _phoneMaxLength = 10;
  final _passMaxLength = 10;

  void _phoneOnChanged (String val){
    setState(() {
        _userName = val;
    });
  }
  void _passOnChanged (String val){
    setState(() {
      _userPass = val;
    });
  }

  @override
  Widget build(BuildContext context) {

    const borderStyle = OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(36)),
        borderSide: BorderSide(
            color: const Color(0xffeceff1),
            width: 5
        )
    );
    const linkTextStyle = TextStyle(
        fontSize: 16,
        color: Color(0xFF0079D0)
    );


    return MaterialApp(
      home: Scaffold(
          body: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/bg1.jpeg"),
                fit: BoxFit.cover,
              ),
            ),
            width: double.infinity,
            height: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 50),
            child: SingleChildScrollView(
              child: Column (
                children: [
                  const SizedBox(height: 150,),
                  const SizedBox(
                    width: 110,
                    height: 84,
                    child: Image(image: AssetImage("assets/images/dart-logo-bird.png",
                    ),),
                  ),
                  const SizedBox(height: 20,),
                  Text("Введите логин ${_userName} в виде ${_phoneMaxLength} цифр номера телефона",
                    style: TextStyle(
                        fontSize: 16,
                        color: Color.fromRGBO(0, 0, 0, 0.6)
                    ),
                  ),
                  const SizedBox(height: 20,),
                  TextField(
                    maxLength: _phoneMaxLength,
                    textDirection: TextDirection.ltr,
                    inputFormatters: [PhoneFormatter()],
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(
                      filled: true,
                      fillColor: Color(0xFFECEFF1),
                      enabledBorder: borderStyle,
                      focusedBorder: borderStyle,
                      labelText: "Телефон",
                    ),
                    onChanged: _phoneOnChanged,
                  ),
                  const SizedBox(height: 20,),
                  TextField(
                    maxLength: _passMaxLength,
                    obscureText: true,
                    decoration: const InputDecoration(
                      filled: true,
                      fillColor: Color(0xFFECEFF1),
                      enabledBorder: borderStyle,
                      focusedBorder: borderStyle,
                      labelText: "Пароль",
                    ),
                    onChanged: _passOnChanged,
                  ),
                  const SizedBox(height: 28,),
                  SizedBox(
                      width: 154, height: 42,
                      child: ElevatedButton(onPressed: (){}, child: Text("Войти"),
                        style: ElevatedButton.styleFrom(
                          primary: Color(0xFF0079D0),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(36.0)
                          ),
                        ),
                      )
                  ),
                  const SizedBox(height: 62,),
                  InkWell(child: const Text("Регистрация", style: linkTextStyle),
                      onTap: () {}
                  ),
                  const SizedBox(height: 20,),
                  InkWell(child: Text("Забыли пароль?",  style: linkTextStyle),
                    onTap: () {},),
                ],
              ),
            ),
          )
      ),
    );
  }
}
