abstract class ApiRemoteRepository {
  Future<List<String>> getHairDressingAvailability(String duration,String hairdresser,String date, String businessUid);
  Future<List<String>> getRestaurantAvailability(String duration,String numberPersons,String date, String businessUid);

}