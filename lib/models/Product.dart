import 'package:flutter/material.dart';

class Product {
  final String image, title, description, sex, name, age;
  final int size, id;
  final Color color;

  Product(
      {required this.image,
      required this.title,
      required this.name,
      required this.description,
      required this.sex,
      required this.size,
      required this.id,
      required this.color,
      required this.age});
}

List<Product> products = [
  Product(
      id: 1,
      title: "Cat",
      name: "Jimbo",
      size: 85,
      description:
          "Jimbo is currently being taken care at the Muhuhu PetOrg. However, he looks forward to being adopted. He is always hungry and the organization cannot take care of him as much as they could in the long term.",
      image: "assets/images/44.png",
      age: "8 Months",
      color: Color(0xFF5BC7FC),
      sex: 'Male'),
  Product(
      id: 2,
      title: "Dog",
      name: "Fufu",
      size: 56,
      description:
          "Fufu is currently being taken care at the Muhuhu PetOrg. However, she looks forward to being adopted. She is always hungry and the organization cannot take care of her as much as they could in the long term.",
      image: "assets/images/65.png",
      age: "6 Months",
      color: Color(0xFFA45C1D),
      sex: 'Female'),
  Product(
      id: 3,
      title: "Cat",
      name: "Lucy",
      size: 40,
      description:
          "Lucy is currently being taken care at the Muhuhu PetOrg. However, she looks forward to being adopted. She is always hungry and the organization cannot take care of her as much as they could in the long term.",
      image: "assets/images/1.png",
      age: "7 Months",
      color: Color(0xFFFC7EFC),
      sex: 'Female'),
  Product(
      id: 4,
      title: "Cat",
      name: "Milo",
      size: 75,
      description:
          "Milo is currently being taken care at the Muhuhu PetOrg. However, he looks forward to being adopted. He is always hungry and the organization cannot take care of him as much as they could in the long term.",
      image: "assets/images/2.png",
      age: "5 Months",
      color: Color(0xFF99F593),
      sex: 'Male'),
  Product(
      id: 5,
      title: "Dog",
      name: "Mike",
      size: 150,
      description:
          "Mike is currently being taken care at the Muhuhu PetOrg. However, he looks forward to being adopted. He is always hungry and the organization cannot take care of him as much as they could in the long term.",
      image: "assets/images/12.png",
      age: "10 Months",
      color: Color(0xFFFB7883),
      sex: 'Male'),
  Product(
    id: 6,
    title: "Dog",
    name: "Suzy",
    size: 130,
    description:
        "Jimbo is currently being taken care at the Muhuhu PetOrg. However, she looks forward to being adopted. She is always hungry and the organization cannot take care of her as much as they could in the long term.",
    image: "assets/images/666.png",
    age: "8 Months",
    color: Color(0xFFB643F1),
    sex: 'Female',
  ),
];
