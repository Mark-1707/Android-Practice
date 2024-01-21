import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:integration_test/common_export.dart';

class CreateBlogPage extends StatefulWidget {
  //final String text;
  const CreateBlogPage({super.key});
  @override
  CreateBlogPageState createState() => CreateBlogPageState();
}

class CreateBlogPageState extends State<CreateBlogPage> {
  final GlobalKey<FormState> _key1 = GlobalKey<FormState>();

  List<File> images = [];
  final ImagePicker _picker = ImagePicker();

  TextEditingController titlecontroller = TextEditingController();
  TextEditingController contentcontroller = TextEditingController();
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
          'Create Previous Breakdown Blog',
          style: TextStyle(color: Colors.black),
        ),
        leading: const BackButton(
          color: Colors.black,
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _key1,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 10.toResponsiveHeight,
                  ),
                  InkWell(
                    onTap: () {
                      _selectImage(context);
                    },
                    child: Container(
                        width: double.maxFinite,
                        height: 100,
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.deepPurple),
                            borderRadius: BorderRadius.circular(20)),
                        child: const Center(
                          child: Icon(
                            Icons.upload_file,
                            size: 50,
                            color: Colors.deepPurple,
                          ),
                        )),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  /* GridView.builder(
                    physics: ScrollPhysics(),
                    itemCount: 3,
                    shrinkWrap: true,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3),
                    itemBuilder: (context, index) {
                      /// Local variables
                      String? imageUrl;

                      if (images.isNotEmpty) {
                        if (images.elementAt(index).path.isNotEmpty) {
                          imageUrl = images.elementAt(index).path;
                        }
                      }
                      BoxFit boxFit = BoxFit.none;

                      /// Show image widget
                      return GestureDetector(
                        child: Stack(
                          children: [
                            Card(
                              clipBehavior: Clip.antiAlias,
                              //shape: defaultCardBorder(),
                              color: Colors.grey[200],
                              child: Center(
                                child: Container(
                                  child: Icon(
                                    Icons.upload_file,
                                    size: 50,
                                    color: Colors.deepPurple,
                                  ),
                                ),
                              ),
                            ),
                            
                            Positioned(
                              child: IconButton(
                                  icon: CircleAvatar(
                                    radius: 12,
                                    backgroundColor:
                                        Theme.of(context).primaryColor,
                                    child: Icon(
                                      imageUrl == null
                                          ? Icons.add
                                          : Icons.delete,
                                      color: Colors.white,
                                      size: 16,
                                    ),
                                  ),
                                  onPressed: () {
                                    /// Check image url to exe action
                                    if (imageUrl == null) {
                                      /// Add or update image
                                      _selectImage(context, index);
                                    }
                                  }),
                              right: 0,
                              bottom: 0,
                            )
                          ],
                        ),
                        onTap: () {
                          /// Add or update image
                          _selectImage(context, index);
                        },
                      );
                    },
                  ), */
                  SizedBox(
                    width: double.maxFinite,
                    height: 150,
                    child: images.length == 0
                        ? const Center(
                            child: Text("No Images found"),
                          )
                        : ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (ctx, i) {
                              return Container(
                                  width: 100,
                                  margin: const EdgeInsets.only(right: 10),
                                  height: 100,
                                  decoration: BoxDecoration(
                                      border: Border.all(color: Colors.black),
                                      borderRadius: BorderRadius.circular(8)),
                                  child: Image.file(
                                    images[i],
                                    fit: BoxFit.cover,
                                  ));
                            },
                            itemCount: images.length,
                          ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    key: const Key('title'),
                    cursorColor:
                        Theme.of(context).textTheme.displayLarge!.color,
                    decoration: InputDecoration(
                      labelText: 'Enter  Title',
                      isDense: true,
                      prefixIcon: Icon(
                        Icons.title,
                        size: 28.toResponsiveFont,
                      ),
                      fillColor: Colors.white,
                      hintText: 'Enter Title',
                      hintStyle: const TextStyle(fontSize: 16),
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8.0)),
                        borderSide: BorderSide(width: 3, color: Colors.black38),
                      ),
                      filled: false,
                      contentPadding: const EdgeInsets.all(16),
                    ),
                    controller: titlecontroller,
                    keyboardType: TextInputType.name,
                    autocorrect: false,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Title is required.';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 15.toResponsiveHeight),
                  TextFormField(
                    key: const Key("content"),
                    controller: contentcontroller,
                    autocorrect: true,
                    textAlignVertical: TextAlignVertical.top,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                      prefixIcon: const Padding(
                        padding: EdgeInsets.only(bottom: 70.0),
                        child: Icon(
                          Icons.topic_rounded,
                        ),
                      ),
                    ),
                    maxLines: 5,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: MaterialButton(
                      color: Colors.deepPurple,
                      minWidth: double.infinity,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      height: 50,
                      onPressed: () async {
                        if (_key1.currentState!.validate()) {
                          for (int i = 0; i < images.length; i++) {
                            String url = await uploadFile(images[i]);
                            downloadUrls.add(url);

                            if (i == images.length - 1) {
                              blogEntry(
                                downloadUrls,
                                titlecontroller.text,
                                prefs.getName(),
                                contentcontroller.text.trim(),
                              );
                            }
                          }
                        }
                      },
                      child: const Text(" Create Previous Breakdown Blog",
                          style: TextStyle(color: Colors.white)),
                    ),
                  )
                ]),
          ),
        ),
      ),
    );
  }

  List<String> downloadUrls = [];

  void _selectImage(BuildContext context) async {
    final XFile? pickedImage =
        await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      images.add(File(pickedImage!.path));
      //images.insert(index, File(pickedImage!.path));
    });
  }

  //getImage() async {}

  Future<String> uploadFile(File file) async {
    final metaData = SettableMetadata(contentType: 'image/jpeg');
    final storageRef = FirebaseStorage.instance.ref();
    Reference ref = storageRef
        .child('pictures/${DateTime.now().microsecondsSinceEpoch}.jpg');
    final uploadTask = ref.putFile(file, metaData);

    final taskSnapshot = await uploadTask.whenComplete(() => null);
    String url = await taskSnapshot.ref.getDownloadURL();
    return url;
  }

  blogEntry(List<String> imageUrls, String title, author, content) {
    FirebaseFirestore.instance.collection('blogs').add({
      'author_id': prefs.getPhone(),
      'blog_pic': imageUrls,
      'title': title,
      'author': author,
      'content': content,
      'date': DateFormat('dd MMMM yyyy').format(DateTime.now()),
    }).then((value) async {
      await Fluttertoast.showToast(
          msg: 'Successfully created blog',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 3,
          backgroundColor: Theme.of(context).colorScheme.error,
          textColor: Colors.white,
          fontSize: 16.0);
    });
    context.pop();
  }
}
