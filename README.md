🏠 DreamStay - Mobile Application

DreamStay is a modern, cross-platform residential booking application built with Flutter. It facilitates a seamless connection between tenants seeking accommodation and property owners managing their listings. The app is architected using Clean Architecture principles to ensure scalability, maintainability, and testability.

🌟 Key Features

Role-Based Access: Specialized interfaces for Tenants (booking/search) and Investors (property management).

Advanced Search: Filter properties by date range, price, location (Governorates), and room count.

Smart Booking System: Real-time availability checks, conflict prevention, and date modification requests.

Owner Dashboard: Dynamic earnings calculation, booking request management (Accept/Reject), and property lifecycle management (Activate/Force Delete).

Notification Center: In-app history and Push Notifications via Firebase Cloud Messaging (FCM).

Localization (i18n): Full support for 🇺🇸 English, 🇸🇦 Arabic, 🇫🇷 French, 🇩🇪 German, and 🇷🇺 Russian.

Offline Support: Local storage (Hive) for favorites and user session persistence.

🏗️ Architecture

This project strictly follows Clean Architecture separated into three layers:

lib/
├── core/ # Shared utilities, network client, routing, resources
├── features/ # Feature-based separation
│ ├── auth/ # Authentication (Login, Register, Token Sync)
│ ├── home/ # Browsing, Filtering, Apartment Details
│ ├── bookings/ # Booking logic, Reviews
│ ├── owner/ # Management Logic (CRUD, Requests, Earnings)
│ ├── notifications/ # Notification Logic
│ └── ...
└── main.dart # Dependency Injection & App Entry

⚙️ Prerequisites

Flutter SDK: 3.x.x or higher.

Dart SDK: 3.x.x or higher.

Backend: The Laravel API must be running.

🚀 Installation & Setup

Clone the Repository

git clone [https://github.com/yourusername/residential_booking_app_frontend.git](https://github.com/yourusername/residential_booking_app_frontend.git)
cd residential_booking_app_frontend

Install Dependencies

flutter pub get

⚠️ Important: API Configuration
Open lib/core/api/api_constants.dart and find the ip variable:

// CHANGE THIS to your machine's local IP address (e.g., 192.168.1.5:8000)
static const String ip = "YOUR_LOCAL_IP:8000";

⚠️ Important: Firebase Configuration

Android: Place google-services.json in android/app/.

iOS: Place GoogleService-Info.plist in ios/Runner/.

Run the App

flutter run

🛠 Tech Stack

State Management: flutter_bloc

Dependency Injection: get_it

Networking: dio / http

Local DB: hive

UI Components: flutter_screenutil, table_calendar
