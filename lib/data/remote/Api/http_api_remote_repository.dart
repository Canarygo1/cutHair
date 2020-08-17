import 'dart:convert';
import 'package:cuthair/data/remote/Api/api_remote_repository.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart';

class HttpApiRemoteRepository extends ApiRemoteRepository{
  final Client _client;

  HttpApiRemoteRepository(this._client);

  @override
  Future<List<String>> getHairDressingAvailability(String duration, String hairdresser, String date, String businessUid) async {
    var uri = Uri.parse(DotEnv().env['GET_DATA_HAIRDRESSING']);
    List<String> availabity = [];
    uri = uri.replace(queryParameters:<String,String>{
      "date":date,
      "peluquero":hairdresser,
      "duration":duration,
      "businessUid": businessUid,
      "mode":DotEnv().env['GET_NEGOCIO']
    });

    //Con typeBusiness cambiará el get para la recogida del objeto
    var response = await _client.get(uri);
    availabity = json.decode(response.body).cast<String>();
    return availabity;
  }

  @override
  Future<List<String>> getRestaurantAvailability(String duration, String numberPersons, String date, String businessUid) async {
    var uri = Uri.parse(DotEnv().env['GET_DATA_RESTAURANT']);
    List<String> availabity = [];

    uri = uri.replace(queryParameters:<String,String>{
      "date":date,
      "numberPersons": numberPersons,
      "duration":duration,
      "businessUid": businessUid,
      "mode":DotEnv().env['GET_NEGOCIO']
    });

    //Con typeBusiness cambiará el get para la recogida del objeto
    var response = await _client.get(uri);
    availabity = json.decode(response.body).cast<String>();
    return availabity;
  }

  @override
  Future<List<String>> getBeachAvailability(String duration, String numberPersons, String date, String businessUid) async {
    var uri = Uri.parse(DotEnv().env['GET_DATA_BEACH']);
    List<String> availabity = [];

    uri = uri.replace(queryParameters:<String,String>{
      "date":date,
      "numberPersons": numberPersons,
      "duration":duration,
      "businessUid": businessUid,
      "mode":DotEnv().env['GET_NEGOCIO']
    });

    var response = await _client.get(uri);
    availabity = json.decode(response.body).cast<String>();
    return availabity;
  }
}


