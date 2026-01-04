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
    required super.ownerId,
  });

  factory ApartmentModel.fromJson(Map<String, dynamic> json) {
    final rawRooms = json['rooms'] ?? json['room_count'];
    final parsedRooms = int.tryParse(rawRooms?.toString() ?? '') ?? 0;

    final rawGovId = json['governorate_id'];
    final govId = int.tryParse(rawGovId?.toString() ?? '') ?? 1;

    final parsedPrice =
        double.tryParse(json['price_per_month']?.toString() ?? '') ?? 0.0;

    int parsedOwnerId = 0;
    if (json['owner_id'] != null) {
      parsedOwnerId = int.tryParse(json['owner_id'].toString()) ?? 0;
    } else if (json['owner'] != null && json['owner']['id'] != null) {
      parsedOwnerId = int.tryParse(json['owner']['id'].toString()) ?? 0;
    }

    List<String> parsedImages = [];
    if (json['images'] != null && json['images'] is List) {
      parsedImages = (json['images'] as List)
          .map((e) {
            final path = e is Map ? e['image_url'] : e.toString();

            if (path.startsWith('http')) return path;

            return "${ApiConstants.storageBaseUrl}$path";
          })
          .cast<String>()
          .toList();
    }

    return ApartmentModel(
      id: json['id'] ?? 0,
      title: json['title']?.toString() ?? 'No Title',
      description: json['description']?.toString() ?? '',
      governorate: _mapIdToGovernorate(govId),
      address: json['address']?.toString() ?? '',
      pricePerMonth: parsedPrice,
      rating:
          (json['rating'] != null) ? (json['rating'] as num).toDouble() : 3.8,
      images: parsedImages,
      roomCount: parsedRooms,
      status:
          ApartmentStatus.fromString(json['status']?.toString() ?? 'available'),
      ownerId: parsedOwnerId,
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
      'status': status.toApiString,
      'owner_id': ownerId, // NEW
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
