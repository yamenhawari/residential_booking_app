import 'package:residential_booking_app/core/api/api_constants.dart';
import 'package:residential_booking_app/core/enums/apartment_status_enum.dart';

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
    required super.status,
  });

  factory ApartmentModel.fromJson(Map<String, dynamic> json) {
    return ApartmentModel(
        id: json['id'],
        title: json['title'],
        description: json['description'],
        governorate:
            _mapIdToGovernorate(int.parse(json['governorate_id'].toString())),
        address: json['address'],
        pricePerMonth:
            (double.tryParse(json['price_per_month'].toString()) ?? 0.0),
        rating:
            (json['rating'] != null) ? (json['rating'] as num).toDouble() : 0.0,
        images: (json['images'] as List)
            .map((e) =>
                "${ApiConstants.storageBaseUrl}${e['image_url'].toString()}")
            .toList(),
        roomCount: int.parse(json['room_count'].toString()),
        status: ApartmentStatus.fromString(json['status'] ?? 'available'));
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'governorate_id': _mapGovernorateToId(governorate),
      'address': address,
      'price_per_month': pricePerMonth,
      'rating': rating,
      'images': images,
      'room_count': roomCount,
      'status': status.toApiString
    };
  }

  static Governorate _mapIdToGovernorate(int id) {
    switch (id) {
      case 1:
        return Governorate.damascus;
      case 2:
        return Governorate.aleppo;
      case 3:
        return Governorate.homs;
      case 4:
        return Governorate.rifDimashq;
      case 5:
        return Governorate.daraa;
      case 6:
        return Governorate.latakia;
      case 7:
        return Governorate.tartus;
      case 8:
        return Governorate.quneitra;
      case 9:
        Governorate.deirEzZor;
      case 10:
        Governorate.hama;
      default:
        return Governorate.damascus;
    }
    return Governorate.damascus;
  }

  int _mapGovernorateToId(dynamic gov) {
    switch (gov.toString()) {
      case 'Governorate.damascus':
        return 1;
      case 'Governorate.aleppo':
        return 2;
      case 'Governorate.homs':
        return 3;
      case 'Governorate.rifDimashq':
        return 4;
      case 'Governorate.daraa':
        return 5;
      case 'Governorate.latakia':
        return 6;
      case 'Governorate.tartus':
        return 7;
      case 'Governorate.quneitra':
        return 8;
      case 'Governorate.deirEzZor':
        return 9;
      case 'Governorate.hama':
        return 10;
      default:
        return 1;
    }
  }
}
