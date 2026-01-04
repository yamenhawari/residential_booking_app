import 'package:residential_booking_app/core/api/api_constants.dart';
import '../../domain/entities/booking.dart';
import '../../domain/entities/enums/booking_enum.dart';

class BookingModel extends Booking {
  final String? requestType;
  final int? pendingUpdateId;
  final String? requestedStart;
  final String? requestedEnd;
  final double? apartmentPrice;

  const BookingModel({
    required super.id,
    required super.apartmentId,
    required super.tenantId,
    required super.startDate,
    required super.endDate,
    required super.totalPrice,
    required super.status,
    required super.createdAt,
    super.apartmentName,
    super.apartmentImageUrl,
    super.tenantName,
    super.tenantImageUrl,
    super.myRating,
    this.requestType,
    this.pendingUpdateId,
    this.requestedStart,
    this.requestedEnd,
    this.apartmentPrice,
  });

  factory BookingModel.fromJson(Map<String, dynamic> json) {
    double parsedPrice = 0.0;
    if (json['total_price'] != null) {
      parsedPrice = double.tryParse(json['total_price'].toString()) ?? 0.0;
    }

    String? title;
    String? imgUrl;
    double? aptPrice;

    if (json['apartment'] != null) {
      title = json['apartment']['title'];

      if (json['apartment']['price_per_month'] != null) {
        aptPrice =
            double.tryParse(json['apartment']['price_per_month'].toString());
      }

      if (json['apartment']['images'] != null &&
          (json['apartment']['images'] as List).isNotEmpty) {
        final firstImg = json['apartment']['images'][0];
        final rawUrl =
            firstImg is Map ? firstImg['image_url'] : firstImg.toString();
        if (rawUrl.startsWith('http')) {
          imgUrl = rawUrl;
        } else {
          imgUrl = "${ApiConstants.storageBaseUrl}$rawUrl";
        }
      }
    }

    String? tName;
    String? tImage;
    if (json['tenant'] != null) {
      final f = json['tenant']['first_name'] ?? '';
      final l = json['tenant']['last_name'] ?? '';
      tName = "$f $l".trim();
      if (json['tenant']['profile_image'] != null) {
        final path = json['tenant']['profile_image'];
        tImage = path.startsWith('http')
            ? path
            : "${ApiConstants.storageBaseUrl}$path";
      }
    }

    double? userRating;
    if (json['review'] != null) {
      userRating = double.tryParse(json['review']['rating'].toString());
    }

    return BookingModel(
      id: json['id'],
      apartmentId: json['apartment_id'],
      tenantId: json['tenant_id'] ?? 0,
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
      requestType: json['request_type'],
      pendingUpdateId: json['pending_update_id'],
      requestedStart: json['requested_start'],
      requestedEnd: json['requested_end'],
      apartmentPrice: aptPrice,
    );
  }
}
