import 'package:dep_manager_panel/data/repo/UserFirebsServ.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class UserKayitCubit extends Cubit<void>{
  UserKayitCubit() : super(0);

  final _uFServ = UserFirebsServ();

  Future<void> userEkle(
      String faceOfUser,
      String userFname,
      String userLname,
      String userTcNo,
      String phoneNumber,
      String managerDepId,
      List<String> dep_ids,
      {String? userIp,}
      ) async{
    await _uFServ.userEkle(
      faceOfUser,
      userFname,
      userLname,
      userTcNo,
      phoneNumber,
      managerDepId,
      dep_ids,
      userIp: userIp,
    );
  }

}