import 'package:dep_manager_panel/data/repo/StorageService.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

class StorageCubit extends Cubit<List<String?>>{
  StorageCubit() : super(<String>[]);



  final _firebaseStorage = FirebaseStorage.instance;
  final _storageServ = StorageService();

  Future<void> fetchImages(String dep_id) async{
    var listResult = await _firebaseStorage.ref("faces/").listAll();
    var uRLs = await Future.wait(listResult.items.map((ref) => ref.getDownloadURL()));
    emit(uRLs);
  }

  Future<void> deleteImage(String uRL) async{
    await _storageServ.deleteImage(uRL);
  }

  Future<String> uploadImage(XFile photo) async{
    var url = await _storageServ.uploadImage(photo);
    return url;
  }

  Future<void> updateImage(XFile? photo, String userId) async {
    await _storageServ.updateImage(photo, userId);
  }

}