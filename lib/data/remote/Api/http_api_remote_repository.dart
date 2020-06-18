import 'dart:convert';
import 'package:cuthair/data/remote/Api/api_remote_repository.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:http/http.dart';

class HttpApiRemoteRepository extends ApiRemoteRepository{
  final Client _client;

  HttpApiRemoteRepository(this._client);

  @override
  Future<List<String>> getHairDressingAvailability(String duration, String hairdresser, String date, String businessUid) async {
    //Pasas typeBusiness
    var uri = Uri.parse('https://us-central1-pruebafirebase-44f30.cloudfunctions.net/getData');
    List<String> availabity = [];

    uri = uri.replace(queryParameters:<String,String>{
      "date":date,
      "peluquero":hairdresser,
      "duration":duration,
      "businessUid": businessUid
    });

    //Con typeBusiness cambiará el get para la recogida del objeto
    var response = await _client.get(uri);
    availabity = json.decode(response.body).cast<String>();
    return availabity;
  }

  @override
  Future<List<String>> getRestaurantAvailability(String duration, String numberPersons, String date, String businessUid) async {
    var uri = Uri.parse(FlutterConfig.get('GET_DATA_RESTAURANT'));
    List<String> availabity = [];

    uri = uri.replace(queryParameters:<String,String>{
      "date":date,
      "numberPersons": numberPersons,
      "duration":duration,
      "businessUid": businessUid
    });

    //Con typeBusiness cambiará el get para la recogida del objeto
    var response = await _client.get(uri);
    availabity = json.decode(response.body).cast<String>();
    return availabity;
  }

  @override
  Future<List<String>> getBeachAvailability(String duration, String numberPersons, String date, String businessUid) async {
    var uri = Uri.parse(FlutterConfig.get('GET_DATA_BEACH'));
    List<String> availabity = [];

    uri = uri.replace(queryParameters:<String,String>{
      "date":date,
      "numberPersons": numberPersons,
      "duration":duration,
      "businessUid": businessUid
    });

    var response = await _client.get(uri);
    availabity = json.decode(response.body).cast<String>();
    return availabity;
  }
}


