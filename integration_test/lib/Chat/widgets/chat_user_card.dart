import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../common_export.dart';
import '../api/apis.dart';
import '../helper/my_date_util.dart';
import '../models/chat_user.dart';
import '../models/message.dart';
import '../screens/chat_screen.dart';

//card to represent a single user in home screen
class ChatUserCard extends StatefulWidget {
  final ChatUser user;
  final bool isMainList;

  const ChatUserCard({super.key, required this.user, required this.isMainList});

  @override
  State<ChatUserCard> createState() => _ChatUserCardState();
}

class _ChatUserCardState extends State<ChatUserCard> {
  //last message info (if null --> no message)
  Message? _message;
  static final SharedPrefs prefs = SharedPrefs.instance;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 04, vertical: 4),
      // color: Colors.blue.shade100,
      elevation: 0.5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: InkWell(
          onTap: () {
            //for navigating to chat screen
            //Navigator.of(context).pop();
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => ChatScreen(user: widget.user)));
          },
          child: StreamBuilder<QuerySnapshot>(
            stream: APIs.getLastMessage(widget.user),
            builder: (context, snapshot) {
              final data = snapshot.data?.docs;
              final list = data
                      ?.map((e) =>
                          Message.fromJson(e.data() as Map<String, dynamic>))
                      .toList() ??
                  [];
              // Map<String, dynamic> map = snap.snapshot.value as Map<String, dynamic>

              if (list.isNotEmpty) _message = list[0];

              return ListTile(
                //user profile picture
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: CachedNetworkImage(
                    width: 055,
                    height: 55,
                    imageUrl: widget.user.image,
                    //  fit: ,
                    errorWidget: (context, url, error) =>
                        const CircleAvatar(child: Icon(CupertinoIcons.person)),
                  ),
                ),

                //user name
                title: Text(widget.user.name),

                //last message
                subtitle: Text(
                    !widget.isMainList
                        ? _message != null
                            ? _message!.type == Type.image
                                ? 'image'
                                : _message!.msg
                            : widget.user.about
                        : widget.user.about,
                    maxLines: 1),

                //last message time
                trailing: _message == null
                    ? null //show nothing when no message is sent
                    : _message!.read.isEmpty &&
                            _message!.fromId != prefs.getEid()
                        ?
                        //show for unread message
                        Container(
                            width: 15,
                            height: 15,
                            decoration: BoxDecoration(
                                color: Colors.greenAccent.shade400,
                                borderRadius: BorderRadius.circular(10)),
                          )
                        :
                        //message sent time
                        Text(
                            MyDateUtil.getLastMessageTime(
                                context: context, time: _message!.sent),
                            style: const TextStyle(color: Colors.black54),
                          ),
              );
            },
          )),
    );
  }
}
