import 'package:http/http.dart' as http;
import 'package:movies_app/domain/models/environment.dart';

final class ApiService {
  static Future<http.Response?> getMovies(String url) async {
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'accept': 'application/json',
          'Authorization':
              Environment.apiKey
        },
      );

      return response;
    } catch (e) {
      print(e);
    }

    return null;
  }

  static Future<http.Response?> getMovieDetails(num id) async {
    try {
      final response = await http.get(
        Uri.parse('https://api.themoviedb.org/3/movie/$id?language=ru-RU'),
        headers: {
          'accept': 'application/json',
          'Authorization':
          Environment.apiKey
        },
      );

      return response;
    } catch (e) {
      print(e);
    }
    return null;
  }

 static Future<http.Response?> getMovieTrailer(num id)async{
   try {
     final response = await http.get(
       Uri.parse('https://api.themoviedb.org/3/movie/$id/videos?language=ru-RU'),
       headers: {
         'accept': 'application/json',
         'Authorization':
         Environment.apiKey
       },
     );

     return response;
   } catch (e) {
     print(e);
   }
   return null;
 }

}
