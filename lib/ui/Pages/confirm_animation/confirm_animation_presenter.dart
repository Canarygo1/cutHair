import 'package:cuthair/model/appointment.dart';

abstract class ConfirmAnimationPresenter{
  init(Appointment appointment);
}
abstract class ConfirmAnimationView{
  correctInsert();
  incorrectInsert();
}