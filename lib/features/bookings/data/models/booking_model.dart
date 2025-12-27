import 'package:residential_booking_app/core/api/api_constants.dart';
import '../../domain/entities/booking.dart';
import '../../domain/entities/enums/booking_enum.dart';

class BookingModel extends Booking {
  const BookingModel({
    required super.id,
    required super.apartmentId,
    required super.startDate,
    required super.endDate,
    required super.totalPrice,
    required super.status,
    required super.createdAt,
    super.apartmentName,
    super.apartmentImageUrl,
    super.tenantName,
    super.tenantImageUrl,
    super.myRating, // Ensure this constructor param exists in Entity too
  });

  factory BookingModel.fromJson(Map<String, dynamic> json) {
    double parsedPrice = 0.0;
    if (json['total_price'] != null) {
      parsedPrice = double.tryParse(json['total_price'].toString()) ?? 0.0;
    }

    String? title;
    String? imgUrl;
    if (json['apartment'] != null) {
      title = json['apartment']['title'];
      if (json['apartment']['images'] != null &&
          (json['apartment']['images'] as List).isNotEmpty) {
        final firstImg = json['apartment']['images'][0];
        final rawUrl =
            firstImg is Map ? firstImg['image_url'] : firstImg.toString();
        imgUrl = "${ApiConstants.storageBaseUrl}$rawUrl";
      }
    }

    String? tName;
    String? tImage;
    if (json['tenant'] != null) {
      final f = json['tenant']['first_name'] ?? '';
      final l = json['tenant']['last_name'] ?? '';
      tName = "$f $l".trim();
      if (json['tenant']['profile_image'] != null) {
        tImage =
            "${ApiConstants.storageBaseUrl}${json['tenant']['profile_image']}";
      }
    }

    double? userRating;
    if (json['review'] != null) {
      userRating = double.tryParse(json['review']['rating'].toString());
    }

    return BookingModel(
      id: json['id'],
      apartmentId: json['apartment_id'],
      startDate: DateTime.parse(json['start_date']),
      endDate: DateTime.parse(json['end_date']),
      totalPrice: parsedPrice,
      status: BookingStatus.fromString(json['status']),
      createdAt: DateTime.parse(json['created_at']),
      apartmentName: title,
      apartmentImageUrl: imgUrl,
      tenantName: tName,
      tenantImageUrl: tImage,
      myRating: userRating,
    );
  }
}
