
class Users {
   String? userID;
   String? userFname;
   String? userLname;
   String? userTCno;
   String? userIP;
   String? phoneNum;
   List<String>? dep_ids;
   String? faceOfUser;
   String? sohbettekiGorsel;
   String? managerDepId;


   Users(
      {this.userID,
      this.userFname,
      this.userLname,
      this.userTCno,
      this.userIP,
      this.phoneNum,
      this.dep_ids,
      this.faceOfUser,
      this.sohbettekiGorsel,
      this.managerDepId});

  factory Users.fromJson(String user_key,Map<dynamic,dynamic> json){

    var jsonArray = json["dep_ids"] as List<dynamic>? ?? [];
    var depIDList = jsonArray.map((jsonArrayNesnesi) => jsonArrayNesnesi.toString()).toList();

    return Users(
        userID: user_key,
        userFname: json["userFname"] as String? ?? "",
        userLname: json["userLname"] as String? ?? "",
        userTCno: json["userTCno"] as String? ?? "",
        userIP: json["userIP"] as String? ?? "",
        phoneNum: json["phoneNum"] as String? ?? "",
        dep_ids: depIDList ?? [],
        faceOfUser: json["faceOfUser"] as String? ?? "",
        sohbettekiGorsel: json["sohbettekiGorsel"] as String? ?? "",
        managerDepId: json["managerDepId"] as String? ?? "",
    );
  }

}
