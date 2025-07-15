import 'package:flutter_bloc/flutter_bloc.dart';

class MailKayitCubit extends Cubit<String>{
  MailKayitCubit() : super("");


  Future<void> mailOlustur(
      String sirket_ad,
      String yonetici_fName,
      String yonetici_lName,
      ) async{
    var yonetici_mail = "$yonetici_fName$yonetici_lName@$sirket_ad.com";
    emit(yonetici_mail);
  }

}