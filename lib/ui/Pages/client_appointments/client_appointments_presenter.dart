import 'package:cuthair/data/local/db_sqlite.dart';
import 'package:cuthair/data/remote/remote_repository.dart';
import 'package:cuthair/global_methods.dart';
import 'package:cuthair/model/Place.dart';
import 'package:cuthair/model/appointment.dart';
import 'package:cuthair/model/appointment_completed.dart';
import 'package:cuthair/model/business_type.dart';
import 'package:cuthair/model/image_business.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ClientAppointmentsPresenter {
  MyAppointmentsView _view;
  RemoteRepository _remoteRepository;
  List<String> allImages = [];
  final storage = new FlutterSecureStorage();

  ClientAppointmentsPresenter(this._view, this._remoteRepository);

  init(String userUid, bool isSelectedDay) async {
    allImages = [];
    try {
      String accessToken = await storage.read(key: 'AccessToken');
      List<Appointment> myAppointments = [];
      myAppointments = await _remoteRepository.getUserAppointments(
          userUid, accessToken);
      List<AppointmentCompleted> dataValues = [];
      for (Appointment appointment in myAppointments) {
        Place place;
        List<ImageBusiness> images = await _remoteRepository.getAllImages(appointment.business, accessToken);
        if(images.isEmpty){
          appointment.business.widget = Image.asset(
            'assets/images/Name.png',
            fit: BoxFit.cover,
          );
        }else{
          ImageBusiness imageBusiness = images.firstWhere((element) => element.type == "logo");
          appointment.business.widget = Image.network(
            imageBusiness.url,
            fit: BoxFit.cover,
          );
        }
        BusinessType businessType = await _remoteRepository.getBusinessTypeById(accessToken, appointment.business.typeId);
        AppointmentCompleted appointmentCompleted;
        if(appointment.business.useEmployees == true){
          appointmentCompleted = AppointmentCompleted(
              appointment,
              appointment.business,
              businessType,
              appointment.service,
              DBProvider.users[0], employee: appointment.employee);
        }else{
          appointmentCompleted = AppointmentCompleted(
              appointment,
              appointment.business,
              businessType,
              appointment.service,
              DBProvider.users[0], place: place);
        }
        dataValues.add(appointmentCompleted);
      }
      _view.showAppointments(dataValues);
    } catch (e) {
      print(e);
      if (e == 'JWT error') {
        String refreshToken = await storage.read(key: 'RefreshToken');
        await GlobalMethods().generateNewAccessToken(refreshToken);
        await init(userUid, isSelectedDay);
      }
      _view.emptyAppointment();
    }
  }

  removeAppointment(AppointmentCompleted appointment,
      DateTime date) async {
    try {
      String accessToken = await storage.read(key: 'AccessToken');
      await _remoteRepository.removeAppointment(appointment, accessToken);
      await init(appointment.appointment.userId, true);
    } catch (Exception) {
      if (Exception == 'JWT error') {
        String refreshToken = await storage.read(key: 'RefreshToken');
        await GlobalMethods().generateNewAccessToken(refreshToken);
        await removeAppointment(appointment, date);
      }
      _view.emptyAppointment();
    }
  }
}

abstract class MyAppointmentsView {
  showAppointments(List<AppointmentCompleted> myAppointment);
  emptyAppointment();
}
