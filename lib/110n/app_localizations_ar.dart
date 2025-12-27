// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appTitle => 'دريم ستاي';

  @override
  String get login => 'تسجيل الدخول';

  @override
  String get register => 'تسجيل';

  @override
  String get createAccount => 'إنشاء حساب';

  @override
  String get welcomeBack => 'مرحباً بعودتك';

  @override
  String get email => 'البريد الإلكتروني';

  @override
  String get phone => 'رقم الهاتف';

  @override
  String get password => 'كلمة المرور';

  @override
  String get firstName => 'الاسم الأول';

  @override
  String get lastName => 'الاسم الأخير';

  @override
  String get searchHint => 'ابحث عن وجهتك...';

  @override
  String get home => 'الرئيسية';

  @override
  String get bookings => 'حجوزاتي';

  @override
  String get favorites => 'المفضلة';

  @override
  String get settings => 'الإعدادات';

  @override
  String get dashboard => 'لوحة التحكم';

  @override
  String get theme => 'المظهر';

  @override
  String get language => 'اللغة';

  @override
  String get darkMode => 'الوضع الداكن';

  @override
  String get lightMode => 'الوضع الفاتح';

  @override
  String get systemDefault => 'النظام الافتراضي';

  @override
  String get logout => 'تسجيل خروج';

  @override
  String get bookNow => 'احجز الآن';

  @override
  String get pricePerMonth => '/شهرياً';

  @override
  String get bathrooms => 'حمامات';

  @override
  String get wifi => 'واي فاي';

  @override
  String get kitchen => 'مطبخ';

  @override
  String get description => 'الوصف';

  @override
  String get facilities => 'المرافق';

  @override
  String get totalPrice => 'السعر الإجمالي';

  @override
  String get available => 'متاح الآن';

  @override
  String get rented => 'مؤجر';

  @override
  String get unavailable => 'غير متاح';

  @override
  String get currency => 'العملة';

  @override
  String get changeLanguage => 'تغيير اللغة';

  @override
  String get introWelcomeTitle => 'مرحباً بك في\nدريم ستاي';

  @override
  String get introWelcomeDesc =>
      'اختبر أسهل طريقة للعثور على منزلك المثالي وحجزه.';

  @override
  String get introSlideToStartButton => 'اسحب للبدء';

  @override
  String get introSmartBookingTitle => 'حجز\nذكي';

  @override
  String get introSmartBookingDesc =>
      'إدارة إقامتك ومدفوعاتك وعقودك كلها في مكان واحد آمن.';

  @override
  String get introSlideToNextButton => 'اسحب للتالي';

  @override
  String get introReadyToMoveInTitle => 'جاهز\nللانتقال؟';

  @override
  String get introReadyToMoveInDesc => 'الآلاف من الشقق الموثقة في انتظارك.';

  @override
  String get introSlideToLoginButton => 'اسحب لتسجيل الدخول';

  @override
  String get skipButton => 'تخطي';

  @override
  String get englishLanguage => 'English';

  @override
  String get arabicLanguage => 'العربية';

  @override
  String get notifications => 'الإشعارات';

  @override
  String get manageYourAlerts => 'إدارة تنبيهاتك';

  @override
  String get versionInfo => 'الإصدار 1.0.0';

  @override
  String get guestUser => 'مستخدم ضيف';

  @override
  String get myBookings => 'حجوزاتي';

  @override
  String get ownerDashboard => 'لوحة تحكم المالك';

  @override
  String get startDate => 'تاريخ البدء';

  @override
  String get endDate => 'تاريخ الانتهاء';

  @override
  String get filters => 'الفلاتر';

  @override
  String get reset => 'إعادة تعيين';

  @override
  String get dates => 'التواريخ';

  @override
  String get rooms => 'غرف';

  @override
  String get fivePlusRooms => '5+';

  @override
  String get location => 'الموقع';

  @override
  String get priceRangeMonthly => 'نطاق السعر (شهرياً)';

  @override
  String get showResults => 'عرض النتائج';

  @override
  String get somethingWentWrong => 'عذراً! حدث خطأ ما.';

  @override
  String get retry => 'إعادة المحاولة';

  @override
  String get noApartmentsFound => 'لم يتم العثور على شقق.';

  @override
  String get searchResults => 'نتائج البحث';

  @override
  String foundProperties(Object count) {
    return 'تم العثور على $count عقارات';
  }

  @override
  String get noApartmentsFoundFilters =>
      'لم يتم العثور على شقق مطابقة للفلاتر الخاصة بك.';

  @override
  String get adjustFilters => 'تعديل الفلاتر';

  @override
  String roomsCount(Object count) {
    return '$count غرف';
  }

  @override
  String get oneBath => '1 حمام';

  @override
  String get currentlyUnavailable => 'غير متاح حالياً';

  @override
  String get price => 'السعر';

  @override
  String get notAvailable => 'غير متاح';

  @override
  String welcomeBackUser(Object firstName) {
    return 'مرحباً بك $firstName';
  }

  @override
  String get checkInputFields => 'الرجاء التحقق من حقول الإدخال الخاصة بك';

  @override
  String get accountPendingApproval => 'حسابك قيد انتظار موافقة المسؤول.';

  @override
  String get loginToContinue => 'تسجيل الدخول للمتابعة';

  @override
  String get phoneHint => '09xxxxxxxx';

  @override
  String get countryCode => '+963';

  @override
  String get passwordHint => '••••••••';

  @override
  String get featureComingSoon => 'الميزة قادمة قريبا!';

  @override
  String get forgotPassword => 'هل نسيت كلمة المرور؟';

  @override
  String get noAccountPrompt => 'ليس لديك حساب؟ ';

  @override
  String get signUp => 'اشتراك';

  @override
  String get takePhoto => 'التقاط صورة';

  @override
  String get chooseFromGallery => 'اختيار من المعرض';

  @override
  String get failedToPickImage => 'فشل في التقاط الصورة';

  @override
  String get uploadProfilePhoto => 'الرجاء تحميل صورة الملف الشخصي';

  @override
  String get uploadIdPhoto => 'الرجاء تحميل صورة الهوية';

  @override
  String get accountCreatedSuccessfully => 'تم إنشاء الحساب بنجاح!';

  @override
  String get joinCommunity => 'انضم إلى مجتمعنا اليوم.';

  @override
  String get tenant => 'مستأجر';

  @override
  String get investor => 'مستثمر';

  @override
  String get firstNameHint => 'محمد';

  @override
  String get lastNameHint => 'علي';

  @override
  String get dateOfBirth => 'تاريخ الميلاد';

  @override
  String get dateOfBirthHint => 'YYYY-MM-DD';

  @override
  String get verificationDocument => 'وثيقة التحقق';

  @override
  String get chooseFromFiles => 'اختيار من الملفات';

  @override
  String get failedToPickDocument => 'فشل في اختيار الوثيقة';

  @override
  String get pdfDocumentSelected => 'تم تحديد ملف PDF';

  @override
  String get idCardSelected => 'تم تحديد بطاقة الهوية';

  @override
  String get tapToChange => 'اضغط للتغيير';

  @override
  String get uploadIdCard => 'تحميل بطاقة الهوية';

  @override
  String get pngJpgPdf => 'PNG, JPG أو PDF';

  @override
  String get agreeToThe => 'أوافق على ';

  @override
  String get termsOfService => 'شروط الخدمة';

  @override
  String get and => ' و ';

  @override
  String get privacyPolicy => 'سياسة الخصوصية';

  @override
  String get alreadyHaveAccountPrompt => 'هل لديك حساب بالفعل؟ ';

  @override
  String get bookingDetails => 'تفاصيل الحجز';

  @override
  String get selectDates => 'تحديد التواريخ';

  @override
  String get paymentMethod => 'طريقة الدفع';

  @override
  String get visa => 'فيزا';

  @override
  String get mastercard => 'ماستر كارد';

  @override
  String get shamCash => 'شام كاش';

  @override
  String get cash => 'نقدي';

  @override
  String get confirmBooking => 'تأكيد الحجز';

  @override
  String get bookingConfirmed => 'تم تأكيد الحجز بنجاح';

  @override
  String get noBookings => 'لا يوجد حجوزات';

  @override
  String get apartment => 'شقة';

  @override
  String get status => 'الحالة';

  @override
  String get modify => 'تعديل';

  @override
  String get cancel => 'إلغاء';

  @override
  String get checkOut => 'تسجيل خروج';

  @override
  String get rateStay => 'قيم إقامتك';

  @override
  String get submitRating => 'إرسال التقييم';

  @override
  String get ratingSubmitted => 'تم إرسال التقييم';

  @override
  String get bookingCancelled => 'تم إلغاء الحجز';

  @override
  String get updateRequestSent => 'تم إرسال طلب التعديل';

  @override
  String get modifyBooking => 'تعديل الحجز';

  @override
  String get saveChanges => 'حفظ التغييرات';

  @override
  String get pending => 'قيد الانتظار';

  @override
  String get confirmed => 'مؤكد';

  @override
  String get rejected => 'مرفوض';

  @override
  String get cancelled => 'ملغي';

  @override
  String get completed => 'مكتمل';

  @override
  String get bookingRequests => 'طلبات الحجز';

  @override
  String get myProperties => 'عقاراتي';

  @override
  String get addProperty => 'إضافة عقار';

  @override
  String get editProperty => 'تعديل العقار';

  @override
  String get deleteProperty => 'حذف العقار';

  @override
  String get deleteConfirm => 'هل أنت متأكد أنك تريد حذف هذا العقار؟';

  @override
  String get earnings => 'إجمالي الأرباح';

  @override
  String get accept => 'قبول';

  @override
  String get reject => 'رفض';

  @override
  String get noRequests => 'لا توجد طلبات حجز معلقة';

  @override
  String get noProperties => 'لم تقم بإدراج أي عقارات بعد';

  @override
  String get propertyTitle => 'عنوان العقار';

  @override
  String get propertyDesc => 'الوصف';

  @override
  String get propertyAddress => 'العنوان';

  @override
  String get priceUsd => 'السعر (دولار)';

  @override
  String get uploadImages => 'رفع صور';

  @override
  String get saveProperty => 'حفظ التغييرات';

  @override
  String get createProperty => 'نشر العقار';

  @override
  String get fieldRequired => 'هذا الحقل مطلوب';
}
