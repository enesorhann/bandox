import 'package:dep_manager_panel/data/cubit/users_cubit/usersList_cubit.dart';
import 'package:dep_manager_panel/data/entities/Departments/Departments.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_panel/data/cubit/AuthCubit/AuthCubit.dart';
import 'package:user_panel/data/services/ChatService.dart';
import 'package:user_panel/views/UsersPage/Messaging/ChatPage.dart';
import 'package:user_panel/views/UsersPage/ToDoViews/PageBuilder.dart';
import '../../../data/entities/Users/Users.dart';

class Messagingpage extends StatefulWidget {
  final Departments department;
  final String user_id;

  Messagingpage(this.department, this.user_id, {super.key});

  @override
  State<Messagingpage> createState() => _MessagingpageState();
}

class _MessagingpageState extends State<Messagingpage>
    with TickerProviderStateMixin {
  var departmentsOfUser = <String>[];
  final chatService = ChatService();
  late String senderUserId;

  Future<void> getUserID() async {
    var getAuthCubit = context.read<AuthCubit>();
    var user_id = getAuthCubit.state;
    setState(() {
      senderUserId = user_id;
    });
  }

  @override
  void initState() {
    super.initState();
    context
        .read<UsersListCubit>()
        .departmandakiKullanicilar(widget.department.dep_id);
    getUserID();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme
            .of(context)
            .scaffoldBackgroundColor,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          leading: const SizedBox.shrink(),
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(
                  Icons.exit_to_app,
                  size: 40,
                )),
          ],
        ),
        body: Stack(
          children: [
            BlocBuilder<UsersListCubit, List<Users>>(
              builder: (context, userList) {
                final newUserList = userList
                    .where((user) => user.userID != widget.user_id)
                    .toList();

                if (newUserList.isNotEmpty) {
                  return ListView.builder(
                    itemCount: newUserList.length,
                    itemBuilder: (context, index) {
                      var user = newUserList[index];
                      var url = user.faceOfUser;
                      return StreamBuilder(
                          stream: chatService.getLastMessage(
                              user.userID!, senderUserId),
                          builder: (context, lastMessage) {
                            return GestureDetector(
                              onTap: () async {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            ChatPage(
                                                user: user,
                                                senderUserId: senderUserId)));
                              },
                              child: Card(
                                child: SizedBox(
                                  height: 75,
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment
                                        .center,
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(12.0),
                                        child: SizedBox(
                                            width: 50,
                                            height: 50,
                                            child: url != null
                                                ? SizedBox(
                                                width: 75,
                                                height: 75,
                                                child: CircleAvatar(
                                                  child: ClipOval(
                                                      child: Image.network(
                                                        width: 75,
                                                        height: 75,
                                                        url,
                                                        fit: BoxFit.fill,
                                                      )),
                                                ))
                                                : SizedBox(
                                                width: 75,
                                                height: 75,
                                                child: CircleAvatar(
                                                  child: ClipOval(
                                                    child: Image.asset(
                                                      width: 75,
                                                      height: 75,
                                                      "images/images.png",
                                                      fit: BoxFit.fill,
                                                    ),
                                                  ),
                                                ))),
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Column(
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                              "${user.userFname} ${user
                                                  .userLname}",
                                              style: Theme
                                                  .of(context)
                                                  .textTheme
                                                  .titleLarge
                                          ),
                                          Text(
                                            (lastMessage.data!.docs
                                                .firstOrNull?["message"] ??
                                                "")
                                                .toString()
                                                .length >
                                                20
                                                ? "${(lastMessage.data!.docs
                                                .firstOrNull?["message"] ?? "")
                                                .toString()
                                                .substring(0, 21)} ..."
                                                : (lastMessage.data!.docs
                                                .firstOrNull?[
                                            "message"] ??
                                                "")
                                                .toString(),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: Theme
                                                .of(context)
                                                .textTheme
                                                .bodyMedium,
                                          ),
                                        ],
                                      ),
                                      const Spacer(),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                          crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                          children: [
                                            Text(
                                              lastMessage.data!.docs
                                                  .firstOrNull?["timeStamp"]
                                                  .toDate()
                                                  .toString()
                                                  .split(" ")[1]
                                                  .substring(0, 5) ??
                                                  "",
                                              style: const TextStyle(
                                                  color: Colors.green,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 15),
                                            ),
                                            const Icon(
                                              Icons.notifications_off,
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            );
                          });
                    },
                  );
                } else {
                  return CircularProgressIndicator(
                    color: Theme
                        .of(context)
                        .colorScheme
                        .primary,
                  );
                }
              },
            )
          ],
        ),
        floatingActionButton: Padding(
          padding: const EdgeInsets.all(8.0),
          child: FloatingActionButton(
            elevation: 20.0,
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          PageBuild(department: widget.department)
                  ));
            },
            tooltip: "ToDo",
            heroTag: "ToDo",
            child: const Icon(Icons.edit_calendar),
          ),
        ));
  }
}
