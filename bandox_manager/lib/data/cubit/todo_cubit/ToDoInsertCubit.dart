import 'package:dep_manager_panel/data/repo/ToDoFirebsServ.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TodoInsertCubit extends Cubit<void> {
  TodoInsertCubit() : super(0);

  final _TodoServ = TodoFirebsServ();

  Future<void> jobInsert(String dep_id, String jobHead, int state,
      {String? baslangicTarihi,
      String? bitisTarihi,
      double? gelir,
      double? gider,
      String? gelirAciklama,
      String? giderAciklama,
      String? jobDesc,
      Map<String, bool>? personIDs
      }) async {
    var jobID = "${dep_id}_${DateTime.now().millisecondsSinceEpoch}";

    await _TodoServ.jobInsert(
        jobID,
        dep_id,
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
