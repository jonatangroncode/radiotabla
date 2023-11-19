import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

List<dynamic> schedule = [];

class LearnFlutterPage extends StatelessWidget {
  final Map<String, dynamic> channelData;

  LearnFlutterPage({
    Key? key,
    required this.channelData,
  }) : super(key: key);

  Future<List<dynamic>> fetchData() async {
    var getFetchUrl = '${channelData['scheduleurl']}&format=json';
    final dio = Dio();

    try {
      final response = await dio.get(getFetchUrl);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = response.data;
        schedule = data['schedule'];
        return schedule;
      } else {
        throw Exception('Can\'t load data from API');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tabla'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: FutureBuilder(
        future: fetchData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            return ListView.builder(
              itemCount: schedule.length,
              itemBuilder: (BuildContext context, int index) {
                final title = schedule[index]['title'];
                final description = schedule[index]['description'];
                final starttimeutc = schedule[index]['starttimeutc'];
                final endtimeutc = schedule[index]['endtimeutc'];

                int milliseconds =
                    int.parse(starttimeutc.replaceAll(RegExp(r'[^0-9]'), ''));
                DateTime dateTime =
                    DateTime.fromMillisecondsSinceEpoch(milliseconds);
                String formattedDateTime = DateFormat('Hm').format(dateTime);

                int endMilliseconds =
                    int.parse(endtimeutc.replaceAll(RegExp(r'[^0-9]'), ''));
                DateTime endDateTime =
                    DateTime.fromMillisecondsSinceEpoch(endMilliseconds);
                String formattedEndDateTime =
                    DateFormat('Hm').format(endDateTime);

                return ListTile(
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('$title'),
                      Text(
                          'Startar: $formattedDateTime - $formattedEndDateTime'),
                    ],
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('$description'),
                    ],
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
