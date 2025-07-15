import 'package:admin_paneli/data/repo/AuthService.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../repo/YoneticiFirebsServ.dart';

class YoneticiKayitCubit extends Cubit<void>{
  YoneticiKayitCubit() : super(0);

  var yFServ = YoneticiFirebsServ();


  Future<void> managerEkle(
      String sirket_ad,
      String yonetici_fName,
      String yonetici_lName,
      String yonetici_mail,
      ) async{
    await yFServ.managerEkle(sirket_ad, yonetici_fName, yonetici_lName,yonetici_mail);
    await Authservice().createUser(email: yonetici_mail);
  }



}
