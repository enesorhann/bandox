import 'package:admin_paneli/data/entities/SirketYoneticileri/SirketYoneticileri.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repo/YoneticiFirebsServ.dart';

class YoneticiListCubit extends Cubit<List<Yoneticiler>>{
  YoneticiListCubit() : super(<Yoneticiler>[]);

  var yFServ = YoneticiFirebsServ();
  var managerRef = FirebaseFirestore.instance.collection("Yoneticiler");


  Future<void> managerListAll() async{
    managerRef.snapshots()
        .listen( (snapshot) {
       var managerList = snapshot.docs.map((doc) => Yoneticiler.fromJson(doc.id,doc.data())).toList();
       emit(managerList);
    });
  }

  Future<void> managerListSearch(String sirket_ad) async{
    var list = <Yoneticiler>[];
    var querySnapshot = await managerRef.where("sirket_ad", isEqualTo: sirket_ad).get();
    try{
      for(var doc in querySnapshot.docs){
        var sirket_key= doc.id;
        var json = doc.data();
        var manager = Yoneticiler.fromJson(sirket_key, json);
        list.add(manager);
      }
      emit(list);
    } on FirebaseException catch(e){
      print(e.toString());
    }
  }

  Future<void> managerDelete(String sirket_id) async{
    await yFServ.managerDelete(sirket_id);
  }



}