import 'dart:io';
import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:user_panel/data/services/ChatService.dart';
import 'package:user_panel/theme/AppColors.dart';
import 'package:user_panel/theme/ContainerToScaffold.dart';
import 'package:user_panel/views/UsersPage/Messaging/BubbleChatPage.dart';
import '../../../data/entities/Users/Users.dart';

class ChatPage extends StatefulWidget {
  final Users user;
  final String senderUserId;

  const ChatPage({super.key, required this.user, required this.senderUserId});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> with TickerProviderStateMixin {
  final chatService = ChatService();
  var messageController = TextEditingController();
  var scrollController = ScrollController();
  late AnimationController animeController;
  late Animation<double> sizeAnime;
  late Animation<double> opacityAnime;
  late Animation<Alignment> alignAnime;
  File? _selectedFile;
  File? _selectedImage;
  bool _loadingFile = false;
  bool _loadingImage = false;
  bool _emoShow = false;
  var strgRef = FirebaseStorage.instance.ref();
  var circularProgress = const CircularProgressIndicator(
    strokeAlign: BorderSide.strokeAlignCenter,
    strokeWidth: 10,
    strokeCap: StrokeCap.square,
    color: AppColors.primary,
    backgroundColor: AppColors.background,
  );
  final GlobalKey _avatarKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    animeController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));
    sizeAnime = Tween(begin: 50.0, end: 300.0).animate(
        CurvedAnimation(parent: animeController, curve: Curves.easeInOut));
    opacityAnime = Tween(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: animeController, curve: Curves.easeInOut));
    alignAnime = AlignmentTween(begin: Alignment.topLeft, end: Alignment.topCenter)
        .animate(
            CurvedAnimation(parent: animeController, curve: Curves.easeInOut));
  }

  void sendMessage() async {
    if (messageController.text.isNotEmpty) {
      await chatService.sendMessage(
          widget.user.userID!, widget.senderUserId, messageController.text);
    }
    messageController.clear();
    scrollController.animateTo(0.0,
        duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
    FocusScope.of(context).unfocus();
  }

  Widget buildMessageList() {
    return StreamBuilder(
      stream: chatService.getMessages(widget.user.userID!, widget.senderUserId),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text("Message isn't loadable!");
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [Text("Loading.."), CircularProgressIndicator()],
            ),
          );
        }
        return Expanded(
          child: ListView(
            controller: scrollController,
              reverse: true,
              children: snapshot.data!.docs
                  .map((doc) => buildMessageItem(doc))
                  .toList()),
        );
      },
    );
  }

  Widget buildMessageItem(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data() as Map<String, dynamic>;

    return Container(
      alignment: (data["senderId"] == widget.senderUserId)
          ? Alignment.centerRight
          : Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: (data["senderId"] == widget.senderUserId)
              ? MainAxisAlignment.end
              : MainAxisAlignment.start,
          crossAxisAlignment: (data["senderId"] == widget.senderUserId)
              ? CrossAxisAlignment.end
              : CrossAxisAlignment.start,
          children: [Bubblechatpage(data, widget.senderUserId)],
        ),
      ),
    );
  }

  Widget _buildOverlayAnimation(Offset startOffset, Size startSize) {
    final screenSize = MediaQuery.of(context).size;

    return AnimatedBuilder(
      animation: animeController,
      builder: (context, child) {
        double t = animeController.value;
        double size = lerpDouble(startSize.width, screenSize.width * 0.9, t)!;
        double dx = lerpDouble(startOffset.dx, (screenSize.width - size) / 2, t)!;
        double dy = lerpDouble(startOffset.dy, (screenSize.height - size) / 2, t)!;

        return Stack(
          children: [
            Opacity(
              opacity: t * 0.5,
              child: Container(
                color: Colors.black,
              ),
            ),
            Positioned(
              left: dx,
              top: dy,
              child: GestureDetector(
                onTap: () => animeController.reverse(),
                child: Container(
                  width: size,
                  height: size,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: widget.user.faceOfUser != null
                          ? NetworkImage(widget.user.faceOfUser!)
                          : const AssetImage("images/images.png") as ImageProvider,
                      fit: BoxFit.cover,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: t * 0.5),
                        blurRadius: 30,
                        spreadRadius: 5,
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _startProfileAnimation() {
    RenderBox renderBox = _avatarKey.currentContext!.findRenderObject() as RenderBox;
    Offset startOffset = renderBox.localToGlobal(Offset.zero);
    Size startSize = renderBox.size;

    OverlayEntry overlayEntry = OverlayEntry(
      builder: (context) => _buildOverlayAnimation(startOffset, startSize),
    );

    Overlay.of(context).insert(overlayEntry);

    animeController.forward();

    animeController.addStatusListener((status) {
      if (status == AnimationStatus.dismissed) {
        overlayEntry.remove();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var url = widget.user.faceOfUser;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            IconButton(
                padding: const EdgeInsets.only(left: 8),
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(
                  Icons.arrow_back_ios,
                ))
          ],
        ),
        title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              InkWell(
                splashColor: Colors.grey,
                key: _avatarKey,
                onTap: _startProfileAnimation,
                child: Container(
                  width: 50,
                  height: 50,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle
                  ),
                  child: url != null
                      ? ClipOval(
                          child: Image.network(
                            url,
                            fit: BoxFit.fill,
                            width: 50,
                            height: 50,
                          ),
                        )
                      : ClipOval(
                          child: Image.asset(
                            "images/images.png",
                            width: 50,
                            height: 50,
                            fit: BoxFit.fill,
                          ),
                        ),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Text("${widget.user.userFname} ${widget.user.userLname}",
                  style: Theme.of(context).textTheme.titleLarge),
            ]),
      ),
      body: Stack(
        children: [
          Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            buildMessageList(),
            SafeArea(
              bottom: true,
              child: Padding(
                padding: const EdgeInsets.only(left: 12,right: 12,top: 4,bottom: 15),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Theme.of(context).scaffoldBackgroundColor,
                          boxShadow: [
                            BoxShadow(
                            color: Colors.black.withValues(alpha: 0.1),
                            blurRadius: 5,
                            offset: const Offset(0, 3)
                          ),
                          ],
                        ),
                        margin: const EdgeInsets.only(right: 8),
                        child: TextFormField(
                          onTap: () {
                            if (_emoShow) {
                              setState(() {
                                _emoShow = false;
                              });
                            }
                          },
                          controller: messageController,
                          scrollController: scrollController,
                          textAlignVertical: TextAlignVertical.center,
                          maxLines: null,
                          minLines: 1,
                          keyboardType: TextInputType.multiline,
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "Message",
                              contentPadding: const EdgeInsets.fromLTRB(20,10,20,10),
                              prefixIcon: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                      onPressed: () {
                                        setState(() {
                                          _emoShow = !_emoShow;
                                        });
                                        if (_emoShow) {
                                          // to close keyboard
                                          FocusScope.of(context).unfocus();
                                        } else {
                                          FocusScope.of(context).requestFocus();
                                        }
                                      },
                                      icon: Icon(
                                        _emoShow
                                            ? Icons.keyboard_alt_outlined
                                            : Icons.emoji_emotions_rounded,
                                      ))
                                ],
                              ),
                              suffixIcon: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  _loadingFile == false
                                      ? IconButton(
                                          onPressed: () {
                                            selectFile();
                                          },
                                          icon: const Icon(Icons.attach_file))
                                      : Center(child: circularProgress),
                                  _loadingImage == false
                                      ? IconButton(
                                          onPressed: () {
                                            selectImage();
                                          },
                                          icon: const Icon(Icons.camera_alt))
                                      : Center(child: circularProgress),
                                ],
                              )),
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Theme.of(context).colorScheme.primary
                      ),
                      child: IconButton(
                          onPressed: sendMessage,
                          icon: const Icon(
                            Icons.send,
                            color: Colors.white,
                          )),
                    )
                  ],
                ),
              ),
            ),
            Offstage(
              offstage: !_emoShow,
              child: EmojiPicker(
                textEditingController: messageController,
                scrollController: scrollController,
                config: const Config(height: 286),
              ),
            ),
          ],
        ),
        ],
      ),
    );
  }

  void selectFile() async {
    try {
      FilePickerResult? filePickerResult =
          await FilePicker.platform.pickFiles(type: FileType.any);
      if (filePickerResult != null) {
        var fileName = filePickerResult.files.single.name;
        setState(() {
          _selectedFile = File(filePickerResult.files.single.path!);
        });
        uploadFile(_selectedFile!, fileName);
      } else
        return;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text("Failed to pick file! ${e.toString()}"),
        ),
      );
    }
  }

  void selectImage() async {
    try {
      var returnedImg =
          await ImagePicker().pickImage(source: ImageSource.gallery);
      if (returnedImg != null) {
        setState(() {
          _selectedImage = File(returnedImg.path);
        });
        uploadImage(_selectedImage!);
      } else
        return;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text("Failed to pick image! ${e.toString()}"),
        ),
      );
    }
  }

  void uploadFile(File selectedFile, String fileName) async {
    setState(() {
      _loadingFile = true;
    });
    var fileExtension = selectedFile.path.split(".").lastOrNull;
    if (fileExtension != null && fileExtension.isNotEmpty) {
      var fileRef = strgRef.child("chatFiles/$fileName");
      UploadTask uploadTask = fileRef.putFile(selectedFile);
      uploadTask.whenComplete(() async {
        var url = await uploadTask.snapshot.ref.getDownloadURL();
        setState(() {
          messageController.text = url;
        });
        sendMessage();
      });
    }
    setState(() {
      _loadingFile = false;
    });
  }

  void uploadImage(File selectedImage) async {
    setState(() {
      _loadingImage = true;
    });

    var fileRef = strgRef
        .child("chatImages/${DateTime.now().millisecondsSinceEpoch}.jpg");
    UploadTask uploadTask = fileRef.putFile(selectedImage);
    uploadTask.whenComplete(() async {
      var url = await uploadTask.snapshot.ref.getDownloadURL();
      setState(() {
        messageController.text = url;
      });
      sendMessage();
    });
    setState(() {
      _loadingImage = false;
    });
  }
}
