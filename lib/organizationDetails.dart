import 'package:flutter/material.dart';

class AdoptionCentreDetailsPage extends StatelessWidget {
  final String animalName;
  final String imageUrl;
  final String species;
  final String breed;
  final String age;
  final String description;
  final String adoptionCentreName;
  final String phone;
  final String email;
  final String website;

  const AdoptionCentreDetailsPage({
    Key? key,
    required this.animalName,
    required this.imageUrl,
    required this.species,
    required this.breed,
    required this.age,
    required this.description,
    required this.adoptionCentreName,
    required this.phone,
    required this.email,
    required this.website,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(animalName),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image
              Hero(
                tag: animalName,
                child: Image.network(
                  imageUrl,
                  width: double.infinity,
                  height: 200,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 16.0),

              // Details
              Text(
                "Species: $species",
                style: const TextStyle(fontSize: 16.0),
              ),
              const SizedBox(height: 8.0),
              Text(
                "Breed: $breed",
                style: const TextStyle(fontSize: 16.0),
              ),
              const SizedBox(height: 8.0),
              Text(
                "Age: $age",
                style: const TextStyle(fontSize: 16.0),
              ),
              const SizedBox(height: 8.0),

              // Description
              Text(
                "Description:",
                style: const TextStyle(
                    fontSize: 16.0, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8.0),
              Text(
                description,
                style: const TextStyle(fontSize: 16.0),
              ),
              const SizedBox(height: 16.0),

              // Adoption Centre Information
              Text(
                "Adoption Centre:",
                style: const TextStyle(
                    fontSize: 16.0, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8.0),
              Text(
                adoptionCentreName,
                style: const TextStyle(fontSize: 16.0),
              ),
              const SizedBox(height: 8.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Phone:",
                    style: const TextStyle(fontSize: 16.0),
                  ),
                  Text(
                    phone,
                    style: const TextStyle(fontSize: 16.0),
                  ),
                ],
              ),
              const SizedBox(height: 8.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Email:",
                    style: const TextStyle(fontSize: 16.0),
                  ),
                  Text(
                    email,
                    style: const TextStyle(fontSize: 16.0),
                  ),
                ],
              ),
              const SizedBox(height: 8.0),
              Text(
                website,
                style: const TextStyle(fontSize: 16.0),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
