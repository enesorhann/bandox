import 'package:firebase_auth/firebase_auth.dart';

class Authservice {

  final auth = FirebaseAuth.instance;

  Future<void> createUser({required String email})async {
    try{

      await auth.createUserWithEmailAndPassword(
          email: email,
          password: "test123");
      await sendPasswordResetEmail(email);
      print("Kullanici basariyla olusturuldu ve sifirlama baglantisi gonderildi");
    } catch(e){
      print("Kullanici olusturulurken bir hata olustu: $e");
    }
  }

  Future<void> sendPasswordResetEmail(String email) async{
    try{
      await auth.sendPasswordResetEmail(email: email);
    }catch(e){
      print("Sifirlama baglantisi gonderilirken bir hata olustu: $e");
    }
  }
}