// ignore_for_file: unused_local_variable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:integration_test/Chat/api/apis.dart';

import '../../api_sdk/dio/models/blog_model.dart';

// ignore: depend_on_referenced_packages

class BlogDetails extends StatelessWidget {
  final BlogsModel blogsModel;
  const BlogDetails({super.key, required this.blogsModel});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
          foregroundColor: Theme.of(context).appBarTheme.foregroundColor,
          iconTheme: Theme.of(context).appBarTheme.iconTheme,
          actionsIconTheme: Theme.of(context).appBarTheme.actionsIconTheme,
          titleTextStyle: Theme.of(context).primaryTextTheme.titleLarge,
          centerTitle: true,
          title: const Text(
            'Previous Breakdown Blog Details',
            style: TextStyle(color: Colors.black, fontSize: 16),
          ),
          leading: const BackButton(
            color: Colors.black,
          ),
        ),
        body: SafeArea(
          minimum: const EdgeInsets.symmetric(horizontal: 16),
          child: Padding(
            padding: const EdgeInsets.only(top: 0),
            child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: APIs.getBlogsInfo(),
                builder: (context, snapshot) {
                  final data = snapshot.data?.docs;

                  final list = data
                          ?.map((e) => BlogsModel.fromJson(e.data()))
                          .toList() ??
                      [];

                  return Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: ListView(
                      children: [
                        Wrap(
                          alignment: WrapAlignment.start,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            CircleAvatar(
                              radius: 16,
                              backgroundImage:
                                  NetworkImage(blogsModel.blog_pic[0]),
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            Text(
                              blogsModel.author,
                              style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            Text(
                              blogsModel.date,

                              // user.date.microsecondsSinceEpoch.toString(),
                              //  user.date =  DateTime.fromMicrosecondsSinceEpoch(timestamp),
                              //  "${  newdate =  user.date}",

                              style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontWeight: FontWeight.w500,
                              ),
                              // style:
                              // TextStyle(
                              //     fontWeight: FontWeight.bold,
                              //     color: AppColors.deepPurple),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        Text(
                          blogsModel.title,
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        // const SizedBox(
                        //   height: 1,
                        // ),

                        const SizedBox(
                          height: 20,
                        ),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(blogsModel.blog_pic[0]),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: blogsModel.content,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                  height: 1.7,
                                  wordSpacing: 2,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }),
          ),
        ));
  }
}
