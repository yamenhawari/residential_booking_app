import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import '110n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en')
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'DreamStay'**
  String get appTitle;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @register.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get register;

  /// No description provided for @createAccount.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get createAccount;

  /// No description provided for @welcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome Back'**
  String get welcomeBack;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @phone.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get phone;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @firstName.
  ///
  /// In en, this message translates to:
  /// **'First Name'**
  String get firstName;

  /// No description provided for @lastName.
  ///
  /// In en, this message translates to:
  /// **'Last Name'**
  String get lastName;

  /// No description provided for @searchHint.
  ///
  /// In en, this message translates to:
  /// **'Search destination...'**
  String get searchHint;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @bookings.
  ///
  /// In en, this message translates to:
  /// **'Bookings'**
  String get bookings;

  /// No description provided for @favorites.
  ///
  /// In en, this message translates to:
  /// **'Favorites'**
  String get favorites;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @dashboard.
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get dashboard;

  /// No description provided for @theme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get theme;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @darkMode.
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get darkMode;

  /// No description provided for @lightMode.
  ///
  /// In en, this message translates to:
  /// **'Light Mode'**
  String get lightMode;

  /// No description provided for @systemDefault.
  ///
  /// In en, this message translates to:
  /// **'System Default'**
  String get systemDefault;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Log Out'**
  String get logout;

  /// No description provided for @bookNow.
  ///
  /// In en, this message translates to:
  /// **'Book Now'**
  String get bookNow;

  /// No description provided for @pricePerMonth.
  ///
  /// In en, this message translates to:
  /// **'/mo'**
  String get pricePerMonth;

  /// No description provided for @bathrooms.
  ///
  /// In en, this message translates to:
  /// **'Baths'**
  String get bathrooms;

  /// No description provided for @wifi.
  ///
  /// In en, this message translates to:
  /// **'Wifi'**
  String get wifi;

  /// No description provided for @kitchen.
  ///
  /// In en, this message translates to:
  /// **'Kitchen'**
  String get kitchen;

  /// No description provided for @description.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get description;

  /// No description provided for @facilities.
  ///
  /// In en, this message translates to:
  /// **'Facilities'**
  String get facilities;

  /// No description provided for @totalPrice.
  ///
  /// In en, this message translates to:
  /// **'Total Price'**
  String get totalPrice;

  /// No description provided for @available.
  ///
  /// In en, this message translates to:
  /// **'Available Now'**
  String get available;

  /// No description provided for @rented.
  ///
  /// In en, this message translates to:
  /// **'Rented'**
  String get rented;

  /// No description provided for @unavailable.
  ///
  /// In en, this message translates to:
  /// **'Unavailable'**
  String get unavailable;

  /// No description provided for @currency.
  ///
  /// In en, this message translates to:
  /// **'Currency'**
  String get currency;

  /// No description provided for @changeLanguage.
  ///
  /// In en, this message translates to:
  /// **'Change Language'**
  String get changeLanguage;

  /// No description provided for @introWelcomeTitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome to\nDreamStay'**
  String get introWelcomeTitle;

  /// No description provided for @introWelcomeDesc.
  ///
  /// In en, this message translates to:
  /// **'Experience the easiest way to find and book your perfect home.'**
  String get introWelcomeDesc;

  /// No description provided for @introSlideToStartButton.
  ///
  /// In en, this message translates to:
  /// **'Slide to Start'**
  String get introSlideToStartButton;

  /// No description provided for @introSmartBookingTitle.
  ///
  /// In en, this message translates to:
  /// **'Smart\nBooking'**
  String get introSmartBookingTitle;

  /// No description provided for @introSmartBookingDesc.
  ///
  /// In en, this message translates to:
  /// **'Manage your stays, payments, and contracts all in one secure place.'**
  String get introSmartBookingDesc;

  /// No description provided for @introSlideToNextButton.
  ///
  /// In en, this message translates to:
  /// **'Slide to Next'**
  String get introSlideToNextButton;

  /// No description provided for @introReadyToMoveInTitle.
  ///
  /// In en, this message translates to:
  /// **'Ready to\nMove In?'**
  String get introReadyToMoveInTitle;

  /// No description provided for @introReadyToMoveInDesc.
  ///
  /// In en, this message translates to:
  /// **'Thousands of verified apartments are waiting for you.'**
  String get introReadyToMoveInDesc;

  /// No description provided for @introSlideToLoginButton.
  ///
  /// In en, this message translates to:
  /// **'Slide to Login'**
  String get introSlideToLoginButton;

  /// No description provided for @skipButton.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skipButton;

  /// No description provided for @englishLanguage.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get englishLanguage;

  /// No description provided for @arabicLanguage.
  ///
  /// In en, this message translates to:
  /// **'العربية'**
  String get arabicLanguage;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @manageYourAlerts.
  ///
  /// In en, this message translates to:
  /// **'Manage your alerts'**
  String get manageYourAlerts;

  /// No description provided for @versionInfo.
  ///
  /// In en, this message translates to:
  /// **'Version 1.0.0'**
  String get versionInfo;

  /// No description provided for @guestUser.
  ///
  /// In en, this message translates to:
  /// **'Guest User'**
  String get guestUser;

  /// No description provided for @myBookings.
  ///
  /// In en, this message translates to:
  /// **'My Bookings'**
  String get myBookings;

  /// No description provided for @ownerDashboard.
  ///
  /// In en, this message translates to:
  /// **'Owner Dashboard'**
  String get ownerDashboard;

  /// No description provided for @startDate.
  ///
  /// In en, this message translates to:
  /// **'Start Date'**
  String get startDate;

  /// No description provided for @endDate.
  ///
  /// In en, this message translates to:
  /// **'End Date'**
  String get endDate;

  /// No description provided for @filters.
  ///
  /// In en, this message translates to:
  /// **'Filters'**
  String get filters;

  /// No description provided for @reset.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get reset;

  /// No description provided for @dates.
  ///
  /// In en, this message translates to:
  /// **'Dates'**
  String get dates;

  /// No description provided for @rooms.
  ///
  /// In en, this message translates to:
  /// **'Rooms'**
  String get rooms;

  /// No description provided for @fivePlusRooms.
  ///
  /// In en, this message translates to:
  /// **'5+'**
  String get fivePlusRooms;

  /// No description provided for @location.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get location;

  /// No description provided for @priceRangeMonthly.
  ///
  /// In en, this message translates to:
  /// **'Price Range (Monthly)'**
  String get priceRangeMonthly;

  /// No description provided for @showResults.
  ///
  /// In en, this message translates to:
  /// **'Show Results'**
  String get showResults;

  /// No description provided for @somethingWentWrong.
  ///
  /// In en, this message translates to:
  /// **'Oops! Something went wrong.'**
  String get somethingWentWrong;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @noApartmentsFound.
  ///
  /// In en, this message translates to:
  /// **'No apartments found.'**
  String get noApartmentsFound;

  /// No description provided for @searchResults.
  ///
  /// In en, this message translates to:
  /// **'Search Results'**
  String get searchResults;

  /// No description provided for @foundProperties.
  ///
  /// In en, this message translates to:
  /// **'Found {count} properties'**
  String foundProperties(Object count);

  /// No description provided for @noApartmentsFoundFilters.
  ///
  /// In en, this message translates to:
  /// **'No apartments found matching your filters.'**
  String get noApartmentsFoundFilters;

  /// No description provided for @adjustFilters.
  ///
  /// In en, this message translates to:
  /// **'Adjust Filters'**
  String get adjustFilters;

  /// No description provided for @roomsCount.
  ///
  /// In en, this message translates to:
  /// **'{count} Rooms'**
  String roomsCount(Object count);

  /// No description provided for @oneBath.
  ///
  /// In en, this message translates to:
  /// **'1 Bath'**
  String get oneBath;

  /// No description provided for @currentlyUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Currently Unavailable'**
  String get currentlyUnavailable;

  /// No description provided for @price.
  ///
  /// In en, this message translates to:
  /// **'Price'**
  String get price;

  /// No description provided for @notAvailable.
  ///
  /// In en, this message translates to:
  /// **'Not Available'**
  String get notAvailable;

  /// No description provided for @welcomeBackUser.
  ///
  /// In en, this message translates to:
  /// **'Welcome Back {firstName}'**
  String welcomeBackUser(Object firstName);

  /// No description provided for @checkInputFields.
  ///
  /// In en, this message translates to:
  /// **'Please check your input fields'**
  String get checkInputFields;

  /// No description provided for @accountPendingApproval.
  ///
  /// In en, this message translates to:
  /// **'Your account is pending admin approval.'**
  String get accountPendingApproval;

  /// No description provided for @loginToContinue.
  ///
  /// In en, this message translates to:
  /// **'Login to continue'**
  String get loginToContinue;

  /// No description provided for @phoneHint.
  ///
  /// In en, this message translates to:
  /// **'09xxxxxxxx'**
  String get phoneHint;

  /// No description provided for @countryCode.
  ///
  /// In en, this message translates to:
  /// **'+963'**
  String get countryCode;

  /// No description provided for @passwordHint.
  ///
  /// In en, this message translates to:
  /// **'••••••••'**
  String get passwordHint;

  /// No description provided for @featureComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Feature coming soon!'**
  String get featureComingSoon;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password?'**
  String get forgotPassword;

  /// No description provided for @noAccountPrompt.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account? '**
  String get noAccountPrompt;

  /// No description provided for @signUp.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get signUp;

  /// No description provided for @takePhoto.
  ///
  /// In en, this message translates to:
  /// **'Take a photo'**
  String get takePhoto;

  /// No description provided for @chooseFromGallery.
  ///
  /// In en, this message translates to:
  /// **'Choose from gallery'**
  String get chooseFromGallery;

  /// No description provided for @failedToPickImage.
  ///
  /// In en, this message translates to:
  /// **'Failed to pick image'**
  String get failedToPickImage;

  /// No description provided for @uploadProfilePhoto.
  ///
  /// In en, this message translates to:
  /// **'Please upload a profile photo'**
  String get uploadProfilePhoto;

  /// No description provided for @uploadIdPhoto.
  ///
  /// In en, this message translates to:
  /// **'Please upload an ID photo'**
  String get uploadIdPhoto;

  /// No description provided for @accountCreatedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Account Created Successfully!'**
  String get accountCreatedSuccessfully;

  /// No description provided for @joinCommunity.
  ///
  /// In en, this message translates to:
  /// **'Join our community today.'**
  String get joinCommunity;

  /// No description provided for @tenant.
  ///
  /// In en, this message translates to:
  /// **'Tenant'**
  String get tenant;

  /// No description provided for @investor.
  ///
  /// In en, this message translates to:
  /// **'Investor'**
  String get investor;

  /// No description provided for @firstNameHint.
  ///
  /// In en, this message translates to:
  /// **'John'**
  String get firstNameHint;

  /// No description provided for @lastNameHint.
  ///
  /// In en, this message translates to:
  /// **'Doe'**
  String get lastNameHint;

  /// No description provided for @dateOfBirth.
  ///
  /// In en, this message translates to:
  /// **'Date of Birth'**
  String get dateOfBirth;

  /// No description provided for @dateOfBirthHint.
  ///
  /// In en, this message translates to:
  /// **'YYYY-MM-DD'**
  String get dateOfBirthHint;

  /// No description provided for @verificationDocument.
  ///
  /// In en, this message translates to:
  /// **'Verification Document'**
  String get verificationDocument;

  /// No description provided for @chooseFromFiles.
  ///
  /// In en, this message translates to:
  /// **'Choose from files'**
  String get chooseFromFiles;

  /// No description provided for @failedToPickDocument.
  ///
  /// In en, this message translates to:
  /// **'Failed to pick document'**
  String get failedToPickDocument;

  /// No description provided for @pdfDocumentSelected.
  ///
  /// In en, this message translates to:
  /// **'PDF Document Selected'**
  String get pdfDocumentSelected;

  /// No description provided for @idCardSelected.
  ///
  /// In en, this message translates to:
  /// **'ID Card Selected'**
  String get idCardSelected;

  /// No description provided for @tapToChange.
  ///
  /// In en, this message translates to:
  /// **'Tap to change'**
  String get tapToChange;

  /// No description provided for @uploadIdCard.
  ///
  /// In en, this message translates to:
  /// **'Upload ID Card'**
  String get uploadIdCard;

  /// No description provided for @pngJpgPdf.
  ///
  /// In en, this message translates to:
  /// **'PNG, JPG or PDF'**
  String get pngJpgPdf;

  /// No description provided for @agreeToThe.
  ///
  /// In en, this message translates to:
  /// **'I agree to the '**
  String get agreeToThe;

  /// No description provided for @termsOfService.
  ///
  /// In en, this message translates to:
  /// **'Terms of Service'**
  String get termsOfService;

  /// No description provided for @and.
  ///
  /// In en, this message translates to:
  /// **' and '**
  String get and;

  /// No description provided for @privacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicy;

  /// No description provided for @alreadyHaveAccountPrompt.
  ///
  /// In en, this message translates to:
  /// **'Already have an account? '**
  String get alreadyHaveAccountPrompt;

  /// No description provided for @bookingDetails.
  ///
  /// In en, this message translates to:
  /// **'Booking Details'**
  String get bookingDetails;

  /// No description provided for @selectDates.
  ///
  /// In en, this message translates to:
  /// **'Select Dates'**
  String get selectDates;

  /// No description provided for @paymentMethod.
  ///
  /// In en, this message translates to:
  /// **'Payment Method'**
  String get paymentMethod;

  /// No description provided for @visa.
  ///
  /// In en, this message translates to:
  /// **'Visa'**
  String get visa;

  /// No description provided for @mastercard.
  ///
  /// In en, this message translates to:
  /// **'MasterCard'**
  String get mastercard;

  /// No description provided for @shamCash.
  ///
  /// In en, this message translates to:
  /// **'Sham Cash'**
  String get shamCash;

  /// No description provided for @cash.
  ///
  /// In en, this message translates to:
  /// **'Cash'**
  String get cash;

  /// No description provided for @confirmBooking.
  ///
  /// In en, this message translates to:
  /// **'Confirm Booking'**
  String get confirmBooking;

  /// No description provided for @bookingConfirmed.
  ///
  /// In en, this message translates to:
  /// **'Booking Confirmed Successfully'**
  String get bookingConfirmed;

  /// No description provided for @noBookings.
  ///
  /// In en, this message translates to:
  /// **'No bookings found'**
  String get noBookings;

  /// No description provided for @apartment.
  ///
  /// In en, this message translates to:
  /// **'Apartment'**
  String get apartment;

  /// No description provided for @status.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get status;

  /// No description provided for @modify.
  ///
  /// In en, this message translates to:
  /// **'Modify'**
  String get modify;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @checkOut.
  ///
  /// In en, this message translates to:
  /// **'Check Out'**
  String get checkOut;

  /// No description provided for @rateStay.
  ///
  /// In en, this message translates to:
  /// **'Rate Stay'**
  String get rateStay;

  /// No description provided for @submitRating.
  ///
  /// In en, this message translates to:
  /// **'Submit Rating'**
  String get submitRating;

  /// No description provided for @ratingSubmitted.
  ///
  /// In en, this message translates to:
  /// **'Rating Submitted'**
  String get ratingSubmitted;

  /// No description provided for @bookingCancelled.
  ///
  /// In en, this message translates to:
  /// **'Booking Cancelled'**
  String get bookingCancelled;

  /// No description provided for @updateRequestSent.
  ///
  /// In en, this message translates to:
  /// **'Update Request Sent'**
  String get updateRequestSent;

  /// No description provided for @modifyBooking.
  ///
  /// In en, this message translates to:
  /// **'Modify Booking'**
  String get modifyBooking;

  /// No description provided for @saveChanges.
  ///
  /// In en, this message translates to:
  /// **'Save Changes'**
  String get saveChanges;

  /// No description provided for @pending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get pending;

  /// No description provided for @confirmed.
  ///
  /// In en, this message translates to:
  /// **'Confirmed'**
  String get confirmed;

  /// No description provided for @rejected.
  ///
  /// In en, this message translates to:
  /// **'Rejected'**
  String get rejected;

  /// No description provided for @cancelled.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get cancelled;

  /// No description provided for @completed.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get completed;

  /// No description provided for @bookingRequests.
  ///
  /// In en, this message translates to:
  /// **'Booking Requests'**
  String get bookingRequests;

  /// No description provided for @myProperties.
  ///
  /// In en, this message translates to:
  /// **'My Properties'**
  String get myProperties;

  /// No description provided for @addProperty.
  ///
  /// In en, this message translates to:
  /// **'Add Property'**
  String get addProperty;

  /// No description provided for @editProperty.
  ///
  /// In en, this message translates to:
  /// **'Edit Property'**
  String get editProperty;

  /// No description provided for @deleteProperty.
  ///
  /// In en, this message translates to:
  /// **'Delete Property'**
  String get deleteProperty;

  /// No description provided for @deleteConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this property?'**
  String get deleteConfirm;

  /// No description provided for @earnings.
  ///
  /// In en, this message translates to:
  /// **'Total Earnings'**
  String get earnings;

  /// No description provided for @accept.
  ///
  /// In en, this message translates to:
  /// **'Accept'**
  String get accept;

  /// No description provided for @reject.
  ///
  /// In en, this message translates to:
  /// **'Reject'**
  String get reject;

  /// No description provided for @noRequests.
  ///
  /// In en, this message translates to:
  /// **'No pending booking requests'**
  String get noRequests;

  /// No description provided for @noProperties.
  ///
  /// In en, this message translates to:
  /// **'You haven\'t listed any properties yet'**
  String get noProperties;

  /// No description provided for @propertyTitle.
  ///
  /// In en, this message translates to:
  /// **'Property Title'**
  String get propertyTitle;

  /// No description provided for @propertyDesc.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get propertyDesc;

  /// No description provided for @propertyAddress.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get propertyAddress;

  /// No description provided for @priceUsd.
  ///
  /// In en, this message translates to:
  /// **'Price (USD)'**
  String get priceUsd;

  /// No description provided for @uploadImages.
  ///
  /// In en, this message translates to:
  /// **'Upload Images'**
  String get uploadImages;

  /// No description provided for @saveProperty.
  ///
  /// In en, this message translates to:
  /// **'Save Property'**
  String get saveProperty;

  /// No description provided for @createProperty.
  ///
  /// In en, this message translates to:
  /// **'Create Property'**
  String get createProperty;

  /// No description provided for @fieldRequired.
  ///
  /// In en, this message translates to:
  /// **'This field is required'**
  String get fieldRequired;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
