import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class StorageService{


   final _storageRef = FirebaseStorage.instance.ref();
   final _usersRef = FirebaseFirestore.instance.collection("Users");


  Future<void> deleteImage(String uRL) async{
    String path = extractPathFromUrl(uRL);
    await _storageRef.child(path).delete();
  }
  String extractPathFromUrl(String uRL) {
    var uri = Uri.parse(uRL);
    String encodedComponent = uri.pathSegments.last;
    return Uri.decodeComponent(encodedComponent);
  }

   Future<String> uploadImage(XFile imageFile) async {
     try {
       String fileName = DateTime.now().millisecondsSinceEpoch.toString();
       Reference ref = _storageRef.child('faces/$fileName');
       UploadTask uploadTask = ref.putFile(File(imageFile.path));

       TaskSnapshot snapshot = await uploadTask;
       String downloadUrl = await snapshot.ref.getDownloadURL();
       return downloadUrl;
     } catch (e) {
       debugPrint("Error while uploading image: $e");
       return "";
     }
   }


   Future<void> updateImage(XFile? photo, String userId) async {
     try {
       if (photo == null) {
         throw Exception("Fotoğraf seçilmedi.");
       }

       var file = File(photo.path);
       var newImagePath = "faces/${DateTime.now().millisecondsSinceEpoch}.png";
       var newImageRef = _storageRef.child(newImagePath);

       print('Resim Firebase Storage\'a yükleniyor...');
       await newImageRef.putFile(file);
       print('Resim yüklendi.');

       var downloadUrl = await newImageRef.getDownloadURL();
       print('İndirme URL\'si alındı: $downloadUrl');

       print('Firestore güncelleniyor...');
       await _usersRef.doc(userId).update({"faceOfUser": downloadUrl});
       print('Firestore güncellemesi başarılı.');
     } catch (e) {
       print('Hata oluştu: $e');
     }
   }



}

