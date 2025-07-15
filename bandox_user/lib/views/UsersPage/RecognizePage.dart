import 'dart:io';

import 'package:dep_manager_panel/data/entities/Departments/Departments.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dep_manager_panel/data/cubit/users_cubit/usersList_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_panel/data/cubit/AuthCubit/AuthCubit.dart';
import 'package:user_panel/views/UsersPage/Messaging/MessagingPage.dart';

class Recognizepage extends StatefulWidget {
  final Departments department;


  Recognizepage(this.department, {super.key});

  @override
  State<Recognizepage> createState() => _RecognizepageState();
}

class _RecognizepageState extends State<Recognizepage>
    with TickerProviderStateMixin {
  File? selectedFile;
  double uploadProgress = 0.0;
  late AnimationController animationController;
  late Animation<double> anime1;
  late Animation<double> anime2;
  bool knownFace = false;

  @override
  void initState() {
    super.initState();

    animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 2000));
    anime1 = Tween(begin: 0.0, end: 1.0).animate(animationController)
      ..addListener(() {
        setState(() {});
      });
    anime2 = Tween(begin: 100.0, end: 200.0).animate(animationController)
      ..addListener(() {
        setState(() {});
      });
  }

  Future<File> compressImage(File originalImage) async {
    var bytes = await File(originalImage.path).readAsBytesSync();
    print("Original file size: ${bytes.length}");
    var compressBytes =
    await FlutterImageCompress.compressWithList(bytes, quality: 30);
    print("Compressed file size: ${compressBytes.length}");
    var compressedFile =
    await File(originalImage.path).writeAsBytes(compressBytes);
    return compressedFile;
  }

  Future<void> getAccessCamera() async {
    try {
      var pickedImage =
      await ImagePicker().pickImage(source: ImageSource.camera
      );
      if (pickedImage != null) {
        setState(() {
          selectedFile = File(pickedImage.path);
        });
        var compressFile = await compressImage(selectedFile!);
        await faceRecognition(compressFile);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text("Failed to Pick Image: $e"),
        ),
      );
    }
  }

  Future<void> faceRecognition(File imageFile) async {
    final usersCubit = context.read<UsersListCubit>();
    await usersCubit.birKezDepartmandakiKullanicilar(widget.department.dep_id);

    var userList = usersCubit.state;
    if (userList.isEmpty) {
      showSnackBar("No users found in the department.");
      return;
    }

    final currentUserID = context
        .read<AuthCubit>()
        .state;

    for (var user in userList) {
      if (user.userID == currentUserID) {
        try {
          var dio = Dio();
          dio.options.connectTimeout = const Duration(seconds: 60); // 30 saniye
          dio.options.receiveTimeout = const Duration(seconds: 60); // 30 saniye
          // 5 saniye
          String url =
              "https://myfacerecservice-555554166483.us-central1.run.app/recognize";

          FormData formData = FormData.fromMap({
            'strg_url': user.faceOfUser,
            // Firebase Storage URL'sini gönderiyoruz
            'image': await MultipartFile.fromFile(imageFile.path,
                filename: 'captured_image.jpg'),
          });

          var response = await dio.post(
            url,
            data: formData,
            onSendProgress: (count, total) {
              setState(() {
                uploadProgress = 0.50;
              });
            },
          );

          setState(() {
            uploadProgress = 0.75;
          });

          if (response.statusCode == 200) {
            setState(() {
              uploadProgress = 1.00;
            });
            final result = response.data;
            if (result['success'] == true && result['detected'] == true) {
              showSnackBar("Yüz tanındı");
              setState(() {
                knownFace = true;
              });
              animationController.forward();
              animationController.addStatusListener((status) {
                if (status == AnimationStatus.dismissed) {
                  animationController.forward();
                } else if (status == AnimationStatus.completed) {
                  animationController.dispose();
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          Messagingpage(widget.department, user.userID!),
                    ),
                  );
                }
              });
            } else if (result['success'] == false &&
                result['detected'] == false) {
              showSnackBar("Tanınmayan yüz. Lütfen tekrar deneyin.");
              setState(() {
                knownFace = false;
              });
              animationController.forward();
              animationController.addStatusListener((status) {
                if (status == AnimationStatus.completed) {
                  animationController.reset();
                }
              });
            }
          } else {
            showSnackBar("Sunucu hatası: ${response.statusCode}");
            setState(() {
              knownFace = false;
            });
            animationController.forward();
            animationController.addStatusListener((status) {
              if (status == AnimationStatus.completed) {
                animationController.reset();
              }
            });
          }
          setState(() {
            uploadProgress = 0.0;
          });
        } on DioException catch (dioError) {
          if (dioError.type == DioExceptionType.connectionTimeout ||
              dioError.type == DioExceptionType.receiveTimeout) {
            showSnackBar(
                "Bağlantı zaman aşımına uğradı. Lütfen internet bağlantınızı kontrol edin.");
          } else {
            print("Hata oluştu: ${dioError.message}");
            setState(() {
              knownFace = false;
            });
            animationController.forward();
            animationController.addStatusListener((status) {
              if (status == AnimationStatus.completed) {
                animationController.reset();
              }
            });
          }
          setState(() {
            uploadProgress = 0.0;
          });
        }
        break;
      }
    }
  }

  buildProgress(double progress) {
    return SizedBox(
      width: 100,
      height: 100,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CircularProgressIndicator(
            strokeAlign: BorderSide.strokeAlignCenter,
            strokeWidth: 10,
            strokeCap: StrokeCap.square,
            color: Theme.of(context).colorScheme.primary,
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            value: progress,
          ),
          Text(
            "% ${(100 * progress).roundToDouble()} ",
            style: Theme.of(context).textTheme.titleMedium,
          )
        ],
      ),
    );
  }

  void showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  Widget Button(onPressed(), String text) {
    return SizedBox(
      child: ElevatedButton(
          onPressed: onPressed,
          child: Text(
            text
          )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(

      ),
      body: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () async {
                    await getAccessCamera();
                  },
                  child: selectedFile != null
                      ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      width: 300,
                      height: 300,
                      child: CircleAvatar(
                        backgroundColor: Colors.white,
                        child: ClipOval(
                          child: Image.file(
                            selectedFile!,
                            width: 300,
                            height: 300,
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                    ),
                  )
                      : Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      width: 300,
                      height: 300,
                      child: CircleAvatar(
                        backgroundColor: Colors.white,
                        child: ClipOval(
                          child: Image.asset(
                            "images/images.png",
                            width: 300,
                            height: 300,
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                uploadProgress > 0.0
                    ? buildProgress(uploadProgress)
                    : const SizedBox.shrink(),
                Text(
                  "Sisteme baglanmak için FaceID ile giris yapınız",
                  style: Theme.of(context).textTheme.bodyMedium
                ),
                Button(() async {
                  setState(() {
                    selectedFile = null;
                  });
                },"Delete your face"),
              ],
            ),
            Opacity(
              opacity: anime1.value,
              child: Icon(
                knownFace ? Icons.check_circle_sharp : Icons.cancel_sharp,
                color: knownFace ? Colors.green : Colors.red,
                fill: 1.0,
                size: anime2.value,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
