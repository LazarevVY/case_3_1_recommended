import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'settings.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class UserDataStorage {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/userdata.txt');
  }

  Future<String> readUserData() async {
    try {
      final file = await _localFile;
      final contents = await file.readAsString();
      return contents;
    } catch (e) {
      return "";
    }
  }

  Future<File> writeUserData(String data) async {
    final file = await _localFile;
    return file.writeAsString( data );
  }
}

// Простое форматирование ввода телефонного номера российского оператора связи. //
// Код +7 не вводится, учитываются только цифры самого номера                   //

class PhoneFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    String newValueText = newValue.text.replaceAll(RegExp("[^0-9]"), "");
    int lastSelectionOffset = newValue.selection.end;
    return TextEditingValue(
        text: '${newValueText}',
        selection: TextSelection.collapsed(offset: lastSelectionOffset )//newValueText.length,),
    );
  }
}

class User {
  User ({required this.phone, required this.pass, this.name});

  final String? name;
  final String phone;
  final String pass;

  factory User.fromJSON (Map<String,dynamic> data) {
    final phone = data['phone'] as String;
    if (phone == null) {
      throw UnsupportedError('Invalid users data, login "phone" is missing');
    }
    final pass = data['pass'] as String;
    if (pass == null) {
      throw UnsupportedError('Invalid users data, password "pass" is missing');
    }
    // return User (phone: phone, pass: pass);
    final name = data['name'] as String?;
    return User (phone: phone, pass: pass, name: name);
  }

  Map <String,dynamic> toJSON () {
    return { 'phone' : phone, 'pass' : pass, if (name != null) 'name' : name  };
  }
}

class UI extends MaterialApp {

  final containerDecoration = const BoxDecoration(
      image: DecorationImage(
        image : AssetImage("assets/images/bg1.jpeg"),
        fit   : BoxFit.cover,
      ));

  final logo = const SizedBox(
      width   : 110,
      height  : 84,
      child   : Image(image: AssetImage("assets/images/dart-logo-bird.png",
      )));

  final borderStyle = const OutlineInputBorder(
      borderRadius : BorderRadius.all(Radius.circular(36)),
      borderSide   : BorderSide(
          color    : Color(0xffeceff1),
          width    : 5
      ));

  final linkTextStyle = const TextStyle(
      fontSize     : 16,
      color        : Color(0xFF0079D0)
  );

  final bnLoginStyle = ElevatedButton.styleFrom(
      primary : const Color(0xFF0079D0),
      shape   : RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(36.0)
      ));
}


// пароль когда-нибудь будет шифроваться, а пока это "заглушка" :) //
String passEncode (String val) {
  return val;
}

void deleteSharedPref() async {
  final sharedPref = await SharedPreferences.getInstance();
    sharedPref.remove (Settings().userDataFile);
}