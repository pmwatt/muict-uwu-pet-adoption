import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:async';

final List<String> petTypes = <String>['dog', 'cat', 'bird', 'rabbit'];

// Search Page
class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchNameController = TextEditingController();
  final TextEditingController _searchOrgController = TextEditingController();
  String petSelectedType = petTypes.first; // default selected pet type

  Future<void> _searchPets() async {
    final queryName = _searchNameController.text;
    final queryOrg = _searchOrgController.text;
    if (queryName.isNotEmpty ||
        queryOrg.isNotEmpty ||
        petSelectedType.isNotEmpty) {
      // Navigate to ResultPage with search query
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ResultPage(
            queryName: queryName,
            queryOrg: queryOrg,
            querySelectedType: petSelectedType,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search Pets'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // dropdown reference
            // https://api.flutter.dev/flutter/material/DropdownButton-class.html
            DropdownButton(
                items: petTypes.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? value) {
                  setState(() {
                    petSelectedType = value!;
                  });
                }),
            SizedBox(
              height: 20,
            ),
            Text('Enter pet name'),
            SizedBox(
              height: 20,
            ),
            TextField(
              controller: _searchNameController,
              decoration: InputDecoration(
                hintText: 'Enter pet name',
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Text('Enter organization name'),
            SizedBox(
              height: 20,
            ),
            TextField(
              controller: _searchOrgController,
              decoration: InputDecoration(
                hintText: 'Enter adoption centre name',
              ),
            ),
            ElevatedButton(
              onPressed: _searchPets,
              child: Text('Search'),
            ),
          ],
        ),
      ),
    );
  }
}

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
    final url = Uri.https(
      'api.petfinder.com',
      '/v2/animals',
      {
        // search query
        'name': widget.queryName,
        'type': widget.querySelectedType,
        'organization': widget.queryOrg,
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
