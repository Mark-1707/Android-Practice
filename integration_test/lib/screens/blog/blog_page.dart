import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:integration_test/Chat/api/apis.dart';
import 'package:integration_test/api_sdk/dio/models/blog_model.dart';
import 'package:integration_test/common_export.dart';
import 'package:integration_test/screens/blog/blog_card.dart';

class BlogPage extends StatefulWidget {
  final String text;
  const BlogPage({super.key, required this.text});
  @override
  BlogPageState createState() => BlogPageState();
}

class BlogPageState extends State<BlogPage> {
  late BlogsModel blogsModel;
  List<BlogsModel> _list = [];
  final SharedPrefs prefs = SharedPrefs.instance;

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
          'Previous Breakdown Blog',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        child: StreamBuilder<QuerySnapshot>(
          stream: APIs.getBlogsInfo(),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return const Center(
                  child: CircularProgressIndicator(),
                );
              case ConnectionState.done:
                return const Center(
                  child: CircularProgressIndicator(),
                );

              // if then all data showing
              case ConnectionState.active:
                final data = snapshot.data?.docs;
                _list = data
                        ?.map((e) => BlogsModel.fromJson(
                            e.data() as Map<String, dynamic>))
                        .toList() ??
                    [];

                if (_list.isNotEmpty) {
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: _list.length,
                    //_list.length,
                    padding: const EdgeInsets.only(top: 1),
                    physics: const BouncingScrollPhysics(),
                    itemBuilder: (context, index) {
                      final data = _list[index];
                      return data.author_id == prefs.getPhone()
                          ? Dismissible(
                              direction: DismissDirection.endToStart,
                              key: Key(data.date),
                              onDismissed: (direction) async {
                                await FirebaseFirestore.instance
                                    .collection('blogs')
                                    .doc(snapshot.data!.docs[index].id)
                                    .delete();
                                // _list.removeAt(index)
                                // Get.snackbar('delete', "$_list[index] dismissed");
                              },
                              background: Container(
                                  color: Colors.red,
                                  child: const Text("Delete")),
                              child: BlogListcard(
                                blogsModel: _list[index],
                                docId: snapshot.data!.docs[index].id,
                              ),
                            )
                          : BlogListcard(
                              blogsModel: _list[index],
                              docId: snapshot.data!.docs[index].id,
                            );
                    },

                    // BlogListcard(
                    //   user: _list[index],
                    // );
                  );
                } else {
                  return const Center(
                    child: Text(
                      'no connection found',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                  );
                }

              default:
                return const Center(
                  child: CircularProgressIndicator(),
                );
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.push('/createBlog');
        },
        backgroundColor: Theme.of(context).primaryColor,
        child: const Icon(Icons.add),
      ),
    );
  }
}
