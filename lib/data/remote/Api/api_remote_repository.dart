abstract class ApiRemoteRepository {
  Future<List<String>> getAvailability(String duration,String hairdresser,String date);
}