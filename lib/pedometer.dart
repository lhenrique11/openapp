import 'dart:async';

import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:pedometer/pedometer.dart';

class Pedometer extends StatefulWidget {
  static var stepCountStream;

 

  const Pedometer({Key? key, required this.title}) : super(key: key);

   final String title;

  @override
  State<Pedometer> createState() => _PedometerState();
}

class _PedometerState extends State<Pedometer> {

int _stepCount = 0; // variavel de estado
StreamSubscription<int>? _subscription; // para atualizar a contagem de passos


// instanciar e registrar ouvinte para receber atualizaçãoes do numero de passos
@override
  void initState() {
    super.initState();
    _subscription = Pedometer.stepCountStream?.listen(_onData, onError: _onError, onDone: _onDone, cancelOnError: true);
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  void _onData(int stepCountValue) {
    setState(() {
      _stepCount = stepCountValue;
    });
  }

  void _onDone() {}

  void _onError(error) {
    print('Pedometer error: $error');
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
            title: const Text('Pedometer'),),
            body: Center(
              child: Text(
                'Step count: $_stepCount',
                style: const TextStyle(fontSize: 24),
              ),
            )
          ),
        ),
    );
  }
}