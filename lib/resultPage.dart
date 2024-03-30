import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:async';

// Result Page
class ResultPage extends StatefulWidget {
  final String queryName;
  final String queryOrg;
  final String querySelectedType;

  ResultPage(
      {required this.queryName,
      required this.queryOrg,
      required this.querySelectedType});

  @override
  _ResultPageState createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  List<dynamic> _pets = [];
  String _accessToken = '';
  Timer? _tokenTimer; // expiration time for the access token

  @override
  void initState() {
    super.initState();

    // step 1 (get access token), then step 2 (call the flipping api)
    _getAccessToken().then((_) => _fetchPets());
  }

  @override
  void dispose() {
    _tokenTimer?.cancel();
    super.dispose();
  }

  // step 1: use client_id (api key) and client_secret to obtain access token
  Future<void> _getAccessToken() async {
    final clientId = dotenv.env['PETFINDER_API_KEY']!;
    final clientSecret = dotenv.env['PETFINDER_SECRET']!;

    final response = await http.post(
      Uri.https('api.petfinder.com', '/v2/oauth2/token'),
      headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      body:
          'grant_type=client_credentials&client_id=$clientId&client_secret=$clientSecret',
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        _accessToken = data['access_token'];
        _tokenTimer =
            Timer(Duration(seconds: data['expires_in']), _getAccessToken);
      });
    } else {
      // Handle error
      print(
          'Failed to get access token, response status code: ${response.statusCode}');
    }
  }

  // step 2: call the api to get pet lists
  Future<void> _fetchPets() async {
    // Get the pet type ID
    final petTypeId = await _getPetTypeId(widget.querySelectedType);

    // Get the organization ID
    final orgId = await _getOrganizationId(widget.queryOrg);

    final url = Uri.https(
      'api.petfinder.com',
      '/v2/animals',
      {
        // search query
        'name': widget.queryName,
        'type': petTypeId,
        'organization': orgId,
        'limit': '20',
      },
    );

    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $_accessToken',
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
        'Authorization': 'Bearer $_accessToken',
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
        'Authorization': 'Bearer $_accessToken',
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
    return Scaffold(
      appBar: AppBar(
        title: Text('Search Results'),
      ),
      body: ListView.builder(
        itemCount: _pets.length,
        itemBuilder: (context, index) {
          final pet = _pets[index];
          return ListTile(
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
          );
        },
      ),
    );
  }
}
