import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'organization_detail_page.dart';
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PetDetailPage extends StatefulWidget {
  final dynamic pet;
  final String accessToken;

  PetDetailPage({
    required this.pet,
    required this.accessToken,
  });

  @override
  _PetDetailPageState createState() => _PetDetailPageState();
}

class _PetDetailPageState extends State<PetDetailPage> {
  dynamic _petDetails;

  @override
  void initState() {
    super.initState();
    _fetchPetDetails();
  }

  static const TextStyle textStyleH1 = TextStyle(
      fontSize: 50,
      fontWeight: FontWeight.normal,
      color: Color.fromARGB(255, 100, 50, 50));
  static const TextStyle textStyleH2 = TextStyle(
      fontSize: 30,
      fontWeight: FontWeight.bold,
      color: Color.fromARGB(255, 170, 89, 89));

  Future<void> _fetchPetDetails() async {
    final response = await http.get(
      Uri.https('api.petfinder.com', '/v2/animals/${widget.pet['id']}'),
      headers: {
        'Authorization': 'Bearer ${widget.accessToken}',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        _petDetails = data['animal'];
      });
    } else {
      // Handle error
      print(
          'Failed to fetch pet details, response status code: ${response.statusCode}');
    }
  }

  // to launch url to the pet detail on the adoption centre site
  Future<void> _launchUrl() async {
    if (!await launchUrl(_petDetails['url'])) {
      throw Exception('Cannot launch ${_petDetails['url']}');
    }
  }

  Future<void> _navigateToOrganizationDetails() async {
    if (_petDetails != null && _petDetails['organization_id'] != null) {
      String organizationId = _petDetails['organization_id'];
      print(organizationId);

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => OrganizationDetailPage(
            organizationId: organizationId,
            accessToken: widget.accessToken,
          ),
        ),
      );
    } else {
      // Handle the case when _petDetails or _petDetails['organization_id'] is null
      print('Error: _petDetails or _petDetails[\'organization_id\'] is null');
    }
  }

  Future<void> _addToBookmarks() async {
    try {
      // Get the current user's ID from Firebase Authentication
      String userId = await FirebaseAuth.instance.currentUser!.uid;
      print('userId: ${userId}');
      print('petId: ${widget.pet['id']}');

      // https://stackoverflow.com/questions/64934102/firestore-add-or-remove-elements-to-existing-array-with-flutter
      // Create a new document in the "bookmarks" collection with the pet's ID
      await FirebaseFirestore.instance
          .collection('bookmarks')
          .doc(userId)
          .update({
        'arr_pets': FieldValue.arrayUnion([widget.pet['id'].toString()]),
      });

      // Display a success message or perform any other desired actions
      print('Pet added to bookmarks successfully');
    } catch (e) {
      // Handle any errors that occurred during the bookmarking process
      print('Error adding pet to bookmarks: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_petDetails == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Pet Details'),
        ),
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    print(_petDetails);

    return Scaffold(
      appBar: AppBar(
        title: Text('Pet Details'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (_petDetails['photos'].isNotEmpty &&
                  _petDetails['photos'][0]['full'] != null)
                Image.network(
                  _petDetails['photos'][0]['full'],
                  fit: BoxFit.fitWidth,
                  errorBuilder: (context, error, stackTrace) =>
                      Text('Image not available'),
                )
              else
                Text('No Image Available'),
              Text(
                _petDetails['name'],
                style: textStyleH1,
              ),
              SizedBox(height: 8.0),

              // this button to navigate to the organization taking care of the pet
              ElevatedButton(
                onPressed: _navigateToOrganizationDetails,
                child: Text('See Adoption Centre'),
              ),
              ////////////

              ElevatedButton(
                onPressed: _addToBookmarks,
                child: Text('Add to Bookmarks'),
              ),

              SizedBox(height: 16.0),
              ElevatedButton(
                child: Text('See Pet Detail'),
                onPressed: _launchUrl,
              ),
              SizedBox(height: 16.0),
              Text(
                'Description',
                style: textStyleH2,
              ),
              SizedBox(height: 8.0),
              Text(_petDetails['description']),
              SizedBox(height: 16.0),
              Text(
                'Breed',
                style: textStyleH2,
              ),
              SizedBox(height: 8.0),
              Text('${_petDetails['breeds']['primary']}'),
              SizedBox(height: 16.0),
              Text(
                'Age',
                style: textStyleH2,
              ),
              SizedBox(height: 8.0),
              Text('${_petDetails['age']}'),
              SizedBox(height: 16.0),
              Text(
                'Gender',
                style: textStyleH2,
              ),
              SizedBox(height: 8.0),
              Text('${_petDetails['gender']}'),
              SizedBox(height: 16.0),
              Text(
                'Size',
                style: textStyleH2,
              ),
              SizedBox(height: 8.0),
              Text('${_petDetails['size']}'),
              SizedBox(height: 16.0),
              Text(
                'Coat',
                style: textStyleH2,
              ),
              SizedBox(height: 8.0),
              Text('${_petDetails['coat']}'),
              SizedBox(height: 16.0),
              Text(
                'Primary Color',
                style: textStyleH2,
              ),
              SizedBox(height: 8.0),
              Text('${_petDetails['colors']['primary']}'),
              SizedBox(height: 16.0),
            ],
          ),
        ),
      ),
    );
  }
}
