import '../entities/apartment.dart';
import '../enums/governorate_enum.dart';

class ApartmentModel extends Apartment {
  const ApartmentModel({
    required super.id,
    required super.title,
    required super.description,
    required super.governorate,
    required super.address,
    required super.pricePerMonth,
    required super.rating,
    required super.images,
    required super.roomCount,
  });

  factory ApartmentModel.fromJson(Map<String, dynamic> json) {
    return ApartmentModel(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      governorate: Governorate.values.byName(json['governorate']),
      address: json['address'],
      pricePerMonth: (json['pricePerMonth'] as num).toDouble(),
      rating: (json['rating'] as num).toDouble(),
      images: List<String>.from(json['images']),
      roomCount: json['room_count'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'governorate': governorate.name,
      'address': address,
      'pricePerMonth': pricePerMonth,
      'rating': rating,
      'images': images,
      'room_count': roomCount,
    };
  }
}
