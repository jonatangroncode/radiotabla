import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:intl/intl.dart';

String startTimeUTC = '/Date(1699743600000)/';

int milliseconds = int.parse(startTimeUTC.replaceAll(RegExp(r'[^0-9]'), ''));
DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(milliseconds);

String formattedDateTime = DateFormat.yMd().add_Hm().format(dateTime);

List<dynamic> schedule = [];

Future<List<dynamic>> fetchData() async {
  var getFetchUrl =
      'http://api.sr.se/api/v2/scheduledepisodes?channelid=164&format=json';
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

class SchedulePage extends StatelessWidget {
  const SchedulePage({Key? key}) : super(key: key);

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
            itemCount: schedule.length,
            itemBuilder: (BuildContext context, int index) {
              final title = schedule[index]['title'];
              final description = schedule[index]['description'];
              final starttimeutc = schedule[index]['starttimeutc'];
              final endtimeutc = schedule[index]['endtimeutc'];

              //formates the date to readeble and displayes the time
              int milliseconds =
                  int.parse(starttimeutc.replaceAll(RegExp(r'[^0-9]'), ''));
              DateTime dateTime =
                  DateTime.fromMillisecondsSinceEpoch(milliseconds);
              //The comment-line under show full date
              //String formattedDateTime = DateFormat.yMd().add_Hm().format(dateTime);
              String formattedDateTime = DateFormat('Hm').format(dateTime);

              //formates the date to readeble and displayes the time
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
                    Text('Startar: $formattedDateTime - $formattedEndDateTime'),
                    // Add additional widgets here
                    // For example:
                  ],
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('$description'),
                  ],
                ),
                onTap: () {
                  // Navigate to LearnFlutterPage when tapped
                },
              );
            },
          );
        }
      },
    );
  }
}
