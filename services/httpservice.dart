import 'package:restapi/datamodels/photo.dart';
import 'package:restapi/datamodels/post.dart';
import 'package:http/http.dart' as http;

// class to get the posts and photos from the jsonplaceholder
class HttpService {
  final postsURL = Uri.parse("https://jsonplaceholder.typicode.com/posts");
  final photoURL = Uri.parse("https://jsonplaceholder.typicode.com/photos");
  final client = http.Client();

  Uri getPhotosUriForAlbum({int currentAlbum = 1}) {
    return Uri.parse(
        "https://jsonplaceholder.typicode.com/photos?albumId=$currentAlbum");
  }

  // function to get the posts
  // can also return null, if an error happens while trying to get the data
  Future<List<Post>?> getPosts() {
    return getList(sourceUri: postsURL, parseFunction: postFromJson);
  }

  // function to get the photos
  //  can also return null, if error happens
  Future<List<Photo>?> getPhotosForAlbum({int album = 1}) {
    return getList(
        sourceUri: getPhotosUriForAlbum(currentAlbum: album),
        parseFunction: photoFromJson);
  }

  // function to get the photos
  //  can also return null, if error happens
  Future<List<Photo>?> getPhotos() {
    return getList(sourceUri: photoURL, parseFunction: photoFromJson);
  }

  // generic, to get photos and posts from the same function
  Future<List<T>?> getList<T>(
      {required Uri sourceUri,
      required List<T> Function(String) parseFunction}) async {
    var response = await client.get(sourceUri);

    // if status code is okay
    if (response.statusCode == 200) {
      var inhalt = response.body;
      return parseFunction(inhalt);
    } else {
      // if status code is anything other than okay, return null
      return null;
    }
  }
}
