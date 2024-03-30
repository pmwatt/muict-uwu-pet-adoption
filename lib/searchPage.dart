import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'dart:async';
import 'resultPage.dart';

final List<String> petTypes = <String>['Dog', 'Cat', 'Bird', 'Rabbit'];

// Search Page
class SearchPage extends StatefulWidget {
  const SearchPage({
    super.key,
    required this.textStyleH1,
    required this.textStyleH2,
  });

  final TextStyle textStyleH1;
  final TextStyle textStyleH2;

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchNameController = TextEditingController();
  final TextEditingController _searchOrgController = TextEditingController();
  var showcasePetList = ['images/hibernatingcat.jpg', 'images/drunkcat.jpg'];
  String petSelectedType = 'Animal Type'; // default selected pet type
  String searchMessage = "Search";

  // handles checking if the form is empty or not
  Future<void> _searchPets() async {
    final queryName = _searchNameController.text;
    final queryOrg = _searchOrgController.text;
    if (petSelectedType != 'Animal Type' &&
        (queryName.isNotEmpty || queryOrg.isNotEmpty)) {
      // Navigate to ResultPage with search query
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ResultPage(
            queryName: queryName,
            queryOrg: queryOrg,
            querySelectedType: petSelectedType,
          ),
        ),
      );
      SchedulerBinding.instance.addPostFrameCallback((_) {});
    } else {
      setState(() {
        searchMessage = "The pet search query is empty";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              SizedBox(
                height: 200,
              ),
              Text(
                'Adopt your dream pet online',
                style: widget.textStyleH1,
              ),
              SizedBox(
                height: 50,
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/organization');
                },
                child: Text("View Hot Adoption Centre Examples"),
              ),
              SizedBox(
                height: 50,
              ),

              // carousel
              // reference:
              // https://pub.dev/packages/carousel_slider
              CarouselSlider(
                options: CarouselOptions(height: 400.0),
                items: showcasePetList.map((assetUrl) {
                  return Builder(
                    builder: (BuildContext context) {
                      return ClipRRect(
                          // width: MediaQuery.of(context).size.width,
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          // margin: EdgeInsets.symmetric(horizontal: 5.0),
                          child: Image(
                            image: AssetImage(assetUrl),
                          ));
                    },
                  );
                }).toList(),
              ),

              // search
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Text(
                        'Looking for something more specific?',
                        style: widget.textStyleH2,
                      ),
                      Text(searchMessage),
                      SizedBox(
                        height: 20,
                      ),

                      // dropdown reference
                      // https://api.flutter.dev/flutter/material/DropdownButton-class.html
                      DropdownButton(
                          hint: Text(petSelectedType),
                          items: petTypes
                              .map<DropdownMenuItem<String>>((String value) {
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
                      TextField(
                        controller: _searchNameController,
                        decoration: InputDecoration(
                          hintText: 'Enter pet name',
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextField(
                        controller: _searchOrgController,
                        decoration: InputDecoration(
                          hintText: 'Enter adoption centre name',
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      ElevatedButton(
                        onPressed: _searchPets,
                        child: Text('Search'),
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(
                height: 200,
              ),
              Column(
                children: [
                  Text(
                    'Pets you\'ve browsed before',
                    style: widget.textStyleH2,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          BookmarkedPet(
                              name: 'john',
                              assetUrl: 'images/hibernatingcat.jpg'),
                          BookmarkedPet(
                              name: 'john', assetUrl: 'images/drunkcat.jpg'),
                          BookmarkedPet(
                              name: 'john',
                              assetUrl: 'images/hibernatingcat.jpg'),
                          BookmarkedPet(
                              name: 'john', assetUrl: 'images/drunkcat.jpg'),
                          BookmarkedPet(
                              name: 'john',
                              assetUrl: 'images/hibernatingcat.jpg'),
                          BookmarkedPet(
                              name: 'john', assetUrl: 'images/drunkcat.jpg'),
                        ],
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 200,
              ),
              Text('Copyright 2024 @ UWU Co. Ltd. All Rights Reserved')
            ],
          ),
        ),
      ),
    );
  }
}

class BookmarkedPet extends StatelessWidget {
  final String assetUrl;
  final String name;
  const BookmarkedPet({
    super.key,
    required this.assetUrl,
    required this.name,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          CircleAvatar(
            backgroundImage: AssetImage(assetUrl),
            radius: 60,
          ),
          Text(name)
        ],
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
        'type': [
          {"name": widget.querySelectedType}
        ],
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
      body: Column(
        children: [
          ListView.builder(
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
        ],
      ),
    );
  }
}
