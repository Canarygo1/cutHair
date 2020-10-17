import 'package:cuthair/model/Place.dart';
import 'package:cuthair/model/appointment.dart';
import 'package:cuthair/model/appointment_completed.dart';
import 'package:cuthair/model/business_type.dart';
import 'package:cuthair/model/employee.dart';
import 'package:cuthair/model/image_business.dart';
import 'package:cuthair/model/service.dart';
import 'package:cuthair/model/business.dart';
import 'package:cuthair/model/user.dart';
import 'package:http/http.dart';

abstract class RemoteRepository {

  Future<String> createUserAuth(String email, password);

  Future<Response> createUserData(Map values, String userId);

  Future<Response> loginUser(String email, String password);

  Future<User> getUser(String id, String accessToken);

  Future<String> generateNewToken(String refreshToken);

  Future<List<BusinessType>> getBusinessTypes();

  Future<BusinessType> getBusinessTypeById(String accessToken, String id);

  Future<List<Business>> getAllBusiness();

  Future<Business> getBusinessById(String accessToken, String id);

  Future<List<Service>> getAllServices(String businessId, String accessToken);

  Future<Service> getServiceById(String accessToken, String id, String businessId);

  Future<List<Employee>> getAllEmployes(String businessId, String accessToken);

  Future<Employee> getEmployeeById(String accessToken, String id);

  Future<List<String>> getDisponibility(String accessToken, String employeeId, String typeBusiness, String date, String duration);

  Future<List<ImageBusiness>> getAllImages(Business business, String accessToken);

  Future<bool> insertAppointment(
      Appointment appointment, String accessToken, var params);

  Future<bool> insertAppointmentPlace(
      Appointment appointment, String accessToken, var params);

  Future<List<Appointment>> getUserAppointments(
      String id, String accessToken);

  Future<bool> removeAppointment(AppointmentCompleted appointment, String accessToken);

  Future<bool> updateDataUser(User user, String accessToken);

  Future<String> getVersionApp(String software);

  Future<Place> getPlaceById(String accessToken, String placeId);

  Future<List<Place>> getAllPLace(String accessToken, String businessId);

  Future<bool> getUserPenalization(String accessToken, String userId);

  Future<String> resetPassword(String email);

}
