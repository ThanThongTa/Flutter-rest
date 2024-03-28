// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:restapi/services/httpservice.dart';
import 'package:sizer/sizer.dart';

import '../datamodels/photo.dart';
import 'screen1.dart';

class Screen2 extends StatefulWidget {
  const Screen2({super.key});

  @override
  State<Screen2> createState() => _Screen2State();
}

class _Screen2State extends State<Screen2> {
  var isLoaded = false;
  var hasMore = true;
  var currentAlbum = 1;
  List<Photo> photos = [];

  void getData() async {
    isLoaded = false;

    // loading only 50 at a time
    var loadedphotos =
        await HttpService().getPhotosForAlbum(album: currentAlbum);
    if (loadedphotos != null) {
      // if no more photos are loaded
      if (loadedphotos.isEmpty) {
        setState(() {
          isLoaded = true;
          hasMore = false;
        });
      } else {
        setState(() {
          isLoaded = true;
          photos.addAll(loadedphotos); // add lazy loaded photos to list
        });
      }
    }
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("REST API - Photos Page"),
        backgroundColor: Colors.lightGreen,
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
                            builder: (context) => Screen1(),
                          ));
                    },
                    child: Text("to Posts"),
                  ),
                  GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      mainAxisExtent: 16.h,
                      mainAxisSpacing: 1.h,
                      crossAxisSpacing: 1.h,
                    ),
                    shrinkWrap: true,
                    physics: PageScrollPhysics(),
                    itemCount: hasMore ? photos.length + 1 : photos.length,
                    itemBuilder: (context, index) {
                      if (index >= photos.length) {
                        // loading more photos
                        if (!isLoaded || index == photos.length) {
                          currentAlbum++;
                          print("get photos for $currentAlbum");
                          getData();
                        }

                        return Center(
                          child: SizedBox(
                            height: 24,
                            width: 24,
                            child: CircularProgressIndicator(),
                          ),
                        );
                      }

                      return Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(photos[index].url),
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(
                              color: Colors.black45,
                              width: double.infinity,
                              child: Text(
                                photos[index].title,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 8.sp,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
