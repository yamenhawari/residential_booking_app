import 'package:equatable/equatable.dart';
import '../enums/city_enum.dart';

class Apartment extends Equatable {
  final int id;
  final String title;
  final String description;
  final City city;
  final String area;
  final double price;
  final double rating;
  final List<String> images;
  final bool isAvailable;
  final int roomCount;
  final int floor;

  const Apartment({
    required this.id,
    required this.title,
    required this.description,
    required this.city,
    required this.area,
    required this.price,
    required this.rating,
    required this.images,
    required this.isAvailable,
    required this.roomCount,
    required this.floor,
  });

  String get mainImageUrl => images.isNotEmpty ? images[0] : '';

  @override
  List<Object> get props => [
        id,
        title,
        description,
        city,
        area,
        price,
        rating,
        images,
        isAvailable,
        roomCount,
        floor,
      ];
}
