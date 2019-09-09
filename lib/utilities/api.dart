import 'dart:convert';
import 'dart:io';
import 'package:async/async.dart';
import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';
import 'package:path/path.dart';

class Api {
  String baseUrl = "https://api-wisapedia.herokuapp.com";

  Future createNewUser(
      {String name,
      String password,
      String email,
      String number,
      DateTime birthDay}) async {
    http.Response res = await http.post(
      "$baseUrl/users",
      body: jsonEncode({
        "name": "$name",
        "password": "$password",
        "email": "$email",
        "number": "$number",
        "birthday": "${birthDay.toString()}"
      }),
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json',
      },
    );
    //print(res.body);
    return res;
  }

  Future updateUser(
      {String name,
      String password,
      String email,
      String number,
      String bio,
      DateTime birthDay,
      String token}) async {
    http.Response res = await http.patch(
      "$baseUrl/users/me",
      body: jsonEncode({
        "name": "$name",
        "email": "$email",
        "password": "$password",
        "bio": "$bio",
        "number": "$number",
        "birthday": "${birthDay.toString()}"
      }),
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        HttpHeaders.authorizationHeader: "Bearer $token"
      },
    );
    //print(res.body);
    return res;
  }

  Future loginUser({
    String password,
    String email,
  }) async {
    http.Response res = await http.post(
      "$baseUrl/users/login",
      body: jsonEncode({
        "password": "$password",
        "email": "$email",
      }),
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json',
      },
    );
    print(res.body);
    return res;
  }

  Future getPosts({
    String token,
  }) async {
    http.Response res = await http.get(
      "$baseUrl/posts?sortBy=createdAt:asc",
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        HttpHeaders.authorizationHeader: "Bearer $token"
      },
    );
    return res;
  }

  Future getPostDetails({
    String token,
    String id,
  }) async {
    http.Response res = await http.get(
      "$baseUrl/posts/$id",
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        HttpHeaders.authorizationHeader: "Bearer $token"
      },
    );
    return res;
  }

  Future readUser({String token, String uid}) async {
    http.Response res = await http.get(
      "$baseUrl/users/$uid",
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        HttpHeaders.authorizationHeader: "Bearer $token",
      },
    );
    if (res.statusCode == 200) {
      print("Api working");
    } else {
      print("Not Working");
    }
    return res;
  }

  Future contactUs({String token, String description}) async {
    http.Response res = await http.post(
      "$baseUrl/users/contact-us/$description",
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        HttpHeaders.authorizationHeader: "Bearer $token",
      },
    );
    if (res.statusCode == 200) {
    } else {
      print("Not Working");
    }
    return res;
  }

  Future verifyMe({String token, String code}) async {
    http.Response res = await http.post(
      "$baseUrl/users/verifyme/$code",
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        HttpHeaders.authorizationHeader: "Bearer $token",
      },
    );
    if (res.statusCode == 200) {
      print("Accepted");
    } else {
      print("Not Accepted");
    }
    return res;
  }

  Future getMyPosts({
    String token,
  }) async {
    http.Response res = await http.get(
      "$baseUrl/posts/me",
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        HttpHeaders.authorizationHeader: "Bearer $token"
      },
    );
    return res;
  }

  Future getBookmarks({
    String token,
    String id,
  }) async {
    http.Response res = await http.get(
      "$baseUrl/users/bookmarks",
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        HttpHeaders.authorizationHeader: "Bearer $token",
        "user": "$id",
      },
    );
    return res;
  }

  Future getMyTrips({
    String token,
    String id,
  }) async {
    http.Response res = await http.get(
      "$baseUrl/users/trips",
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        HttpHeaders.authorizationHeader: "Bearer $token",
        "user": "$id",
      },
    );
    return res;
  }

  Future getMyProfile({String token}) async {
    http.Response res = await http.get(
      "$baseUrl/users/me",
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        HttpHeaders.authorizationHeader: "Bearer $token"
      },
    );
    print(res.statusCode);
    return res;
  }

  Future joinTrip({
    String token,
    String id,
  }) async {
    http.Response res = await http.post(
      "$baseUrl/users/trips/$id",
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        HttpHeaders.authorizationHeader: "Bearer $token",
      },
    );
    print(res.statusCode);
    return res;
  }

  Future addBookmark({
    String token,
    String id,
  }) async {
    http.Response res = await http.post(
      "$baseUrl/users/bookmarks/$id",
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        HttpHeaders.authorizationHeader: "Bearer $token",
      },
    );
    print(res.statusCode);
    return res;
  }

  Future logOut({String token}) async {
    print(token);
    http.Response res = await http.post(
      "$baseUrl/users/logout",
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        HttpHeaders.authorizationHeader: "Bearer $token",
      },
    );
    print(res.statusCode);
    return res;
  }

  Future logOutAll({String token}) async {
    print(token);
    http.Response res = await http.post(
      "$baseUrl/users/logoutAll",
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        HttpHeaders.authorizationHeader: "Bearer $token",
      },
    );
    print(res.statusCode);
    return res;
  }

  Future removeBookmark({
    String token,
    String id,
  }) async {
    http.Response res = await http.delete(
      "$baseUrl/users/bookmarks/$id",
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        HttpHeaders.authorizationHeader: "Bearer $token",
      },
    );
    print(res.statusCode);
    return res;
  }

  Future deleteAvatar({String token}) async {
    http.Response res = await http.delete(
      "$baseUrl/users/me/avatar",
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        HttpHeaders.authorizationHeader: "Bearer $token",
      },
    );
    print(res.statusCode);
    return res;
  }

  Future deletePost({String token, String postId}) async {
    http.Response res = await http.delete(
      "$baseUrl/posts/$postId",
      headers: {HttpHeaders.authorizationHeader: "Bearer $token"},
    );
    print(res.statusCode);
    return res;
  }

  Future makePost({
    @required String token,
    @required File image,
    @required String startDate,
    @required String endDate,
    @required String route,
    @required String destination,
    @required String description,
    @required String person,
    @required String budget,
    @required String capacity,
    @required String whatsapp,
  }) async {
    var uri = Uri.parse("$baseUrl/posts");
    var request = new http.MultipartRequest(
      "POST",
      uri,
    );
    request.headers.addAll({
      'Content-type': 'application/json',
      'Accept': 'application/json',
      HttpHeaders.authorizationHeader: "Bearer $token"
    });

    var stream = new http.ByteStream(DelegatingStream.typed(image.openRead()));
    var length = await image.length();
    var multipartFile = new http.MultipartFile('image', stream, length,
        filename: basename(image.path));

    request.fields['description'] = '$description';
    request.fields['destination'] = '$destination';
    request.fields['start'] = '$startDate';
    request.fields['finish'] = '$endDate';
//    request.fields['person'] = '$person';
    request.fields['capacity'] = '$person';
    request.fields['route'] = '$route';
    request.fields['budget'] = '$budget';
    request.fields['wa'] = '$whatsapp';
//    request.fields['image'] = image.path;
    request.files.add(multipartFile);
    http.StreamedResponse response = await request.send();

//    request.files.add(new http.MultipartFile.fromBytes(
//      'image',
//      byteArray,
//      filename: "imageDataFor$destination",
//    ));

    print(response.statusCode);

    if (response.statusCode == 200) print('Uploaded!');

//    Dio dio = new Dio();
//    FormData formData = new FormData.from({
//      'description': '$description',
//      'destination': '$destination',
//      'start': '$startDate',
//      'finish': '$endDate',
//      'person': '$person',
//      'route': '$route',
//      'image': new UploadFileInfo(image, image.path)
//    });
//    Response response = await dio.post(
//      "$baseUrl/posts",
//      data: formData,
//      onSendProgress: (int sent, int total) {
//        print("$sent $total");
//      },
//      options: Options(
//        responseType: ResponseType.json,
//        headers: {
//          HttpHeaders.authorizationHeader: "Bearer $token",
//        },
//      ),
//    );

    return response;
  }

  Future uploadAvatar({@required String token, @required File image}) async {
    var uri = Uri.parse("$baseUrl/users/me/avatar");
    var request = new http.MultipartRequest(
      "POST",
      uri,
    );
    request.headers.addAll({
      'Content-type': 'application/json',
      'Accept': 'application/json',
      HttpHeaders.authorizationHeader: "Bearer $token"
    });

    var stream = new http.ByteStream(DelegatingStream.typed(image.openRead()));
    var length = await image.length();
    var multipartFile = new http.MultipartFile('avatar', stream, length,
        filename: basename(image.path));

    request.files.add(multipartFile);
    http.StreamedResponse response = await request.send();

    print(response.statusCode);

    if (response.statusCode == 200) print('Uploaded!');

    return response;
  }
}
