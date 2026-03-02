# WorkBridge — Flutter App

**Your Career, Elevated** — A professional job portal app built with Flutter using Clean Architecture and Cubit state management.

## App Screens (16 Total)

### Authentication Flow
1. **Splash Screen** — Animated branding with progress dots
2. **Phone Entry** — 10-digit mobile number input with country code
3. **OTP Verification** — 6-digit OTP boxes with countdown timer
4. **Account Not Found** — Prompts new users to register

### Registration & Onboarding
5. **Register — Step 1/3** — Personal details (name, email, DOB, gender)
6. **Register — Step 2/3** — Professional info (title, experience, company, skills)
7. **Register — Step 3/3** — Job preferences (type, cities, salary, notice period)
8. **Profile Created!** — Success screen with profile card and stats

### Main App
9. **Home Feed** — Job recommendations, stats, filter chips, save/apply
10. **Job Detail** — Full description, skills, info chips, Apply Now
11. **Search** — Live search, trending topics, top companies
12. **Notifications** — Activity feed with color-coded alerts
13. **My Activity** — Applied jobs with timeline status tracker

### Profile
14. **Profile — Overview** — Header, stats, progress, settings menu
15. **Profile — Details** — Personal & professional info grid + skills
16. **Profile — Resume** — Upload zone, tips, visibility toggle, sign out

---

## Architecture: Clean Architecture

```
lib/
├── main.dart
├── app.dart
├── core/
│   ├── constants/        # AppColors, AppStrings, AppTextStyles
│   ├── di/               # Dependency injection (get_it)
│   ├── routes/           # GoRouter app router
│   └── theme/            # AppTheme (black & white professional)
└── features/
    ├── auth/
    │   ├── data/         # UserModel, AuthRepositoryImpl (mock)
    │   ├── domain/       # User entity, AuthRepository interface
    │   └── presentation/ # AuthCubit, AuthState, 4 screens
    ├── registration/
    │   ├── data/         # RegistrationRepositoryImpl (mock)
    │   ├── domain/       # RegistrationRepository interface
    │   └── presentation/ # RegistrationCubit, RegistrationState, 4 screens
    ├── home/
    │   ├── data/         # JobModel, JobRepositoryImpl (mock data)
    │   ├── domain/       # Job entity, JobRepository interface
    │   └── presentation/ # HomeCubit, HomeState, HomeScreen, JobDetailScreen
    ├── search/
    │   └── presentation/ # SearchCubit, SearchState, SearchScreen
    ├── notifications/
    │   └── presentation/ # NotificationsCubit, NotificationsState, NotificationsScreen
    ├── activity/
    │   └── presentation/ # ActivityCubit, ActivityState, ActivityScreen
    ├── profile/
    │   ├── data/         # ProfileRepositoryImpl (mock)
    │   ├── domain/       # ProfileRepository interface
    │   └── presentation/ # ProfileCubit, ProfileState, 4 screens (tab, overview, details, resume)
    └── main_app/
        └── views/        # MainTabScreen with bottom navigation
```

## Dependencies

| Package | Purpose |
|---|---|
| `flutter_bloc` | Cubit state management |
| `equatable` | Value equality for states |
| `go_router` | Declarative navigation |
| `get_it` | Dependency injection |
| `shared_preferences` | Local persistence |
| `dio` | HTTP client (for real API) |
| `cached_network_image` | Image caching |
| `intl` | Date formatting |
| `file_picker` | Resume upload |
| `permission_handler` | Storage permissions |

## Getting Started

```bash
# Get dependencies
flutter pub get

# Run the app
flutter run

# Build for release
flutter build apk --release
```

## Design System

- **Theme**: Black & White Professional
- **Primary**: `#0A0A0A` (near-black)
- **Background**: `#F5F5F5` (off-white)
- **Cards**: White with light grey border
- **Typography**: Inter font family

## State Management Pattern

Each feature follows this pattern:
```
Feature/
  presentation/
    cubit/
      feature_cubit.dart   ← Business logic, calls repository
      feature_state.dart   ← Equatable states (Initial, Loading, Loaded, Error)
    views/
      feature_screen.dart  ← BlocBuilder/BlocListener consuming cubit
```
