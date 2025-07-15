import 'dart:io';

import 'package:dep_manager_panel/data/cubit/department_cubit/DepartmentCustomCubits/GetManagerCubit.dart';
import 'package:dep_manager_panel/data/cubit/department_cubit/depList_cubit.dart';
import 'package:dep_manager_panel/data/cubit/users_cubit/usersKayit_cubit.dart';
import 'package:dep_manager_panel/data/entities/Departments/Departments.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

class UserKayitSayfasi extends StatefulWidget {
  Departments department;

  UserKayitSayfasi(this.department, {super.key});

  @override
  State<UserKayitSayfasi> createState() => _KayitSayfasiState();
}

class _KayitSayfasiState extends State<UserKayitSayfasi> {
  var fNameController = TextEditingController();
  var lNameController = TextEditingController();
  var tcNoController = TextEditingController();
  var phoneNumberController = TextEditingController();
  var departmentNameController = TextEditingController();
  var sirket_yoneticisiMi = false;
  var dep_yoneticisiMi = false;
  var managerDepId = "";
  String? imageUrl = "No image URL available";
  File? selectedImage;
  var strgRef = FirebaseStorage.instance.ref();
  UploadTask? uploadTask;
  var depList = <Departments>[];
  var departmanIDs = <String>[];
  late Departments secilenDep;
  var checkBoxState = <String, bool>{};
  final _textStyle = GoogleFonts.poppins(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );

  Future<void> getAccessGallery() async {
    try {
      var returnedImg =
          await ImagePicker().pickImage(source: ImageSource.gallery);
      if (returnedImg != null) {
        setState(() {
          selectedImage = File(returnedImg.path);
        });
        await uploadImageToFirebase(File(returnedImg.path));
      } else
        return;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.red,
          content: Text("Failed to Pick Image : $e")));
    }
  }

  Future<void> getAccessCamera() async {
    try {
      var returnedImg =
          await ImagePicker().pickImage(source: ImageSource.camera);
      if (returnedImg != null) {
        setState(() {
          selectedImage = File(returnedImg.path);
        });
        await uploadImageToFirebase(File(returnedImg.path));
      } else
        return;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.red,
          content: Text("Failed to Pick Image : $e")));
    }
  }

  Future<void> uploadImageToFirebase(File img) async {
    try {
      var fileExtension = img.path.split('.').last;
      if (fileExtension.isEmpty) fileExtension = 'png';

      var ref = strgRef.child(
          "faces/${DateTime.now().microsecondsSinceEpoch}.$fileExtension");
      uploadTask = ref.putFile(img);
      setState(() {});

      var snapshot = await uploadTask!.whenComplete(() {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
            content: Text("Upload is successfully"),
          ),
        );
      });

      setState(() {
        uploadTask = null;
      });

      var url = await snapshot.ref.getDownloadURL();
      debugPrint("Download URL: $url");
      setState(() {
        imageUrl = url;
      });
    } catch (e) {
      debugPrint("Error uploading image: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text("Failed to Upload Image : $e"),
        ),
      );
    }
  }

  buildProgres() {
    return StreamBuilder(
        stream: uploadTask?.snapshotEvents,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var data = snapshot.data!;
            double progress = data.bytesTransferred / data.totalBytes;
            return Stack(
              alignment: Alignment.center,
              children: [
                CircularProgressIndicator(
                  value: progress,
                  color: Colors.green,
                  backgroundColor: Colors.blueGrey,
                ),
                Text("% ${(progress * 100).roundToDouble()}")
              ],
            );
          } else {
            return const SizedBox.shrink();
          }
        });
  }

  @override
  void initState() {
    super.initState();
    var sirketID = context.read<GetManagerCubit>().state!.sirket_id;
    var depListCubit = context.read<DepListCubit>();
    depListCubit.sirkettekiDepartmanlar(sirketID);
    depList = depListCubit.state;
    secilenDep = widget.department;
    departmanIDs.add(secilenDep.dep_id);
    checkBoxState[widget.department.dep_id] = true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.close)),
        actions: [
          IconButton(
              tooltip: "Save",
              onPressed: () {
                context.read<UserKayitCubit>().userEkle(
                    imageUrl!,
                    fNameController.text,
                    lNameController.text,
                    tcNoController.text,
                    phoneNumberController.text,
                    managerDepId,
                    departmanIDs);

                Navigator.pop(context);
              },
              icon: const Icon(Icons.save)),
        ],
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                uploadTask != null
                    ? buildProgres()
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              getAccessCamera();
                            },
                            child: const Text("Kamerayi Ac"),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              getAccessGallery();
                            },
                            child: const Text("Galeriyi Ac"),
                          ),
                        ],
                      ),

                // URL'yi görsel olarak ekrana yazdırın
                const SizedBox(
                  height: 50,
                ),
                SizedBox(
                  width: 100,
                  child: ClipOval(
                    child: Image.network(
                      imageUrl!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(
                          Icons.error,
                          color: Colors.red,
                          size: 50,
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextField(
                  controller: fNameController,
                  decoration: const InputDecoration(
                    label: Text(
                      "Person First Name",
                    ),
                  ),
                ),
                TextField(
                  controller: lNameController,
                  decoration: const InputDecoration(
                    label: Text(
                      "Person Last Name",
                    ),
                  ),
                ),
                TextField(
                  controller: tcNoController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    label: Text(
                      "T.C. No",
                    ),
                  ),
                ),
                TextField(
                  controller: phoneNumberController,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(
                    label: Text(
                      "Phone Number",
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    Checkbox(
                      value: dep_yoneticisiMi,
                      onChanged: (bool? gelenDeger) {
                        if (gelenDeger != null) {
                          setState(() {
                            dep_yoneticisiMi = gelenDeger;
                            if (dep_yoneticisiMi) {
                              managerDepId = widget.department.dep_id;
                            } else {
                              managerDepId = "";
                            }
                          });
                        }
                      },
                      activeColor: Colors.green,
                      side: const BorderSide(
                          color: Colors.black,
                          width: 2.0,
                          strokeAlign: 2.0,
                          style: BorderStyle.solid),
                    ),
                     Text(
                      "Departman Yoneticisi mi?",
                      style: Theme.of(context).textTheme.bodyLarge
                    ),
                  ],
                ),
                const SizedBox(
                  height: 50,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      alignment: Alignment.center,
                      color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.5),
                      child: DropdownButton<Departments>(
                          dropdownColor: Theme.of(context).colorScheme.primary,
                          focusColor: Theme.of(context).colorScheme.primary,
                          iconDisabledColor: Colors.white,
                          iconEnabledColor: Colors.white,
                          alignment: Alignment.center,
                          itemHeight: 70,
                          borderRadius: BorderRadius.circular(20),
                          style: Theme.of(context).textTheme.titleLarge,
                          icon: const Icon(
                            Icons.expand_circle_down_outlined,
                            size: 30,
                          ),
                          iconSize: 40,
                          elevation: 50,
                          value: secilenDep,
                          items: depList.map<DropdownMenuItem<Departments>>(
                              (Departments dep) {
                            return DropdownMenuItem<Departments>(
                                alignment: Alignment.centerLeft,
                                value: dep,
                                child: StatefulBuilder(
                                  builder: (context, setState) {
                                    return Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          dep.dep_adi,
                                          style: _textStyle
                                        ),
                                        Checkbox(
                                            side: const BorderSide(
                                                color: Colors.white,
                                                width: 2.0),
                                            activeColor: Colors.green,
                                            value: checkBoxState[dep.dep_id] ??
                                                false,
                                            onChanged: (bool? newValue) {
                                              if (newValue != null) {
                                                setState(() {
                                                  checkBoxState[dep.dep_id] =
                                                      newValue;
                                                  if (newValue) {
                                                    if (!departmanIDs
                                                        .contains(dep.dep_id)) {
                                                      departmanIDs
                                                          .add(dep.dep_id);
                                                    }
                                                  } else {
                                                    departmanIDs
                                                        .remove(dep.dep_id);
                                                  }
                                                });
                                              }
                                            }),
                                      ],
                                    );
                                  },
                                ));
                          }).toList(),
                          onChanged: (newValue) {
                            if (newValue != null) {
                              setState(() {
                                secilenDep = newValue;
                                if (checkBoxState[secilenDep.dep_id] != true) {
                                  checkBoxState[secilenDep.dep_id] = true;
                                  if (!departmanIDs
                                      .contains(secilenDep.dep_id)) {
                                    departmanIDs.add(secilenDep.dep_id);
                                  }
                                } else {
                                  checkBoxState[secilenDep.dep_id] = false;
                                  if (departmanIDs
                                      .contains(secilenDep.dep_id)) {
                                    departmanIDs.remove(secilenDep.dep_id);
                                  }
                                }
                              });
                            }
                          }),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
