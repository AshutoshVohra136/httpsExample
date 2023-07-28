import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as https;
import 'package:http_example/model/post.dart';

// Get Api Request

Future<Post> fetchPost() async {
  final uri = Uri.parse('https://jsonplaceholder.typicode.com/posts/1');
  final response = await https.get(uri);

  if (response.statusCode == 200) {
    return Post.fromJson(json.decode(response.body));

//Post.fromJson(json.decode(response.body));
  } else {
    throw Exception('Failed To Load Post');
  }
}

// post api request

Future<Post> createPost({required String title, required String body}) async {
  Map<String, dynamic> request = {
    'title': title,
    'body': body,
    'userId': "111"
  };
  final uri = Uri.parse('https://jsonplaceholder.typicode.com/posts');
  final response = await https.post(uri, body: request);

  if (response.statusCode == 201) {
    return Post.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed To Load Post');
  }
}

Future<Post> updatePost({required String title, required String body}) async {
  Map<String, dynamic> request = {
    'id': "101",
    'title': title,
    'body': body,
    'userId': "111"
  };
  final uri = Uri.parse('https://jsonplaceholder.typicode.com/posts/1');
  final response = await https.put(uri, body: request);
  if (response.statusCode == 200) {
    return Post.fromJson(json.decode(response.body));
  } else {
    throw Exception('Failed to Load Post');
  }
}

// delete request

Future<Post?>? deleteRequest() async {
  final uri = Uri.parse('https://jsonplaceholder.typicode.com/posts/1');
  final response = await https.delete(uri);
  if (response.statusCode == 200) {
    return null;
  } else {
    throw Exception(" Failed To Delete Post ");
  }
}
// void getData() async {
//   var data = await https
//       .get(Uri.parse('https://jsonplaceholder.typicode.com/posts/1/'));
//   var jsnData = jsonDecode(data.body);
//   print(jsnData['title']);
// }

void main(List<String> arguments) {
  runApp(const MaterialApp(
    home: HomeScreen(),
  ));
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Future<Post?>? post;

  void clickGetButton() {
    setState(() {
      post = fetchPost();
    });
  }

  void clickPostButton() {
    setState(() {
      post = createPost(title: " Top Post ", body: " This is an Example Post ");
    });
  }

  void clickDeleteButton() {
    setState(() {
      post = deleteRequest();
    });
  }

  void clickUpdateButton() {
    setState(() {
      post = updatePost(title: " Updated Post ", body: " New Updated  Post ");
    });
  }

  Widget buildDataWidget(context, snapshot) => Column(
        children: [
          Text(snapshot.data.title),
          Text(snapshot.data.description),
        ],
      );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(' Http Example '),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          FutureBuilder<Post?>(
            future: post,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.none) {
                return Container();
              } else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              } else if (snapshot.hasData) {
                return buildDataWidget(context, snapshot);
              } else {
                return const CircularProgressIndicator();
              }
            },
          ),
          SizedBox(
            width: 200,
            child: ElevatedButton(
                onPressed: () => clickGetButton(), child: const Text('GET')),
          ),
          SizedBox(
            width: 200,
            child: ElevatedButton(
                onPressed: () => clickPostButton(), child: const Text('POST')),
          ),
          SizedBox(
            width: 200,
            child: ElevatedButton(
                onPressed: () => clickUpdateButton(),
                child: const Text('UPDATE')),
          ),
          SizedBox(
            width: 200,
            child: ElevatedButton(
                onPressed: () => clickDeleteButton(),
                child: const Text('DELETE')),
          ),
        ],
      ),
    );
  }
}
