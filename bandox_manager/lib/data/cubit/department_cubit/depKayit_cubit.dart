import 'package:flutter_bloc/flutter_bloc.dart';

import '../../repo/DeptFirebsServ.dart';

class DepKayitCubit extends Cubit<void>{
  DepKayitCubit() : super(0);

  final _dFServ = DeptFirebsServ();

  Future<void> depEkle(String depAdi,String sirket_id) async{
    await _dFServ.depEkle(depAdi,sirket_id);
  }

}