import 'package:dep_manager_panel/data/repo/ToDoFirebsServ.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TodoUpdateCubit extends Cubit<void> {
  TodoUpdateCubit() : super(0);

  final _TodoServ = TodoFirebsServ();

  Future<void> jobUpdate(
    String jobID,
    String jobHead,
    int state, {
    String? baslangicTarihi,
    String? bitisTarihi,
    double? gelir,
    double? gider,
    String? gelirAciklama,
    String? giderAciklama,
    String? jobDesc,
    Map<String, bool>? personIDs
  }) async {
    await _TodoServ.jobUpdate(
        jobID,
        jobHead,
        state,
        baslangicTarihi,
        bitisTarihi,
        gelir,
        gider,
        gelirAciklama,
        giderAciklama,
        jobDesc,
        personIDs
    );
  }
}
