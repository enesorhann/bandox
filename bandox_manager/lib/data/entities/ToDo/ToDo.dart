
class ToDo {
  String jobID;
  String jobHead;
  int state;
  String? dep_id;
  String? baslangicTarihi;
  String? bitisTarihi;
  double? gelir;
  double? gider;
  String? gelirAciklama;
  String? giderAciklama;
  String? jobDesc;
  Map<String,bool>? personIDs;

  ToDo(
      { required this.jobID,
        required this.jobHead,
        required this.state,
        this.dep_id,
        this.baslangicTarihi,
        this.bitisTarihi,
        this.gelir,
        this.gider,
        this.gelirAciklama,
        this.giderAciklama,
        this.jobDesc,
        this.personIDs,
      }
      );

  factory ToDo.fromJson(String job_key, Map<dynamic, dynamic> json) {

    var personIdArrayJson = json["personIDs"] as Map<dynamic,dynamic>? ?? {};
    Map<String,bool> personIDs = personIdArrayJson.map((key,value) => MapEntry(key.toString(), value as bool));

    return ToDo(
        jobID: job_key,
        dep_id: json["dep_id"],
        state: json["state"],
        baslangicTarihi: json["baslangicTarihi"],
        bitisTarihi: json["bitisTarihi"],
        gelir: double.tryParse(json["gelir"]?.toString() ?? "") ?? 0.0,
        gider: double.tryParse(json["gider"]?.toString() ?? "") ?? 0.0,
        gelirAciklama: json["gelirAciklama"],
        giderAciklama: json["giderAciklama"],
        jobDesc: json["jobDesc"],
        jobHead: json["jobHead"],
        personIDs: personIDs,
    );
  }
}
