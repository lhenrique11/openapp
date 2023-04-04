import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:openapp/model/modelclass.dart';
import 'package:openapp/service/movieservice.dart';
import 'package:responsive_framework/responsive_framework.dart';

class SearchApi extends StatefulWidget {
  const SearchApi({super.key});

  @override
  State<SearchApi> createState() => _SearchApiState();
}

class _SearchApiState extends State<SearchApi> {

 final TextEditingController _textController = TextEditingController();
 List<Movie> _movies = [];

  void _searchMovies(String query) async {
    final movies = await MovieService.searchMovies(query);

    setState(() {
      _movies = movies;
    });
  }


// criação da interface para exibição da lista pesquisada

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
        title: TextField(
          controller: _textController,
          decoration: const InputDecoration(
            hintText: 'Search movies',
          ),
          onSubmitted: (query) => _searchMovies(query),
        ),
      ),
      body: ListView.builder(
        itemCount: _movies.length,
        itemBuilder: (context, index) {
          final movie = _movies[index];

          return ListTile(
            title: Text(movie.title),
            subtitle: Text(movie.year),
            leading: Image.network(movie.poster),
          );
        },
      ),
    ),
    )
    );
  }
}