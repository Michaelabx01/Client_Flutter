import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class RefreshBasic extends StatefulWidget {
  const RefreshBasic({Key? key}) : super(key: key);

  @override
  State<RefreshBasic> createState() => _RefreshBasicState();
}

Photo photoNull = Photo(
    albumId: 0,
    id: 0,
    title: "NULL TITLE",
    url: "https://icon-library.com/images/null-icon/null-icon-10.jpg",
    thumbnailUrl: "https://icon-library.com/images/null-icon/null-icon-10.jpg");

class _RefreshBasicState extends State<RefreshBasic> {
  List<Photo> items = [photoNull];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: items.isEmpty
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : RefreshIndicator(
              onRefresh: refresh,
              child: ListView.builder(
                padding: const EdgeInsets.all(8),
                itemCount: items.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: Image.network(items[index].url!),
                    title: Text(items[index].title!),
                    trailing: Image.network(items[index].thumbnailUrl!),
                    subtitle: Text(items[index].id.toString()),
                    isThreeLine: true,
                  );
                },
              ),
            ),
    );
  }

  Future refresh() async {
    setState(() => items.clear);

    const url = 'https://jsonplaceholder.typicode.com/photos';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      List newItemsPhoto = jsonDecode(response.body);

      setState(() {
        items = newItemsPhoto.map((e) {
          return Photo.fromMap(e);
        }).toList();
      });
    }
  }
}

class Photo {
  int? albumId;
  int? id;
  String? title;
  String? url;
  String? thumbnailUrl;

  Photo({
    this.albumId,
    this.id,
    this.title,
    this.url,
    this.thumbnailUrl,
  });

  factory Photo.fromMap(Map<String, dynamic> map) {
    final data = Map<String, dynamic>.from(map);

    return Photo(
      albumId: data["albumId"],
      id: data["id"],
      title: data["title"],
      url: data["url"],
      thumbnailUrl: data["thumbnailUrl"],
    );
  }
}
