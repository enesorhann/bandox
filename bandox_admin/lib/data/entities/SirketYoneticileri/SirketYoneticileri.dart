class Yoneticiler {
  late String sirket_id;
  late String sirket_ad;
  late String yonetici_fName;
  late String yonetici_lName;
  late String yonetici_mail;

  Yoneticiler(
      {
        required this.sirket_id,
        required this.sirket_ad,
        required this.yonetici_fName,
        required this.yonetici_lName,
        required this.yonetici_mail
      });

  factory Yoneticiler.fromJson(String sirket_key,Map<dynamic,dynamic> json){

    return Yoneticiler(
        sirket_id: sirket_key,
        sirket_ad: json["sirket_ad"] as String,
        yonetici_fName: json["yonetici_fName"] as String,
        yonetici_lName: json["yonetici_lName"] as String,
        yonetici_mail: json["yonetici_mail"] as String,
    );
  }

}
