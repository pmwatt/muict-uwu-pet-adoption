import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'pet_detail_page.dart';

// Result Page
class ResultPage extends StatefulWidget {
  final String queryName;
  final String accessToken;

  const ResultPage({super.key, required this.queryName, required this.accessToken});

  @override
  _ResultPageState createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  List<dynamic> _pets = [];

  @override
  void initState() {
    super.initState();

    // step 1 (get access token), then step 2 (call the flipping api)
    _fetchPets();
  }

  // step 2: call the api to get pet lists
  Future<void> _fetchPets() async {
    final url = Uri.https(
      'api.petfinder.com',
      '/v2/animals',
      {
        // search query
        'name': widget.queryName,
        'limit': '20',
      },
    );

    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer ${widget.accessToken}',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        _pets = data['animals'];
      });
    } else {
      // Handle error
      print(
          'Failed to fetch pets, response status code: ${response.statusCode}');
      print(response.body);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_pets.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Pet Details'),
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Results'),
      ),
      body: ListView.builder(
        itemCount: _pets.length,
        itemBuilder: (context, index) {
          final pet = _pets[index];
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () {
                // Navigate to PetDetailPage
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PetDetailPage(
                      pet: pet,
                      accessToken: widget.accessToken,
                    ),
                  ),
                );
              },
              child: ListTile(
                title: Text(pet['name']),
                subtitle: Text(pet['breeds']['primary']),
                trailing: pet['photos'].isNotEmpty
                    ? Image.network(
                        pet['photos'][0]['small'],
                        height: 50,
                        width: 50,
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
            ),
          );
        },
      ),
    );
  }
}
