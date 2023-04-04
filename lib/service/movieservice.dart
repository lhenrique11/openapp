import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:openapp/model/modelclass.dart';

// serviço de busca dos filmes

class MovieService {

  static Future<List<Movie>> searchMovies(String query) async {

    final response = await http.get(Uri.parse('http://www.omdbapi.com/?i=tt3896198&apikey=7f99ec5f&s=$query'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      if (data['Response'] == 'True') {
        final List<Movie> movies = [];

        for (final movieData in data['Search']) {
          final movie = Movie(
            title: movieData['Title'],
            year: movieData['Year'],
            poster: movieData['Poster'],
          );

          movies.add(movie);
        }

        return movies;
      }
    }

    return [];
  }
}
