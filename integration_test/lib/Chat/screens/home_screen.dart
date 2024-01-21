import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:integration_test/utils/size_utils.dart';

import '../api/apis.dart';
import '../models/chat_user.dart';
import '../widgets/chat_user_card.dart';

//home screen -- where all available contacts are shown
class ChatHomeScreen extends StatefulWidget {
  const ChatHomeScreen({super.key});

  @override
  State<ChatHomeScreen> createState() => _ChatHomeScreenState();
}

class _ChatHomeScreenState extends State<ChatHomeScreen> {
  // for storing all users
  List<ChatUser> _myList = [];
  List<ChatUser> _allList = [];

  // for storing searched items
  final List<ChatUser> _searchList = [];
  // for storing search status
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    APIs.getSelfInfo();

    //for updating user active status according to lifecycle events
    //resume -- active or online
    //pause  -- inactive or offline
    SystemChannels.lifecycle.setMessageHandler((message) {
      log('Message: $message');

      if (APIs.auth.currentUser != null) {
        if (message.toString().contains('resume')) {
          APIs.updateActiveStatus(true);
        }
        if (message.toString().contains('pause')) {
          APIs.updateActiveStatus(false);
        }
      }

      return Future.value(message);
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      //for hiding keyboard when a tap is detected on screen
      onTap: () => FocusScope.of(context).unfocus(),
      child: WillPopScope(
        //if search is on & back button is pressed then close search
        //or else simple close current screen on back button click
        onWillPop: () {
          if (_isSearching) {
            setState(() {
              _isSearching = !_isSearching;
            });
            return Future.value(false);
          } else {
            return Future.value(true);
          }
        },
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
            foregroundColor: Theme.of(context).appBarTheme.foregroundColor,
            iconTheme: Theme.of(context).appBarTheme.iconTheme,
            actionsIconTheme: Theme.of(context).appBarTheme.actionsIconTheme,
            titleTextStyle: Theme.of(context).primaryTextTheme.titleLarge,
            centerTitle: true,
            title: const Text(
              'Chat',
              style: TextStyle(color: Colors.black),
            ),
          ),

          floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
          floatingActionButton: FloatingActionButton(
            heroTag: 'addChat',
            backgroundColor: Theme.of(context).colorScheme.primary,
            elevation: 3,
            onPressed: () {
              _addChatUserDialog();
            },
            child: const Icon(Icons.add_circle),
          ),

          //body
          body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
            stream: APIs.getMyUsersId(),

            //get id of only known users
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                //if data is loading
                case ConnectionState.waiting:
                case ConnectionState.none:
                  return const Center(child: CircularProgressIndicator());

                //if some or all data is loaded then show it
                case ConnectionState.active:
                case ConnectionState.done:
                  final data = snapshot.data?.docs;
                  List<String> idList = data?.map((e) => e.id).toList() ?? [];

                  if (data!.isNotEmpty) {
                    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                      stream: APIs.getAllUsers(idList),

                      //get only those user, who's ids are provided
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
                            _allList = data
                                    ?.map((e) => ChatUser.fromJson(e.data()))
                                    .toList() ??
                                [];

                            if (_allList.isNotEmpty) {
                              return ListView.builder(
                                  itemCount: _isSearching
                                      ? _searchList.length
                                      : _allList.length,
                                  padding: const EdgeInsets.only(top: 05),
                                  physics: const BouncingScrollPhysics(),
                                  shrinkWrap: true,
                                  itemBuilder: (context, index) {
                                    return ChatUserCard(
                                      user: _isSearching
                                          ? _searchList[index]
                                          : _allList[index],
                                      isMainList: false,
                                    );
                                  });
                            } else {
                              return const Center(
                                child: Text('No Users Found!',
                                    style: TextStyle(fontSize: 20)),
                              );
                            }
                        }
                      },
                    );
                  }

                  if (_myList.isNotEmpty) {
                    return ListView.builder(
                        itemCount:
                            _isSearching ? _searchList.length : _myList.length,
                        padding: const EdgeInsets.only(top: 05),
                        physics: const BouncingScrollPhysics(),
                        itemBuilder: (context, index) {
                          return ChatUserCard(
                            user: _isSearching
                                ? _searchList[index]
                                : _myList[index],
                            isMainList: false,
                          );
                        });
                  } else {
                    return const Center(
                      child: Text('No Chats Found!',
                          style: TextStyle(fontSize: 20)),
                    );
                  }
              }
            },
          ),
        ),
      ),
    );
  }

  // for adding new chat user
  void _addChatUserDialog() {
    //String email = '';

    showDialog(
      context: context,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24), color: Colors.white),
            margin: EdgeInsets.only(
                left: 24.toResponsiveWidth,
                right: 24.toResponsiveWidth,
                top: 24.toResponsiveHeight,
                bottom: 24.toResponsiveHeight),
            padding: EdgeInsets.only(top: 24.toResponsiveHeight),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 20.0),
                  child: Text(
                    "Users",
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                ),
                Flexible(
                  child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                    stream: APIs.getAllUsers([]),

                    //get only those user, who's ids are provided
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
                          _allList = data
                                  ?.map((e) => ChatUser.fromJson(e.data()))
                                  .toList() ??
                              [];

                          if (_allList.isNotEmpty) {
                            return ListView.builder(
                                itemCount: _isSearching
                                    ? _searchList.length
                                    : _allList.length,
                                padding: const EdgeInsets.only(top: 05),
                                physics: const BouncingScrollPhysics(),
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  return ChatUserCard(
                                    user: _isSearching
                                        ? _searchList[index]
                                        : _allList[index],
                                    isMainList: true,
                                  );
                                });
                          } else {
                            return const Center(
                              child: Text('No Users Found!',
                                  style: TextStyle(fontSize: 20)),
                            );
                          }
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
