// ignore_for_file: prefer_const_constructors

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:sizer/sizer.dart';
import 'package:universal_io/io.dart';

import '../datamodels/post.dart';
import '../services/httpservice.dart';
import 'screen2.dart';

class Screen1 extends StatefulWidget {
  const Screen1({
    super.key,
  });

  @override
  State<Screen1> createState() => _Screen1State();
}

class _Screen1State extends State<Screen1> {
  var isLoaded = false;
  List<Post>? posts;

  void getData() async {
    posts = await HttpService().getPosts();

    if (posts != null) {
      setState(() {
        isLoaded = true;
      });
    }
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  void deletePost({required int index}) {
    //TODO write a delete action
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: SizedBox(
            height: 3.h,
            child: Center(
                child: Row(
              children: [
                Icon(Platform.isIOS ? CupertinoIcons.check_mark : Icons.check),
                SizedBox(width: 2.w),
                Text("Post erfolgreich gelöscht"),
              ],
            )),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("REST API - Post Page"),
        backgroundColor: Colors.lightBlue,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Visibility(
              visible: isLoaded,
              replacement: CircularProgressIndicator(),
              child: Column(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Screen2(),
                          ));
                    },
                    child: Text("to Photos"),
                  ),
                  GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 1,
                      mainAxisExtent: 27.h,
                      mainAxisSpacing: 2.h,
                    ),
                    itemCount: posts == null ? 0 : posts!.length,
                    shrinkWrap: true,
                    padding: EdgeInsets.all(8.0),
                    physics: PageScrollPhysics(),
                    itemBuilder: (context, index) {
                      if (posts == null) {
                        return ListTile(title: Text("Keine Posts vorhanden"));
                      }
                      //TODO Fix that only the text is sliding, but not the orange background
                      return Slidable(
                        endActionPane: ActionPane(
                          motion: const ScrollMotion(),
                          children: [
                            SlidableAction(
                              onPressed: (context) => deletePost(index: index),
                              backgroundColor: Colors.teal,
                              icon: Platform.isIOS
                                  ? CupertinoIcons.delete
                                  : Icons.delete,
                              label: "Löschen",
                            ),
                          ],
                        ),
                        child: ListTile(
                          tileColor: Colors.orange,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                            side: BorderSide(style: BorderStyle.none),
                          ),
                          title: Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: Text(posts![index].title),
                          ),
                          subtitle: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(bottom: 8.0),
                                child: Divider(
                                  height: 0.1.h,
                                ),
                              ),
                              Text(posts![index].body),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  // button, to navigate to photo page
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
