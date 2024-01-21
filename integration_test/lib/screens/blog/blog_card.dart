import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:integration_test/common_export.dart';

import '../../api_sdk/dio/models/blog_model.dart';

class BlogListcard extends StatefulWidget {
  final BlogsModel blogsModel;
  final String docId;

  const BlogListcard(
      {super.key, required this.blogsModel, required this.docId});

  @override
  State<BlogListcard> createState() => _BlogListcardState();
}

class _BlogListcardState extends State<BlogListcard> {
  final SharedPrefs prefs = SharedPrefs.instance;
  
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100.toResponsiveHeight,
      child: Stack(
        children: [
          Card(
            color: Colors.grey,
            semanticContainer: true,
            margin: const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
            elevation: 0,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            child: InkWell(
              onTap: () {
                context.push('/blogDetailsBlog', extra: widget.blogsModel);
              },
              child: Center(
                child: Row(
                  children: [
                    CachedNetworkImage(
                      imageUrl: widget.blogsModel.blog_pic[0],
                      fit: BoxFit.cover,
                      width: 100.toResponsiveHeight,
                      height: 100.toResponsiveHeight,
                      errorWidget: (context, url, error) => const CircleAvatar(
                          child: Icon(CupertinoIcons.person)),
                    ),
                    SizedBox(
                      width: 10.toResponsiveWidth,
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.blogsModel.title,
                            maxLines: 2,
                            style: const TextStyle(
                                fontWeight: FontWeight.w500, fontSize: 20),
                          ),
                          SizedBox(
                            height: 10.toResponsiveHeight,
                          ),
                          Text(
                            widget.blogsModel.author,
                            maxLines: 2,
                            style: const TextStyle(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(
                            height: 10.toResponsiveHeight,
                          ),
                          Text(
                            widget.blogsModel.date,
                            maxLines: 2,
                            style: const TextStyle(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          widget.blogsModel.author_id == prefs.getPhone() ? Positioned(
              right: 0,
              top: 0,
              child: IconButton(
                splashRadius: 10,
                icon: const Icon(
                  Icons.delete,
                  color: Colors.red,
                ),
                onPressed: () {
                  Widget okButton = TextButton(
                    child: const Text("Delete"),
                    onPressed: () async {
                      await FirebaseFirestore.instance
                          .collection('blogs')
                          .doc(widget.docId)
                          .delete();
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
                    title: const Text("Delete Blog"),
                    content: const Text("Are you sure you want to delete this blog?"),
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
              )) : const SizedBox(width: 0,height: 0,),
        ],
      ),
    );
  }
}
