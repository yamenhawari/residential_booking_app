Residential Apartment Booking App

A comprehensive mobile application for booking residential apartments. This application connects Tenants with Owners to facilitate property booking, management, and review.

## 🏗 Architecture

This project follows strict **Clean Architecture** principles to ensure scalability, testability, and separation of concerns.

**Structure:**
`lib/`
├── `core/` (Failures, Exceptions, Network Info, API Constants, Resources)
└── `features/`
└── `auth/`
├── `domain/` (Pure Business Logic: Entities, UseCases, Repo Contracts)
├── `data/` (API Implementation, Models, Local Storage)
└── `presentation/` (BLoC/Cubit, UI)

## 🛠 Tech Stack

- **Framework:** Flutter & Dart
- **State Management:** Flutter BLoC (Cubit)
- **Architecture:** Clean Architecture
- **Functional Programming:** Dartz (Either, Unit)
- **Networking:** Http
- **Local Storage:** Hive
- **Equality:** Equatable

## 🚀 Completed Features (Current Phase)

### 1. Core Layer

- Centralized Error Handling (Failures/Exceptions).
- Network Connectivity Checks.
- Resource Management (Strings, API Endpoints).

### 2. Authentication Feature

- **Domain Layer:**
  - Entities with strict Enum support (`UserRole`, `UserStatus`).
  - UseCases: `Login`, `Register`, `VerifyOtp`, `Logout`, `GetCurrentUser`.
- **Data Layer:**
  - `RemoteDataSource`: Handles API communication and JSON serialization.
  - `LocalDataSource`: Handles caching User/Token via Hive.
  - `Repository`: Coordinates data and handles "Remember Me" logic.
- **State Management:**
  - `AuthCubit`: Manages authentication states (Loading, Success, Error) without mixing UI logic.