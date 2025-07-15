import 'package:flutter_bloc/flutter_bloc.dart';


class EmailCubit extends Cubit<String>{
  EmailCubit() : super("");

  void emailKayit(String yonetici_mail){
    emit(yonetici_mail);
  }
  void emailSil(){
    emit("");
  }
}