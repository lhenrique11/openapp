import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:openapp/db_helper.dart';
import 'package:openapp/sqflite.dart';

final dbHelper = DatabaseHelper();

class Sqflite extends StatefulWidget {
  const Sqflite({super.key});

  @override
  State<Sqflite> createState() => _SqfliteState();
}

class _SqfliteState extends State<Sqflite> {


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
          child:  Scaffold(
            appBar: AppBar(
            title: const Text('sqflite'),
          ),
          body: Center(
            child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const <Widget>[
              ElevatedButton(
                onPressed: _insert,
                child: Text('insert'),
              ),
              SizedBox(height: 10),
              ElevatedButton(
              onPressed: _query,
              child: Text('query'),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: _update,
                child: Text('update'),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: _delete,
                child: Text('delete'),
              ),
            ],
          ),
        ),
      ),
    ),
    );
  }
}

  // Button onPressed methods

  void _insert() async {
    // inserir
    Map<String, dynamic> row = {
      DatabaseHelper.columnName: 'Bob',
      DatabaseHelper.columnAge: 23
    };
    final id = await dbHelper.insert(row);
    debugPrint('inserted row id: $id');
  }

  void _query() async {
    final allRows = await dbHelper.queryAllRows();
    debugPrint('query all rows:');
    for (final row in allRows) {
      debugPrint(row.toString());
    }
  }

  void _update() async {
    //atualizar
    Map<String, dynamic> row = {
      DatabaseHelper.columnId: 1,
      DatabaseHelper.columnName: 'Mary',
      DatabaseHelper.columnAge: 32
    };
    final rowsAffected = await dbHelper.update(row);
    debugPrint('updated $rowsAffected row(s)');
  }

  void _delete() async {
    //deletar
    final id = await dbHelper.queryRowCount();
    final rowsDeleted = await dbHelper.delete(id);
    debugPrint('deleted $rowsDeleted row(s): row $id');
  }
