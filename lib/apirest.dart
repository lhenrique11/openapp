import 'dart:convert';


import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:http/http.dart' as http;
import 'package:responsive_framework/responsive_wrapper.dart';


class ApiRest extends StatefulWidget {
  const ApiRest({super.key});

  @override
  State<ApiRest> createState() => _ApiRestState();
}

class _ApiRestState extends State<ApiRest> {


// função de solicitação de dados
Future<Map<String, dynamic>> getData() async {
  final response = await http.get(Uri.parse('http://www.omdbapi.com/?i=tt3896198&apikey=7f99ec5f&?t=The+Avengers'));

  if (response.statusCode == 200) {
    return json.decode(response.body);
  } else {
    throw Exception('Failed to load data');
  }
}


 // chamar a função e exibir de diversas formas na tela

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
            appBar: AppBar(title: const Text('ApiRest')),
            body: FutureBuilder(
              future: getData(),
              builder:(context, snapshot) {
                if (snapshot.hasData) {
                   return Center(
                   child: Text(snapshot.data!['Title']),
                  );
                } else if (snapshot.hasError){
                    return Center(
                    child: Text('${snapshot.hasError}'),
                  );
                }
                else {
                  return const Center(
                  child: CircularProgressIndicator(),
                  );
                }
              },
            )
          ),
        )
      );
    }
}