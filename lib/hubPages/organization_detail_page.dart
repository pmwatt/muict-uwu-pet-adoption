import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';

class OrganizationDetailPage extends StatefulWidget {
  final String organizationId;
  final String accessToken;

  OrganizationDetailPage({
    required this.organizationId,
    required this.accessToken,
  });

  @override
  _OrganizationDetailPageState createState() => _OrganizationDetailPageState();
}

class _OrganizationDetailPageState extends State<OrganizationDetailPage> {
  dynamic _organizationDetails;

  // borrowed from pet detail page
  static const TextStyle textStyleH1 = TextStyle(
      fontSize: 50,
      fontWeight: FontWeight.normal,
      color: Color.fromARGB(255, 100, 50, 50));
  static const TextStyle textStyleH2 = TextStyle(
      fontSize: 30,
      fontWeight: FontWeight.bold,
      color: Color.fromARGB(255, 170, 89, 89));

  @override
  void initState() {
    super.initState();
    _fetchOrganizationDetails();
  }

  Future<void> _fetchOrganizationDetails() async {
    final response = await http.get(
      Uri.https(
          'api.petfinder.com', '/v2/organizations/${widget.organizationId}'),
      headers: {
        'Authorization': 'Bearer ${widget.accessToken}',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        _organizationDetails = data['organization'];
      });
    } else {
      // Handle error
      print(
          'Failed to fetch organization details, response status code: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_organizationDetails == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Organization Details'),
        ),
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Organization Details'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (_organizationDetails['photos'].isNotEmpty)
                Image.network(
                  _organizationDetails['photos'][0]['full'],
                  fit: BoxFit.fitWidth,
                )
              else
                Text('No Image Available'),
              Text(
                _organizationDetails['name'],
                style: textStyleH1,
              ),
              SizedBox(height: 16.0),
              Text(
                'Contact',
                style: textStyleH2,
              ),
              SizedBox(
                height: 8,
              ),
              if (_organizationDetails['website'] == null)
                Text('No URL Found')
              else
                Text(_organizationDetails['website']),
              SizedBox(
                height: 8,
              ),
              if (_organizationDetails['email'] == null)
                Text('No Email Found')
              else
                Text(_organizationDetails['email']),
              SizedBox(
                height: 8,
              ),
              if (_organizationDetails['phone'] == null)
                Text('No Phone Found')
              else
                Text(_organizationDetails['phone']),
            ],
          ),
        ),
      ),
    );
  }
}
