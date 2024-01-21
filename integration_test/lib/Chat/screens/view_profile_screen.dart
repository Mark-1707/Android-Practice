import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../helper/my_date_util.dart';
import '../models/chat_user.dart';

//view profile screen -- to view profile of user
class ViewProfileScreen extends StatefulWidget {
  final ChatUser user;

  const ViewProfileScreen({super.key, required this.user});

  @override
  State<ViewProfileScreen> createState() => _ViewProfileScreenState();
}

class _ViewProfileScreenState extends State<ViewProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // for hiding keyboard
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
          // app bar
          appBar: AppBar(
            backgroundColor: Colors.white,
            automaticallyImplyLeading: true,
            title: const Text(
              "Profile",
              style: TextStyle(color: Colors.black),
            ),
            iconTheme: const IconThemeData(
              color: Colors.black, //change your color here
            ),
            //actions: ,
          ),
          floatingActionButton: //user about
              Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Joined On: ',
                style: TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.w500,
                    fontSize: 15),
              ),
              Text(
                  MyDateUtil.getLastMessageTime(
                      context: context,
                      time: widget.user.createdAt,
                      showYear: true),
                  style: const TextStyle(color: Colors.black54, fontSize: 15)),
            ],
          ),

          //body
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // for adding some space
                  const SizedBox(
                    width: 30,
                    height: 50,
                  ),

                  //user profile picture
                  ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: CachedNetworkImage(
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                      imageUrl: widget.user.image,
                      errorWidget: (context, url, error) => const CircleAvatar(
                          child: Icon(CupertinoIcons.person)),
                    ),
                  ),

                  // for adding some space
                  const SizedBox(height: 10),
                  Text(
                    widget.user.name,
                    style: const TextStyle(
                        color: Colors.black87,
                        fontWeight: FontWeight.w500,
                        fontSize: 15),
                  ),
                  const SizedBox(height: 02),

                  // user email label
                  Text(widget.user.email,
                      style:
                          const TextStyle(color: Colors.black87, fontSize: 16)),

                  // for adding some space
                  const SizedBox(height: 02),

                  //user about
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'About: ',
                        style: TextStyle(
                            color: Colors.black87,
                            fontWeight: FontWeight.w500,
                            fontSize: 15),
                      ),
                      Text(widget.user.about,
                          style: const TextStyle(
                              color: Colors.black54, fontSize: 15)),
                    ],
                  ),
                ],
              ),
            ),
          )),
    );
  }
}
