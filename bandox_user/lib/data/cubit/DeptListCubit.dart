import 'package:dep_manager_panel/data/entities/Departments/Departments.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_panel/data/repo/UsersDaoRepo.dart';

class DeptListCubit extends Cubit<List<Departments>>{
  DeptListCubit() : super([]);

  var usersDaoRepo = UsersDaoRepo();

  // userID ile bulundugu departmanlarin listesini alma
  Future<void> getDepartmentsOfUser(String userID) async{
    var deptList = <Departments>[];
    deptList = await usersDaoRepo.getDepartmentIDsOfUser(userID);
    emit(deptList);
      //deptList.map((e) => e.dep_adi);
    }
  Future<void> kullanicininDepartmanlari(List<String>? depIds) async{
    var deptList = <Departments>[];
    deptList = await usersDaoRepo.kullanicininDepartmanlari(depIds);
    emit(deptList);
  }



}
