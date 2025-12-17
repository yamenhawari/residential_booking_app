import 'package:equatable/equatable.dart';
import '../enums/governorate_enum.dart';

class Apartment extends Equatable {
  final int id;
  final String title;
  final String description;
  final Governorate governorate;
  final String address;
  final double pricePerMonth;
  final double rating;
  final List<String> images;
  final int roomCount;

  const Apartment({
    required this.id,
    required this.title,
    required this.description,
    required this.governorate,
    required this.address,
    required this.pricePerMonth,
    required this.rating,
    required this.images,
    required this.roomCount,
  });

  String get mainImageUrl => images.isNotEmpty ? images[0] : '';

  @override
  List<Object> get props => [
        id,
        title,
        description,
        governorate,
        address,
        pricePerMonth,
        rating,
        images,
        roomCount,
      ];
}
