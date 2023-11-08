import 'package:back2/pages/HomePage.dart';
import 'package:back2/servcices/BackService.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Permission.notification.isDenied.then((value){
    if(value){
      Permission.notification.request();
    }
  });
  await initializeService();
  runApp(const  MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Yaku SeLA',
      home: HomePage(),
    );
  }
}
