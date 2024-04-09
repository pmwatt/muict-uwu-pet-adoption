import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'pet_detail_page.dart';

// Result Page
class ResultPage extends StatefulWidget {
  final String queryName;
  final String queryOrg;
  final String querySelectedType;
  final String accessToken;

  ResultPage(
      {required this.queryName,
      required this.queryOrg,
      required this.querySelectedType,
      required this.accessToken});

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
    // Get the pet type ID
    // final petTypeId = await _getPetTypeId(widget.querySelectedType);

    // Get the organization ID
    // final orgId = await _getOrganizationId(widget.queryOrg);

    final url = Uri.https(
      'api.petfinder.com',
      '/v2/animals',
      {
        // search query
        'name': widget.queryName,
        // 'type': petTypeId,
        // 'organization': orgId,
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

  // convert pet type string into ID
  // so that we can search for pets using pet type id
  Future<String> _getPetTypeId(String petType) async {
    final response = await http.get(
      Uri.https('api.petfinder.com', '/v2/types'),
      headers: {
        'Authorization': 'Bearer ${widget.accessToken}',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final types = data['types'];
      final type = types
          .firstWhere((t) => t['name'].toLowerCase() == petType.toLowerCase());
      return type['_links']['self']['href'].split('/').last;
    } else {
      // Handle error
      print(
          'Failed to fetch pet types, response status code: ${response.statusCode}');
      return '';
    }
  }

  // converting user's string organization input into ID
  // so that we can retrieve pets based on org ID
  Future<String> _getOrganizationId(String orgName) async {
    final response = await http.get(
      Uri.https('api.petfinder.com', '/v2/organizations'),
      headers: {
        'Authorization': 'Bearer ${widget.accessToken}',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final organizations = data['organizations'];
      final org = organizations.firstWhere(
          (o) => o['name'].toLowerCase().contains(orgName.toLowerCase()));
      return org['id'];
    } else {
      // Handle error
      print(
          'Failed to fetch organizations, response status code: ${response.statusCode}');
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_pets.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Pet Details'),
        ),
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('Search Results'),
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
