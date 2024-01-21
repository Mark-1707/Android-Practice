import 'dart:developer';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:integration_test/common_export.dart';
import '../api/apis.dart';
import '../helper/my_date_util.dart';
import '../models/chat_user.dart';
import '../models/message.dart';
import '../widgets/message_card.dart';
import 'view_profile_screen.dart';

class ChatScreen extends StatefulWidget {
  final ChatUser user;

  const ChatScreen({super.key, required this.user});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  //for storing all messages
  List<Message> _list = [];

  //for handling message text changes
  final _textController = TextEditingController();

  //showEmoji -- for storing value of showing or hiding emoji
  //isUploading -- for checking if image is uploading or not?
  bool _showEmoji = false, _isUploading = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: WillPopScope(
        //if emojis are shown & back button is pressed then hide emojis
        //or else simple close current screen on back button click
        onWillPop: () {
          if (_showEmoji) {
            setState(() => _showEmoji = !_showEmoji);
            return Future.value(false);
          } else {
            return Future.value(true);
          }
        },
        child: Scaffold(
          //app bar
          appBar: AppBar(
            backgroundColor: Colors.white,
            automaticallyImplyLeading: true,
            title: _appBar(),
            iconTheme: const IconThemeData(
              color: Colors.black, //change your color here
            ),
            actions: [
              IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => ViewProfileScreen(user: widget.user)));
                },
                icon: const Icon(Icons.info, color: Colors.black54),
              )
            ],
          ),

          backgroundColor: const Color.fromARGB(255, 255, 255, 255),

          //body
          body: Column(
            children: [
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: APIs.getAllMessages(widget.user),
                  builder: (context, snapshot) {
                    switch (snapshot.connectionState) {
                      //if data is loading
                      case ConnectionState.waiting:
                      case ConnectionState.none:
                        return const SizedBox();

                      //if some or all data is loaded then show it
                      case ConnectionState.active:
                      case ConnectionState.done:
                        final data = snapshot.data?.docs;
                        _list = data
                                ?.map((e) => Message.fromJson(
                                    e.data() as Map<String, dynamic>))
                                .toList() ??
                            [];

                        if (_list.isNotEmpty) {
                          return ListView.builder(
                              reverse: true,
                              itemCount: _list.length,
                              padding: const EdgeInsets.only(top: 01),
                              physics: const BouncingScrollPhysics(),
                              itemBuilder: (context, index) {
                                return MessageCard(message: _list[index]);
                              });
                        } else {
                          return const Center(
                            child: Text('Say Hii! 👋',
                                style: TextStyle(fontSize: 20)),
                          );
                        }
                    }
                  },
                ),
              ),

              //progress indicator for showing uploading
              if (_isUploading)
                const Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                        child: CircularProgressIndicator(strokeWidth: 2))),

              //chat input filed
              _chatInput(),

              //show emojis on keyboard emoji button click & vice versa
              if (_showEmoji)
                SizedBox(
                  height: 300.toResponsiveHeight,
                  child: EmojiPicker(
                    textEditingController: _textController,
                    config: Config(
                      bgColor: const Color.fromARGB(255, 234, 248, 255),
                      columns: 8,
                      emojiSizeMax: 32 * (Platform.isIOS ? 1.30 : 1.0),
                    ),
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }

  /*List<Widget> my = [
              IconButton(
                onPressed: () {
                  Widget okButton = TextButton(
                    child: const Text("Delete"),
                    onPressed: () async {
                      //APIs.deleteMessage(message)
                    },
                  );
                  Widget cancelButton = TextButton(
                    child: const Text("Cancel"),
                    onPressed: () async {
                      Navigator.pop(context);
                      //context.pop();
                    },
                  );
                  // set up the AlertDialog
                  AlertDialog alert = AlertDialog(
                    title: const Text("Delete Chat"),
                    content: const Text(
                        "Are you sure you want to delete this Chat?"),
                    actions: [okButton, cancelButton],
                  );

                  // show the dialog
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return alert;
                    },
                  );
                },
                icon: const Icon(Icons.delete, color: Colors.black54),
              )
            ];*/

  // app bar widget
  Widget _appBar() {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: APIs.getUserInfo(widget.user),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          //if data is loading
          case ConnectionState.waiting:
          case ConnectionState.none:
          // return const Center(
          //     child: CircularProgressIndicator());

          //if some or all data is loaded then show it
          case ConnectionState.active:
          case ConnectionState.done:
            final data = snapshot.data?.docs;
            ChatUser user;

            if (data != null) {
              user = ChatUser.fromJson(data.elementAt(0).data());
            } else {
              user = widget.user;
            }

            return Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(03),
                  child: CachedNetworkImage(
                    width: 45,
                    height: 45,
                    imageUrl: user.image,
                    errorWidget: (context, url, error) => const CircleAvatar(
                        child: Icon(CupertinoIcons.person)),
                  ),
                ),

                //for adding some space
                const SizedBox(width: 10),

                //user name & last seen time
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //user name
                    Text(user.name,
                        style: const TextStyle(
                            fontSize: 16,
                            color: Colors.black87,
                            fontWeight: FontWeight.w500)),

                    const SizedBox(height: 2),

                    //last seen time of user
                    Text(
                        user.isOnline
                            ? 'Online'
                            : MyDateUtil.getLastActiveTime(
                                context: context,
                                lastActive: user.lastActive),
                        style: const TextStyle(
                            fontSize: 13, color: Colors.black54)),
                  ],
                ),
              ],
            );
        }
      },
    );
  }

  // bottom chat input field
  Widget _chatInput() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 02),
      child: Row(
        children: [
          //input field & buttons
          Expanded(
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              child: Row(
                children: [
                  //emoji button
                  IconButton(
                      onPressed: () {
                        FocusScope.of(context).unfocus();
                        setState(() => _showEmoji = !_showEmoji);
                      },
                      icon: const Icon(Icons.emoji_emotions,
                          color: Colors.blueAccent, size: 25)),

                  Expanded(
                      child: TextField(
                    controller: _textController,
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    onTap: () {
                      if (_showEmoji) setState(() => _showEmoji = !_showEmoji);
                    },
                    decoration: const InputDecoration(
                        hintText: 'Type Something...',
                        hintStyle: TextStyle(color: Colors.blueAccent),
                        border: InputBorder.none),
                  )),

                  //pick image from gallery button
                  IconButton(
                      onPressed: () async {
                        final ImagePicker picker = ImagePicker();

                        // Picking multiple images
                        final List<XFile> images =
                            await picker.pickMultiImage(imageQuality: 70);

                        // uploading & sending image one by one
                        for (var i in images) {
                          log('Image Path: ${i.path}');
                          setState(() => _isUploading = true);
                          await APIs.sendChatImage(widget.user, File(i.path));
                          setState(() => _isUploading = false);
                        }
                      },
                      icon: const Icon(Icons.image,
                          color: Colors.blueAccent, size: 26)),

                  //take image from camera button
                  IconButton(
                      onPressed: () async {
                        final ImagePicker picker = ImagePicker();

                        // Pick an image
                        final XFile? image = await picker.pickImage(
                            source: ImageSource.camera, imageQuality: 70);
                        if (image != null) {
                          log('Image Path: ${image.path}');
                          setState(() => _isUploading = true);

                          await APIs.sendChatImage(
                              widget.user, File(image.path));
                          setState(() => _isUploading = false);
                        }
                      },
                      icon: const Icon(Icons.camera_alt_rounded,
                          color: Colors.blueAccent, size: 26)),

                  //adding some space
                  const SizedBox(width: 02),
                ],
              ),
            ),
          ),

          //send message button
          MaterialButton(
            onPressed: () {
              if (_textController.text.isNotEmpty) {
                if (_list.isEmpty) {
                  //on first message (add user to my_user collection of chat user)
                  APIs.sendFirstMessage(
                      widget.user, _textController.text, Type.text);
                } else {
                  //simply send message
                  APIs.sendMessage(
                      widget.user, _textController.text, Type.text);
                }
                _textController.text = '';
              }
            },
            minWidth: 0,
            padding:
                const EdgeInsets.only(top: 10, bottom: 10, right: 5, left: 10),
            shape: const CircleBorder(),
            color: Colors.green,
            child: const Icon(Icons.send, color: Colors.white, size: 28),
          )
        ],
      ),
    );
  }
}
