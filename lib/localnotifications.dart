import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:responsive_framework/responsive_wrapper.dart';

class LocalNotifications extends StatefulWidget {
  const LocalNotifications({super.key});

  @override
  State<LocalNotifications> createState() => _LocalNotificationsState();
}

class _LocalNotificationsState extends State<LocalNotifications> {

// criar uma váriavel global inicializando a classe Flutter Local Notifications Plugin
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();


// crie uma função async para inicializar o plugin e configure as notificações
Future<void> initNotifications() async {
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');
   const InitializationSettings initializationSettings =
      InitializationSettings(android: initializationSettingsAndroid);
  await flutterLocalNotificationsPlugin.initialize(initializationSettings);
}


// chame a initNotifications
@override
void initState() {
  super.initState();
  initNotifications();
}


// crie uma função async para a exibição da notificação local
Future<void> showNotification() async {
  const AndroidNotificationDetails androidPlatformChannelSpecifics =
      AndroidNotificationDetails(
    'channel_id',
    'channel_name',
    importance: Importance.max,
    priority: Priority.high,
    ticker: 'ticker',
  );
  const NotificationDetails platformChannelSpecifics =
      NotificationDetails(android: androidPlatformChannelSpecifics);
  await flutterLocalNotificationsPlugin.show(
    0,
    'Notification Title',
    'Notification Body',
    platformChannelSpecifics,
  );
}


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      builder: (context, child) => ResponsiveWrapper.builder(
        child,
        maxWidth: 1200,
        minWidth: 480,
        defaultScale: true,
        breakpoints: [
          const ResponsiveBreakpoint.resize(480, name: MOBILE),
          const ResponsiveBreakpoint.autoScale(800, name: TABLET),
          const ResponsiveBreakpoint.resize(1200, name: DESKTOP),
        ],
        background: Container(color: Colors.white,)),
        home: NotificationListener<OverscrollIndicatorNotification>(
          onNotification: (overScroll){
            overScroll.disallowIndicator();
            return true;
          },
          child: Scaffold(
            appBar: AppBar(
            title: const Text('Flutter Local Notifications'),),
            body: Center(
              child: ElevatedButton(
                onPressed: () async {
                  await showNotification(); // ação para mostar a notificação local
                },
                child: const Text('Local Notification')),
            ),
          )
        ),
    );
  }
}