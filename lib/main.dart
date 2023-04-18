import 'package:flutter/material.dart';
import 'package:openapp/authgoogle.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:openapp/db_helper.dart';
import 'package:openapp/sqflite.dart';

final dbHelper = DatabaseHelper();
void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  await dbHelper.init();
  runApp(const Sqflite());
}