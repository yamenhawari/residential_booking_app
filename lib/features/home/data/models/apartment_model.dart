import '../../../../core/entities/apartment.dart';
import '../../../../core/enums/city_enum.dart';

class ApartmentModel extends Apartment {
  const ApartmentModel({
    required super.id,
    required super.title,
    required super.description,
    required super.city,
    required super.area,
    required super.price,
    required super.rating,
    required super.images,
    required super.isAvailable,
    required super.roomCount,
    required super.floor,
  });

  factory ApartmentModel.fromJson(Map<String, dynamic> json) {
    return ApartmentModel(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      city: City.values.byName(json['city']),
      area: json['area'],
      price: (json['price'] as num).toDouble(),
      rating: (json['rating'] as num).toDouble(),
      images: List<String>.from(json['images']),
      isAvailable: json['is_available'],
      roomCount: json['room_count'],
      floor: json['floor'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'city': city.name,
      'area': area,
      'price': price,
      'rating': rating,
      'images': images,
      'is_available': isAvailable,
      'room_count': roomCount,
      'floor': floor,
    };
  }
}
