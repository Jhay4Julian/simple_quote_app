import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:api_tut/constants.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quotables',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    super.key,
  });

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late final Future<List> getQuotesFuture;

//   List quotes = [];

  @override
  initState() {
    super.initState();

    getQuotesFuture = _getQuotes();
  }

  Future<List<dynamic>> _getQuotes() async {
    final url = Uri.https(Constants.url, Constants.endPoint);

    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      return data.values.toList().first;
    } else {
      return Future.error('An Error Occurred');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Center(child: Text('Quotables')),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30),
            ),
            color: Color.fromARGB(228, 255, 217, 0),
          ),
        ),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: getQuotesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            // Data is ready, show the ListView
            List quotes = snapshot.data ?? [];
            return Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Container(
                color: Colors.black,
                child: ListView.separated(
                  itemCount: quotes.length,
                  itemBuilder: (BuildContext context, index) {
                    return ListTile(
                      leading: const Icon(
                        Icons.star,
                        color: Color.fromARGB(228, 255, 217, 0),
                      ),
                      title: Text(
                        quotes[index]['quote'],
                        style: const TextStyle(color: Colors.white),
                      ),
                      subtitle: Text(
                        quotes[index]['author'],
                        style: const TextStyle(color: Colors.white),
                      ),
                    );
                  },
                  separatorBuilder: (BuildContext context, index) =>
                      const Divider(),
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
