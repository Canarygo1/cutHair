import 'dart:convert';
import 'package:cuthair/data/remote/Api/api_remote_repository.dart';
import 'package:http/http.dart';

class HttpApiRemoteRepository extends ApiRemoteRepository{
  final Client _client;

  HttpApiRemoteRepository(this._client);

  @override
  Future<List<String>> getAvailability(String duration, String hairdresser, String date) async {
    var uri = Uri.parse("https://us-central1-pruebafirebase-44f30.cloudfunctions.net/getData");
    List<String> availabity = [];
    uri = uri.replace(queryParameters:<String,String>{
      "date":date,
      "peluquero":hairdresser,
      "duration":duration
    });

    var response = await _client.get(uri);
    availabity = json.decode(response.body).cast<String>();
    return availabity;
  }
}


