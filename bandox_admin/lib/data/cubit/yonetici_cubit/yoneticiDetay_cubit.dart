import 'package:flutter_bloc/flutter_bloc.dart';

import '../../repo/YoneticiFirebsServ.dart';

class YoneticiDetayCubit extends Cubit<void>{
  YoneticiDetayCubit() : super(0);

  var yFServ = YoneticiFirebsServ();


  Future<void> managerGuncelle(
      String sirket_id,
      String sirket_ad,
      String yonetici_fName,
      String yonetici_lName,
      String yonetici_mail,
      ) async{
    await yFServ.managerGuncelle(sirket_id, sirket_ad, yonetici_fName, yonetici_lName, yonetici_mail);
  }
}

