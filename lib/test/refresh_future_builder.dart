import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class RefreshFutBuild extends StatefulWidget {
  const RefreshFutBuild({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _RefreshFutBuildState();
  }
}

class _RefreshFutBuildState extends State<RefreshFutBuild> {
  Future<List<ListData>> listDataJSON() async {
    final response =
        await get(Uri.https("jsonplaceholder.typicode.com", "/photos"));

    if (response.statusCode == 200) {
      List listData = json.decode(response.body);
      return listData.map((listData) => ListData.fromJson(listData)).toList();
    } else {
      throw Exception('Error');
    }
  }

  Future refresh() async {
    setState(() {});
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (a, b, c) => const RefreshFutBuild(),
        transitionDuration: const Duration(seconds: 2),
      ),
    );
    return Future.value(false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('JALA PARA REFRESACAR'),
      ),
      body: RefreshIndicator(
        onRefresh: refresh
        // () {
        //   Navigator.pushReplacement(
        //     context,
        //     PageRouteBuilder(
        //       pageBuilder: (a, b, c) => MyApp(),
        //       transitionDuration: const Duration(seconds: 0),
        //     ),
        //   );
        //   return Future.value(false);
        // }
        ,
        child: FutureBuilder<List<ListData>>(
          future: listDataJSON(),
          builder: (context, snapshot) {
            if (snapshot.data == null) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
              return ListView.builder(
                  padding: const EdgeInsets.all(10),
                  itemBuilder: (BuildContext context, int currentIndex) {
                    return Column(
                      children: [
                        Row(
                          children: [
                            SizedBox(
                              width: 60.0,
                              height: 60.0,
                              child: CircleAvatar(
                                  backgroundImage: NetworkImage(snapshot
                                      .data![currentIndex].thumbnailUrl!)),
                            ),
                            Container(
                              margin: const EdgeInsets.only(left: 10.0),
                              width: 280.0,
                              child: Text(
                                snapshot.data![currentIndex].title!,
                                style: const TextStyle(
                                  fontSize: 20.0,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        const Divider(),
                      ],
                    );
                  });
            }
          },
        ),
      ),
    );
  }
}

class ListData {
  int? albumId;
  int? id;

  String? title;
  String? url;
  String? thumbnailUrl;

  ListData({this.albumId, this.id, this.title, this.url, this.thumbnailUrl});
  factory ListData.fromJson(Map<String, dynamic> jsonData) {
    return ListData(
      albumId: jsonData['albumId'],
      id: jsonData['id'],
      title: jsonData['title'],
      url: jsonData['url'],
      thumbnailUrl: jsonData['thumbnailUrl'],
    );
  }
}
