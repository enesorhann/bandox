import 'package:flutter_bloc/flutter_bloc.dart';

import '../../repo/DeptFirebsServ.dart';

class DepDetayCubit extends Cubit<void>{
  DepDetayCubit() : super(0);

  final _dFServ = DeptFirebsServ();

  Future<void> depGuncelle(String depID,String depAdi) async{
    await _dFServ.depGuncelle(depID, depAdi);
  }

}