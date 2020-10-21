import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cuthair/data/remote/remote_repository.dart';
import 'package:cuthair/model/Place.dart';
import 'package:cuthair/model/appointment.dart';
import 'package:cuthair/model/appointment_completed.dart';
import 'package:cuthair/model/business_type.dart';
import 'package:cuthair/model/employee.dart';
import 'package:cuthair/model/image_business.dart';
import 'package:cuthair/model/service.dart';
import 'package:cuthair/model/business.dart';
import 'package:cuthair/model/user.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart';

class HttpRemoteRepository implements RemoteRepository {
  final Client _client;

  List<QuerySnapshot> querySnapshots = [];

  HttpRemoteRepository(this._client);

  @override
  Future<String> createUserAuth(String email, password) async {
    var params = {"Email": email, "Password": password};
    var response = await _client.post(DotEnv().env['API_URL'] + "register",
        body: json.encode(params),
        headers: {
          HttpHeaders.contentTypeHeader: "application/json",
        });
    return response.body;
  }

  @override
  Future<Response> createUserData(Map values, String userId) async {
    var params = {
      "Id": userId,
      "Nombre": values['Nombre'],
      "Apellidos": values['Apellidos'],
      "Email": values['Email'],
      "Telefono": values['Telefono']
    };
    var response = await _client.post(DotEnv().env['API_URL'] + "user",
        body: json.encode(params),
        headers: {
          HttpHeaders.contentTypeHeader: "application/json",
        });
    return response;
  }

  @override
  Future<Response> loginUser(String email, password) async {
    var params = {"Email": email, "Password": password};
    var response = await _client.post(DotEnv().env['API_URL'] + "login",
        body: json.encode(params),
        headers: {
          HttpHeaders.contentTypeHeader: "application/json",
        });
    if (json.decode(response.body)['code'] == 400) {
      throw ('El usuario no exite');
    } else {
      return response;
    }
  }

  @override
  Future<User> getUser(String id, String accessToken) async {
    var uri = Uri.parse(DotEnv().env['API_URL'] + "user/" + id);
    var response = await _client.get(uri, headers: {
      "token": accessToken,
      HttpHeaders.contentTypeHeader: "application/json",
    });
    if (json.decode(response.body)['result'] == 'JWT failed') {
      throw ('JWT error');
    } else if (json.decode(response.body)['code'] == 200) {
      var data = json.decode(response.body)['result']['Usuarios'][0];
      User user = User.fromMap(data);
      return user;
    } else {
      throw ('Este usuario no existe');
    }
  }

  @override
  Future<String> generateNewToken(String refreshToken) async {
    var params = {"RefreshToken": refreshToken};
    var response = await _client.post(DotEnv().env['API_URL'] + "token",
        body: json.encode(params),
        headers: {
          HttpHeaders.contentTypeHeader: "application/json",
        });
    var token = json.decode(response.body)['result']['AccessToken'];
    return token;
  }

  @override
  Future<List<BusinessType>> getBusinessTypes() async {
    var uri = Uri.parse(DotEnv().env['API_URL'] + "business/types");
    var response = await _client.get(uri, headers: {
      HttpHeaders.contentTypeHeader: "application/json",
    });
    if (json.decode(response.body)['result'] == 'JWT failed') {
      throw ("JWT error");
    } else {
      List<BusinessType> types = [];
      var data = json.decode(response.body)['result']['TipoNegocios'];
      data.forEach((element) {
        BusinessType businessType = BusinessType.fromMap(element);
        types.add(businessType);
      });
      if (types.isEmpty) {
        throw ('No hay tipos');
      } else {
        return types;
      }
    }
  }

  @override
  Future<BusinessType> getBusinessTypeById(
      String accessToken, String id) async {
    var uri = Uri.parse(DotEnv().env['API_URL'] + "business/types/" + id);
    var response = await _client.get(uri, headers: {
      HttpHeaders.contentTypeHeader: "application/json",
    });
    if (json.decode(response.body)['result'] == 'JWT failed') {
      throw ("JWT error");
    } else if (json.decode(response.body)['code'] == 200) {
      BusinessType type =
          BusinessType.fromMap(json.decode(response.body)['result']);
      return type;
    } else {
      throw ("No existe dicho tipo");
    }
  }

  @override
  Future<List<Business>> getAllBusiness() async {
    var uri = Uri.parse(DotEnv().env['API_URL'] + "business");
    var response = await _client.get(uri, headers: {
      HttpHeaders.contentTypeHeader: "application/json",
    });
    if (json.decode(response.body)['result'] == 'JWT failed') {
      throw ("JWT error");
    } else {
      List<Business> businesses = [];
      List data = json.decode(response.body)['result']['Negocios'];
      data.forEach((element) {
        Business business = Business.fromMap(element);
        businesses.add(business);
      });
      return businesses;
    }
  }

  @override
  Future<Business> getBusinessById(String accessToken, String id) async {
    var uri = Uri.parse(DotEnv().env['API_URL'] + "business/" + id);
    var response = await _client.get(uri, headers: {
      "token": accessToken,
      HttpHeaders.contentTypeHeader: "application/json",
    });
    if (json.decode(response.body)['result'] == 'JWT failed') {
      throw ("JWT error");
    } else if (json.decode(response.body)['code'] == 200) {
      Business business =
          Business.fromMap(json.decode(response.body)['result']);
      return business;
    } else {
      throw ("No existe dicho negocio");
    }
  }

  @override
  Future<List<Service>> getAllServices(
      String businessId, String accessToken) async {
    List<Service> services = [];
    var uri = Uri.parse(
        DotEnv().env['API_URL'] + "business/" + businessId + "/services");
    var response = await _client.get(uri, headers: {
      "token": accessToken,
      HttpHeaders.contentTypeHeader: "application/json",
    });
    if (json.decode(response.body)['result'] == 'JWT failed') {
      throw ("JWT error");
    } else if (json.decode(response.body)['code'] == 200) {
      List data = json.decode(response.body)['result']['Servicios'];
      data.forEach((element) {
        Service service = Service.fromMap(element);
        services.add(service);
      });
      return services;
    } else {
      throw ("No existen servicios para este negocio");
    }
  }

  @override
  Future<Service> getServiceById(
      String accessToken, String id, String businessId) async {
    var uri = Uri.parse(
        DotEnv().env['API_URL'] + "business/" + businessId + "/services/" + id);
    var response = await _client.get(uri, headers: {
      "token": accessToken,
      HttpHeaders.contentTypeHeader: "application/json",
    });
    if (json.decode(response.body)['result'] == 'JWT failed') {
      throw ("JWT error");
    } else if (json.decode(response.body)['code'] == 200) {
      Service service = Service.fromMap(json.decode(response.body)['result']);
      return service;
    } else {
      throw ("No existen este servicio");
    }
  }

  @override
  Future<List<Employee>> getAllEmployes(
      String businessId, String accessToken) async {
    List<Employee> employees = [];
    var uri = Uri.parse(
        DotEnv().env['API_URL'] + "business/" + businessId + "/employees");
    var response = await _client.get(uri, headers: {
      "token": accessToken,
      HttpHeaders.contentTypeHeader: "application/json",
    });
    if (json.decode(response.body)['result'] == 'JWT failed') {
      throw ("JWT error");
    } else if (json.decode(response.body)['code'] == 200) {
      List data = json.decode(response.body)['result']['Empleados'];
      data.forEach((element) {
        Employee employee = Employee.fromMap(element);
        employees.add(employee);
      });
      return employees;
    } else {
      throw ("No existen empleados para este negocio");
    }
  }

  @override
  Future<Employee> getEmployeeById(String accessToken, String id) async {
    var uri = Uri.parse(DotEnv().env['API_URL'] + "employee/" + id);
    var response = await _client.get(uri, headers: {
      "token": accessToken,
      HttpHeaders.contentTypeHeader: "application/json",
    });
    if (json.decode(response.body)['result'] == 'JWT failed') {
      throw ("JWT error");
    } else if (json.decode(response.body)['code'] == 200) {
      Employee employee =
          Employee.fromMap(json.decode(response.body)['result']);
      return employee;
    } else {
      throw ("No existen este empleado");
    }
  }

  @override
  Future<List<String>> getDisponibility(String accessToken, String employeeId,
      String typeBusiness, String date, String duration) async {
    var uri = Uri.parse(DotEnv().env['API_URL'] +
        "employee/" +
        employeeId +
        "/availabilities/" +
        typeBusiness +
        "/" +
        date +
        "/" +
        duration);
    var response = await _client.get(uri, headers: {
      "token": accessToken,
      HttpHeaders.contentTypeHeader: "application/json",
    });
    if (json.decode(response.body)['result'] == 'JWT failed') {
      throw ("JWT error");
    } else if (json.decode(response.body)['code'] == 400) {
      throw ("Error en la disponibilidad");
    } else {
      List<String> data = [];
      List values = json.decode(response.body)['result']['Availability'];
      values.forEach((element) {
        data.add(element);
      });
      return data;
    }
  }

  @override
  Future<bool> insertAppointment(
      Appointment appointment, String accessToken, var params) async {
    var uri = Uri.parse(DotEnv().env['API_URL'] +
        "user/" +
        appointment.userId +
        "/appointments");
    var response = await _client.post(uri,
        headers: {
          "token": accessToken,
          HttpHeaders.contentTypeHeader: "application/json",
        },
        body: json.encode(params));
    if (json.decode(response.body)['result'] == 'JWT failed') {
      throw ("JWT error");
    } else if (json.decode(response.body)['code'] == 200) {
      Appointment appointment = Appointment.fromMap(
          json.decode(response.body)["result"]["Insertado"], false);
      if (appointment.id != null) {
        return true;
      } else {
        return false;
      }
    } else {
      throw ("Ha ocurrido un error en la creacion");
    }
  }

  @override
  Future<bool> insertAppointmentPlace(
      Appointment appointment, String accessToken, var params) async {
    var uri = Uri.parse(DotEnv().env['API_URL'] +
        "place/" +
        appointment.plazaCitaId +
        "/appointments");
    var response = await _client.post(uri,
        headers: {
          "token": accessToken,
          HttpHeaders.contentTypeHeader: "application/json",
        },
        body: json.encode(params));
    if (json.decode(response.body)['result'] == 'JWT failed') {
      throw ("JWT error");
    } else if (json.decode(response.body)['code'] == 200) {
      return true;
    } else {
      throw ("Ha ocurrido un error en la creacion");
    }
  }

  @override
  Future<List<Appointment>> getUserAppointments(
      String id, String accessToken) async {
    var uri =
        Uri.parse(DotEnv().env['API_URL'] + "user/" + id + "/appointments");
    var response = await _client.get(uri, headers: {
      "token": accessToken,
      HttpHeaders.contentTypeHeader: "application/json",
    });
    List<Appointment> data = [];
    if (json.decode(response.body)['result'] == 'JWT failed') {
      throw ("JWT error");
    } else {
      List values = json.decode(response.body)['result'];
      values.forEach((element) {
        Appointment appointment = Appointment.fromMap(element, true);
        data.add(appointment);
      });
      return data;
    }
  }

  Future<bool> updateDataUser(User user, String accessToken) async {
    var params = {
      "Id": user.id,
      "Nombre": user.name,
      "Apellidos": user.surname,
      "Email": user.email,
      "Telefono": user.phone
    };
    var uri = Uri.parse(DotEnv().env['API_URL'] + "user/" + user.id);
    var response = await _client.put(uri,
        headers: {
          "token": accessToken,
          HttpHeaders.contentTypeHeader: "application/json",
        },
        body: json.encode(params));
    if (json.decode(response.body)['result'] == 'JWT failed') {
      throw ("JWT error");
    } else if (json.decode(response.body)['code'] == 200) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Future<List<ImageBusiness>> getAllImages(
      Business business, String accessToken) async {
    List<ImageBusiness> list = [];
    var uri = Uri.parse(
        DotEnv().env['API_URL'] + "business/" + business.id + "/photos");
    var response = await _client.get(uri, headers: {
      "token": accessToken,
      HttpHeaders.contentTypeHeader: "application/json",
    });
    var data = json.decode(response.body)['result'];
    if (data == 'JWT failed') {
      throw ("JWT error");
    } else if (json.decode(response.body)['code'] == 200) {
      List objects = data['Fotos'];
      objects.forEach((element) {
        ImageBusiness image = ImageBusiness.fromMap(element);
        list.add(image);
      });
      return list;
    } else {
      throw ("No hay imagenes");
    }
  }

  @override
  Future<bool> removeAppointment(
      AppointmentCompleted appointment, String accessToken) async {
    var uri = Uri.parse(DotEnv().env['API_URL'] +
        "user/" +
        appointment.user.id +
        "/appointments/" +
        appointment.appointment.id +
        "/" +
        appointment.businessType.type);
    var response = await _client.delete(uri, headers: {
      "token": accessToken,
      HttpHeaders.contentTypeHeader: "application/json",
    });
    var data = json.decode(response.body)['result'];
    if (data == 'JWT failed') {
      throw ("JWT error");
    } else if (json.decode(response.body)['code'] == 200) {
      return true;
    } else {
      throw ("No se ha podido borrar la cita");
    }
  }

  @override
  Future<String> getVersionApp(String software) async {
    var uri = Uri.parse(DotEnv().env['API_URL'] + "version/Cliente/type/" + software);
    var response = await _client.get(uri);
    if (json.decode(response.body)['result'] == 'JWT failed') {
      throw ("JWT error");
    } else if (json.decode(response.body)['code'] == 200) {
      return json.decode(response.body)["result"];
    } else {
      throw ("No existen turnos");
    }
  }

  @override
  Future<List<Place>> getAllPLace(String accessToken, String businessId) async {
    var uri = Uri.parse(
        DotEnv().env['API_URL'] + "business/" + businessId + "/places");
    var response = await _client.get(uri, headers: {
      "token": accessToken,
      HttpHeaders.contentTypeHeader: "application/json",
    });
    List<Place> data = [];
    if (json.decode(response.body)['result'] == 'JWT failed') {
      throw ("JWT error");
    } else if (json.decode(response.body)['code'] == 200) {
      List aux = json.decode(response.body)['result']['Plazas'];
      aux.forEach((element) {
        Place place = Place.fromMap(element);
        data.add(place);
      });
      return data;
    } else {
      throw ("No existen plazas");
    }
  }

  @override
  Future<Place> getPlaceById(String accessToken, String placeId) async {
    var uri = Uri.parse(DotEnv().env['API_URL'] + "place/" + placeId);
    var response = await _client.get(uri, headers: {
      "token": accessToken,
      HttpHeaders.contentTypeHeader: "application/json",
    });
    if (json.decode(response.body)['result'] == 'JWT failed') {
      throw ("JWT error");
    } else if (json.decode(response.body)['code'] == 200) {
      Map data = json.decode(response.body)['result'];
      Place place = Place.fromMap(data);
      return place;
    } else {
      throw ("No existen plazas");
    }
  }

  @override
  Future<bool> getUserPenalization(String accessToken, String userId) async {
    var uri =
        Uri.parse(DotEnv().env['API_URL'] + "user/" + userId + "/penalizes");
    var response = await _client.get(uri, headers: {
      "token": accessToken,
      HttpHeaders.contentTypeHeader: "application/json",
    });
    if (json.decode(response.body)['result'] == 'JWT failed') {
      throw ("JWT error");
    } else if (json.decode(response.body)['code'] == 200) {
      bool penalization =
          jsonDecode(response.body)['result']['Usuarios']['Penalizacion'];
      return penalization;
    } else {
      throw ("Error al cargar penalizacion");
    }
  }

  @override
  Future<String> resetPassword(String email) async {
    var uri = Uri.parse(DotEnv().env['API_URL'] + "reset");
    var params = {"Email": email};
    var response = await _client.post(uri, body: json.encode(params), headers: {
      HttpHeaders.contentTypeHeader: "application/json",
    });
    if (json.decode(response.body)['result'] == 'JWT failed') {
      throw ("JWT error");
    } else if (json.decode(response.body)['code'] == 200) {
      return response.body;
    } else {
      throw ("No se ha podido cambiar");
    }
  }
}
