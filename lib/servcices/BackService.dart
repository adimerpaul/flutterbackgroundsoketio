import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';
import 'package:socket_io_client/socket_io_client.dart';
import '../globals.dart' as globals;
Future<void> initializeService() async{
  final service = await FlutterBackgroundService();
  await service.configure(
      iosConfiguration: IosConfiguration(
        autoStart: true,
        onForeground: onStart,
        onBackground: onIosBackground,
      ),
      androidConfiguration: AndroidConfiguration(
          onStart: onStart,
          isForegroundMode: true,
          autoStart: true,
      )
  );
}
@pragma('vm:entry-point')
Future<bool> onIosBackground(ServiceInstance service) async{
  WidgetsFlutterBinding.ensureInitialized();
  DartPluginRegistrant.ensureInitialized();
  return true;
}
@pragma('vm:entry-point')
void onStart(ServiceInstance service) {
  DartPluginRegistrant.ensureInitialized();
  if (service is AndroidServiceInstance) {
    service.on('setAsForeground').listen((event) {
      service.setAsForegroundService();
    });
    service.on('setAsBackground').listen((event) {
      service.setAsBackgroundService();
    });
  }
  service.on('stopService').listen((event) {
    service.stopSelf();
  });

  // Timer.periodic(const Duration(seconds: 1), (timer) async {
  //   if(service is AndroidServiceInstance){
  //     if ( await service.isForegroundService()) {
  //       service.setForegroundNotificationInfo(
  //           title: "SCRIPT ACADEMY",
  //           content: "sub my channel",
  //       );
  //     }
  //   }
  //   print("Hello from the background");
  //   service.invoke('update');

  //
  // });
  connectToSocketServer(1);
}

Future<void> connectToSocketServer(id) async {
  // print('connecting to socket server');
  final String serverUrl = 'http://192.168.1.40:3000';
  // late Socket socket;
  try{
    globals.socket = await io(serverUrl, <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
      'query': 'id=$id'
    });
    globals.socket.on('connect', (_) {
      print('connect');
    });
    globals.socket.on('rehabilitacion', (data){
      print(data['message']);
      // showNotification(data['message']);
    });
    globals.socket.on('pago_estado', (data){
      print('socket pago_estado');
      print(data);
      // changeCorteStatus(data['corte_id'], 'ES PAGADO', data['message']);
    });
    globals.socket.connect();
  }catch(e){
    print(e.toString());
  }
}