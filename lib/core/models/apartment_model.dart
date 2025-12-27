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
    // 1. Safe parsing for roomCount (Handling the mismatch: API uses 'rooms')
    final rawRooms = json['rooms'] ?? json['room_count'];
    int parsedRooms = 0;
    if (rawRooms != null) {
      parsedRooms = int.tryParse(rawRooms.toString()) ?? 0;
    }

    // 2. Safe parsing for governorate_id
    final rawGovId = json['governorate_id'];
    int govId = 1;
    if (rawGovId != null) {
      govId = int.tryParse(rawGovId.toString()) ?? 1;
    }

    return ApartmentModel(
      id: json['id'] ?? 0,
      title: json['title']?.toString() ?? 'No Title',
      description: json['description']?.toString() ?? '',
      governorate: _mapIdToGovernorate(govId),
      address: json['address']?.toString() ?? '',
      pricePerMonth:
          (double.tryParse(json['price_per_month'].toString()) ?? 0.0),
      rating:
          (json['rating'] != null) ? (json['rating'] as num).toDouble() : 4.3,
      // 3. Safe mapping for images (handling empty list)
      images: json['images'] != null && (json['images'] as List).isNotEmpty
          ? (json['images'] as List)
              .map((e) =>
                  "${ApiConstants.storageBaseUrl}${e['image_url'] ?? ''}")
              .toList()
          : [],
      roomCount: parsedRooms,
      status:
          ApartmentStatus.fromString(json['status']?.toString() ?? 'available'),
    );
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
      // FIX: Added missing return keywords below
      case 9:
        return Governorate.deirEzZor;
      case 10:
        return Governorate.hama;
      default:
        return Governorate.damascus;
    }
  }

  int _mapGovernorateToId(dynamic gov) {
    final govString = gov.toString();
    if (govString.contains('damascus')) return 1;
    if (govString.contains('aleppo')) return 2;
    if (govString.contains('homs')) return 3;
    if (govString.contains('rifDimashq')) return 4;
    if (govString.contains('daraa')) return 5;
    if (govString.contains('latakia')) return 6;
    if (govString.contains('tartus')) return 7;
    if (govString.contains('quneitra')) return 8;
    if (govString.contains('deirEzZor')) return 9;
    if (govString.contains('hama')) return 10;
    return 1;
  }
}
