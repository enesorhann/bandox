import 'package:admin_paneli/data/entities/SirketYoneticileri/SirketYoneticileri.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GetManagerCubit extends Cubit<Yoneticiler?>{
  GetManagerCubit() : super(null);

  final _managerRef = FirebaseFirestore.instance.collection("Yoneticiler");

  Future<void> yoneticiBul(String yonetici_mail) async {
    late var manager;
    var querySnapshot = await _managerRef.where("yonetici_mail",isEqualTo: yonetici_mail).get();
    try{
      for (var doc in querySnapshot.docs) {
        var sirket_key = doc.id;
        var json = doc.data();
        manager = Yoneticiler.fromJson(sirket_key, json);
      }
      emit(manager);
    } catch(e){
      print(e.toString());
    }

  }

}