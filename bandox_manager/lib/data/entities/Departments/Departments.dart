class Departments {
  late String dep_id;
  late String dep_adi;
  late String sirket_id;


  Departments({
    required this.dep_id,
    required this.dep_adi,
    required this.sirket_id});

  factory Departments.fromJson(String dep_key,Map<dynamic,dynamic> json){

    return Departments(
        dep_id: dep_key,
        dep_adi: json["dep_adi"] as String,
        sirket_id: json["sirket_id"] as String,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is Departments && other.dep_id==dep_id;
  }
}
