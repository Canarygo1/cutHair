import 'package:cuthair/model/appointment.dart';

abstract class ChooseDatePresenter{
  init(Appointment appointment, String date);
}

abstract class ChooseDateView {
  showAvailability(List<String> availability);
  emptyAvailability();
}
