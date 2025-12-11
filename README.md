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
    Step 2: The Git Commands

Open your terminal in the project folder and run these commands one by one.

1. Initialize Git
   code
   Bash
   download
   content_copy
   expand_less
   git init
2. Verify .gitignore

Flutter creates this by default. Ensure it exists so you don't upload junk files.

code
Bash
download
content_copy
expand_less

# Just checks if file exists (Windows/Mac/Linux friendly)

ls -la .gitignore 3. Stage All Files
code
Bash
download
content_copy
expand_less
git add . 4. The First Commit

This is the formal message for your first upload.

code
Bash
download
content_copy
expand_less
git commit -m "feat: Initial commit. Setup Clean Architecture, Core Layer, and Auth Feature (Domain/Data/Cubit)." 5. Rename Branch to Main (Standard)
code
Bash
download
content_copy
expand_less
git branch -M main
Step 3: Link to GitHub (or GitLab)

Go to GitHub.com and create a New Repository.

Name: residential_booking_app

Public/Private: (Your choice).

Do NOT initialize with README or .gitignore (we already have them).

Copy the URL they give you (e.g., https://github.com/YourName/residential_booking_app.git).

Run these commands in your terminal:

code
Bash
download
content_copy
expand_less

# Replace <YOUR_URL> with the link you copied

git remote add origin <YOUR_URL>

# Push the code

git push -u origin main
✅ You are now Live.

Your project is safe, version-controlled, and professionally documented. Ready for the next feature?
