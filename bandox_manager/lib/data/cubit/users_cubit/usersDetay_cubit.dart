import 'package:dep_manager_panel/data/repo/UserFirebsServ.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class UsersDetayCubit extends Cubit<void>{
  UsersDetayCubit() : super(0);

  final _uFServ = UserFirebsServ();

  Future<void> userGuncelle(
  String userID,
      {String? faceOfUser,
        String? userFname,
        String? userLname,
        String? user_tcNo,
        String? phone_number,
        List<String>? dep_ids,
        String? managerDepId,
        String? user_ip,}
  ) async{
    await _uFServ.userGuncelle(
        userID,
      faceOfUser: faceOfUser,
      userFname: userFname,
      userLname: userLname,
      user_tcNo: user_tcNo,
      phone_number: phone_number,
      dep_ids: dep_ids,
      managerDepId: managerDepId,
      user_ip:user_ip,
    );
  }

}