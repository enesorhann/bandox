import 'package:flutter_bloc/flutter_bloc.dart';

class DepAdiCubit extends Cubit<String>{
  DepAdiCubit() : super("");


  void saveDepName(String depAdi) {
    emit(depAdi);
  }

  void deleteDepName() {
    emit("");
  }

}