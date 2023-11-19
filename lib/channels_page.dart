import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

import 'learn_flutter_page.dart';

List<dynamic> channel = [];

Future<List<dynamic>> fetchData() async {
  var getFetchUrl = 'http://api.sr.se/api/v2/channels?format=json';
  final dio = Dio();

  try {
    final response = await dio.get(getFetchUrl);

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = response.data;
      channel = data['channels'];
      return channel;
    } else {
      throw Exception('Can\'t load data from API');
    }
  } catch (e) {
    throw Exception('Error: $e');
  }
}

class ChannelPage extends StatelessWidget {
  const ChannelPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: fetchData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          return ListView.builder(
            itemCount: channel.length,
            itemBuilder: (BuildContext context, int index) {
              final name = channel[index]['name'];
              final channeltype = channel[index]['channeltype'];

              return ListTile(
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('$name'),

                    // Add additional widgets here
                    // For example:
                  ],
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('$channeltype'),
                  ],
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LearnFlutterPage(
                        channelData:
                            channel[index], // Pass the entire data structure
                      ),
                    ),
                  );
                },
              );
            },
          );
        }
      },
    );
  }
}
