// search page

import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

// for api
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';

// for navigation
import 'result_page.dart';
import 'pet_detail_page.dart';

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
  // for search
  final TextEditingController _searchNameController = TextEditingController();
  String searchMessage = "Search";

  // for retrieving user's bookmark array
  List<String> _bookmarkedPetIds = [];
  final Map<String, dynamic> _petDetails = {};
  String _accessToken = '';
  Timer? _tokenTimer;

  // used for carousel
  var showcasePetList = [
    'assets/images/hibernatingcat.jpg',
    'assets/images/drunkcat.jpg'
  ];

  @override
  void initState() {
    super.initState();
    _getAccessToken().then((_) => _fetchBookmarkedPets());
  }

  @override
  void dispose() {
    _tokenTimer?.cancel();
    super.dispose();
  }

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
      print(
          'Failed to get access token, response status code: ${response.statusCode}');
    }
  }

  Future<void> _fetchBookmarkedPets() async {
    // Fetch bookmarked pet IDs from Firestore
    String userId = FirebaseAuth.instance.currentUser!.uid;
    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection('bookmarks')
        .doc(userId)
        .get();
    if (snapshot.exists) {
      _bookmarkedPetIds = List<String>.from(snapshot.get('arr_pets'));
      _fetchPetDetails(_bookmarkedPetIds);
    }
  }

  Future<void> _fetchPetDetails(List<String> petIds) async {
    // Fetch pet details using Petfinder API
    for (String petId in petIds) {
      final response = await http.get(
        Uri.https('api.petfinder.com', '/v2/animals/$petId'),
        headers: {
          'Authorization': 'Bearer $_accessToken',
        },
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        _petDetails[petId] = data['animal'];
      }
    }
    setState(() {});
  }

  // handles checking if the form is empty or not
  Future<void> _searchPets() async {
    final queryName = _searchNameController.text;
    if (queryName.isNotEmpty) {
      // Navigate to ResultPage with search query
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ResultPage(
            queryName: queryName,
            accessToken: _accessToken,
          ),
        ),
      );
    } else {
      setState(() {
        searchMessage = "Please enter search query.";
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
              const SizedBox(
                height: 200,
              ),
              Text(
                'Adopt your dream pet online',
                style: widget.textStyleH1,
              ),
              const SizedBox(
                height: 50,
              ),

              // carousel
              // https://pub.dev/packages/carousel_slider
              CarouselSlider(
                options: CarouselOptions(height: 400.0),
                items: showcasePetList.map((assetUrl) {
                  return Builder(
                    builder: (BuildContext context) {
                      return ClipRRect(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(20)),
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
                      const SizedBox(
                        height: 20,
                      ),
                      TextField(
                        controller: _searchNameController,
                        decoration: const InputDecoration(
                          hintText:
                              'Enter search query e.g. pet name, pet type',
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      ElevatedButton(
                        onPressed: _searchPets,
                        child: const Text('Search'),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(
                height: 200,
              ),
              Column(
                children: [
                  Text(
                    'Pets you\'ve bookmarked',
                    style: widget.textStyleH2,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: _bookmarkedPetIds.map((petId) {
                          if (_petDetails.containsKey(petId)) {
                            return BookmarkedPet(
                              petImageUrl: (_petDetails[petId]['photos']
                                          .isNotEmpty &&
                                      _petDetails[petId]['photos'][0]['full'] !=
                                          null)
                                  ? _petDetails[petId]['photos'][0]['full']
                                  : '',
                              name: _petDetails[petId]['name'],
                              pet: _petDetails[petId],
                              accessToken: _accessToken,
                            );
                          } else {
                            return const SizedBox.shrink();
                          }
                        }).toList(),
                      ),
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 200,
              ),
              const Text('Copyright 2024 @ UWU Co. Ltd. All Rights Reserved')
            ],
          ),
        ),
      ),
    );
  }
}

class BookmarkedPet extends StatelessWidget {
  final String petImageUrl;
  final String name;
  final dynamic pet;
  final String accessToken;
  const BookmarkedPet({
    super.key,
    required this.petImageUrl,
    required this.name,
    required this.pet,
    required this.accessToken,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PetDetailPage(
                    pet: pet,
                    accessToken: accessToken,
                  ),
                ),
              );
            },
            child: Column(
              children: [
                if (petImageUrl != '')
                  CircleAvatar(
                    backgroundImage: NetworkImage(
                      petImageUrl,
                    ),
                    radius: 60,
                  )
                else
                  const Text('No Image'),
              ],
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          if (name.isNotEmpty) Text(name) else const Text('No name'),
        ],
      ),
    );
  }
}
