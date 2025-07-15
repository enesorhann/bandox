import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:user_panel/theme/AppColors.dart';
import 'package:user_panel/views/UsersPage/Messaging/ImageView.dart';

class Bubblechatpage extends StatelessWidget {
  final Map<String, dynamic> data;
  final String senderId;
  TextStyle style = GoogleFonts.roboto(
      // bungeeSpice creepster
      fontSize: 17,
      color: Colors.white,
      fontWeight: FontWeight.normal,
      letterSpacing: 1.2,
      locale: const Locale("TR"),
      textBaseline: TextBaseline.ideographic,
      fontStyle: FontStyle.normal,
      wordSpacing: 1,
      height: 1.3);
  TextStyle timeStyle = GoogleFonts.roboto(
    // bungeeSpice creepster
      fontSize: 13,
      color: Colors.white.withValues(alpha: 0.7),
      fontWeight: FontWeight.normal,
      letterSpacing: 1.2,
      locale: const Locale("TR"),
      textBaseline: TextBaseline.ideographic,
      fontStyle: FontStyle.normal,
      wordSpacing: 1,
      height: 1.3);

  Bubblechatpage(this.data, this.senderId, {super.key});

  String getFileNameFromURL(String url) {
    Uri uri = Uri.parse(url);
    var lastSegment = uri.pathSegments.last;
    var decodedPath = Uri.decodeFull(lastSegment);
    return decodedPath.split("/").last;
  }

  Future<void> openTempFileFromUrl(String url) async {
    try {
      String fileName = Uri.decodeFull(url.split('%2F').last.split('?').first);

      // cache dir actim ve otomatik silinecek
      final tempDir = await getTemporaryDirectory();
      final filePath = "${tempDir.path}/$fileName";
      final file = File(filePath);

      if (await file.exists()) {
        print("Dosya zaten var(gecici) -> $filePath");
      } else {
        print("Dosya indiriliyor.. -> $filePath");
        await Dio().download(url, filePath);
      }

      final result = await OpenFilex.open(filePath);
      print("Result Message -> ${result.message}");
    } catch (e) {
      print('HATA - Dosya açılırken: $e');
    }
  }

  void openFile(String filePath) async {
    try {
      Uri uri = Uri.parse("https://ktun.edu.tr/");
      var canLaunch = await canLaunchUrl(uri);
      if (canLaunch) {
        final launched = await launchUrl(uri, mode: LaunchMode.inAppWebView);

        if (!launched) {
          print("launchUrl basarisiz oldu");
        }
      } else {
        print("Url acilabilir degil $uri");
      }
    } catch (e) {
      print("Open file hatasi -> $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: (data["senderId"] == senderId)
            ? AppColors.primary
            : Colors.grey.shade800,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Builder(builder: (context) {
        String message = data["message"];
        bool isImage = message.contains(".jpg") ||
            message.contains(".jpeg") ||
            message.contains(".png");
        bool isFile = message.contains(".pdf") ||
            message.contains(".docx") ||
            message.contains(".xlsx") ||
            message.contains(".mp4") ||
            message.contains(".mp3") ||
            message.contains(".pptx");

        var sendedTime = Positioned(
          bottom: 0,
          right: 0,
          child: SizedBox(
            child: Text(
              data["timeStamp"]
                  .toDate()
                  .toString()
                  .split(" ")[1]
                  .substring(0, 5),
              style: timeStyle,
            ),
          ),
        );


        if (isImage) {
          return InkWell(
            onTap: () {
              //gorseli tam ekranda ac
              Navigator.push(context, MaterialPageRoute(
                builder: (context) => Imageview(url: message),
              ),
              );
            },
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 20.0),
                  child: Hero(
                    tag: message,
                    child: Image.network(
                      message,
                      width: 200,
                      errorBuilder: (context, error, stackTrace) {
                        return SizedBox(
                          width: 50,
                          height: 50,
                          child: Icon(
                            Icons.file_download_off_outlined,
                            color: Colors.red.shade900,
                          ),
                        );
                      },
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return SizedBox(
                          width: 100,
                          height: 100,
                          child: Center(
                            child: CircularProgressIndicator(
                              color: Theme.of(context).primaryColor.withValues(alpha: 2.2),
                              value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded/loadingProgress.expectedTotalBytes!
                                  : null
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                sendedTime
              ],
            ),
          );
        } else if (isFile) {
          return Material(
            color: Colors.transparent,
            child: InkWell(
              // dosyayi ac
              onTap: () => openTempFileFromUrl(message),
              child: Container(
                width: 250,
                color: Colors.black.withValues(alpha: 0.2),
                child: Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Image.asset(
                            "images/fileicon.png",
                            width: 100,
                            height: 100,
                          ),
                          const SizedBox(height: 8,),
                          Expanded(
                            child: Text(getFileNameFromURL(message),
                                overflow: TextOverflow.visible,
                                locale: const Locale("TR"),
                                strutStyle: const StrutStyle(fontSize: 20, height: 1.1),
                                textDirection: TextDirection.ltr,
                                textWidthBasis: TextWidthBasis.longestLine,
                                textAlign: TextAlign.start,
                                softWrap: true,
                                style: style),
                          ),
                        ],
                      ),
                    ),
                    sendedTime,
                  ],
                ),
              ),
            ),
          );
        } else {
          return Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: Text(
                    overflow: TextOverflow.visible,
                    locale: const Locale("TR"),
                    strutStyle: const StrutStyle(fontSize: 20, height: 1.1),
                    textDirection: TextDirection.ltr,
                    textWidthBasis: TextWidthBasis.longestLine,
                    textAlign: TextAlign.start,
                    softWrap: true,
                    message,
                    style: style),
              ),
              sendedTime
            ],
          );
        }
      }),
    );
  }
}
