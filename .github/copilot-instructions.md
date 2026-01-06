# AI Coding Agent Instructions - Job App

## Project Overview
**Type**: Full-stack mobile application (Flutter) with Laravel API backend  
**Structure**: Monorepo with `/lib` (Flutter), `/api` (Laravel), `/android`, `/ios`  
**Key Tech**: GetX state management, Repository pattern, SharedPreferences token storage  
**User Types**: HRD (HR managers posting jobs) and Jobseekers (browsing & applying)

## Architecture Patterns

### Flutter (Mobile Client)
- **State Management**: GetX with `GetxController` base class
- **Navigation**: GetX Named Routes (`Get.toNamed()`, `Get.offAll()`)
- **Token Management**: SharedPreferences for JWT storage + AuthRepository helper methods
- **Structure**: Feature-based folder layout
  - `/features/{feature_name}/controllers/` - Business logic (GetX controllers)
  - `/features/{feature_name}/screen/` - UI screens
  - `/data/repositories/` - Data layer (API calls + token persistence)
  - `/data/models/` - Data models with `fromJson()` constructors
  - `/constants/` - Enums (AuthMethod, JobType) and configs (ApiConstants, colors)
  - `/common/styles/` - Reusable widgets and theme components

### Laravel API
- **Routes**: RESTful API under `/api` prefix
- **Auth Routes**: `/api/hrd/*` namespace for HRD (HR) authentication
- **Controllers**: Service layer in `app/Http/Controllers/Api/`
- **Current Endpoints**:
  - `POST /api/hrd/register` - HRD registration (returns user_id, email, role)
  - `POST /api/hrd/login` - HRD login (validate email/password)
  - `POST /api/hrd/google-login` - Google OAuth (id_token exchange)
  - `GET /api/jobs` - Fetch all jobs (public, no auth)

## Critical Conventions

### GetX Controller Lifecycle
```dart
class HrdLoginController extends GetxController {
  final RxBool isLoading = false.obs;  // Observable state
  final TextEditingController email = TextEditingController();
  
  @override
  void onInit() { _googleSignIn = GoogleSignIn(...); super.onInit(); }
  
  @override
  void onClose() { email.dispose(); super.onClose(); }
}
```
- Always initialize complex objects in `onInit()`, dispose in `onClose()`
- Use `.obs` suffix for reactive variables
- Bind controllers in route definitions: `Get.lazyPut(() => Controller())`

### Repository Pattern (Data Layer)
- Repositories handle all HTTP calls and response parsing
- Return `Map<String, dynamic>` with `{'success': bool, 'message': String, 'data': dynamic, 'errors': dynamic}`
- Timeout: 20 seconds for auth operations, 10 seconds for others
- Token management via AuthRepository helpers (see below)
- Example: [auth_repository_hrd.dart](lib/data/repositories/auth_repository_hrd.dart)

### Token & Session Management
AuthRepository provides persistent token storage via SharedPreferences:
```dart
// After successful login, save token
await _repository.saveToken(responseData['token']);

// Before API calls requiring auth, retrieve token
String? token = await _repository.getToken();

// Check if user still logged in
bool loggedIn = await _repository.isLoggedIn();

// On logout, clear all session data
await _repository.logout();  // Removes token, email, name, company_id
```
- **Key Methods**: `saveToken()`, `getToken()`, `clearToken()`, `isLoggedIn()`, `saveUserData()`, `getUserData()`, `logout()`
- **Storage Keys**: `hrd_token`, `hrd_email`, `hrd_name`, `hrd_company_id`
- **Pattern**: Always check `isLoggedIn()` before showing HRD dashboard, redirect to login if false

### Screen Navigation
- Use `Get.offAll()` to replace entire stack (login → dashboard)
- Use `Get.toNamed()` for pushing new route
- Define static route IDs: `static const String id = '/screen_id'`
- Delay snackbars after `Get.offAll()`: `await Future.delayed(Duration(milliseconds: 300))`

### Form Validation
- Use `GlobalKey<FormState>` + `TextFormField` validators
- Password requirements: min 8 chars, must contain number
- Always stop loading BEFORE navigation in success cases

## Build & Run Commands

### Flutter
```bash
# Clean and rebuild
flutter clean
flutter pub get
flutter run

# Run on specific device
flutter run -d <device_id>

# Build APK
flutter build apk --release
```

### Laravel API
```bash
# From /api directory
php artisan migrate
php artisan serve --host 0.0.0.0 --port 8080

# Run tests
php artisan test
```

## Known Issues & Fixes

### Google Sign-In
- **Issue**: Using `signOut()` in `onClose()` causes freezes
- **Fix**: Comment out `_googleSignIn.signOut()`, let OS handle cleanup
- **Status**: Google OAuth register/login not yet fully implemented

### Loading State Management
- **Pattern**: Stop loading (`isLoading.value = false`) BEFORE navigation
- **Reason**: Prevents dialog/overlay conflicts during route transitions
- **Anti-pattern**: Setting loading=false in finally block after navigation

### API Base URL
- **Local Dev**: `http://192.168.18.12:8080/api` (see [api_constants.dart](lib/constants/api_constants.dart))
- **Change Required**: Update when deploying to production/staging

## Testing Patterns

### Authentication Flow
1. Validate form fields
2. Call repository method (handles HTTP)
3. Check response success flag
4. Stop loading BEFORE navigation
5. Show snackbar with appropriate message
6. Navigate on success, show error snackbar on failure

### Data Models
- All models use `Map<String, dynamic>` constructor parameter
- Implement `fromJson()` static factory method
- Example: JobModel in [lib/data/models/](lib/data/models/)

## Common Development Tasks

### Adding a New API Endpoint
1. Define route in `/api/routes/api.php` (RESTful: `/hrd/resource` or `/resource`)
2. Create controller method in `/api/app/Http/Controllers/Api/`
3. Add repository method that: calls `http.post/get()`, handles timeout, returns standard response format
4. Create GetX controller with state management (`RxBool isLoading`, `RxList<Model> data`)
5. Bind controller in `main.dart` routes
6. Build UI screen and call controller methods on user actions

### Adding Protected API Endpoint (Requires Auth)
1. Include token in request headers: `headers: {'Authorization': 'Bearer $token'}`
2. Retrieve token: `String? token = await _repository.getToken();`
3. Validate token exists before API call, show error if missing
4. Laravel middleware on backend: `middleware('auth:sanctum')` to validate JWT

### Authentication Method Enum (AuthMethod)
- **emailPassword**: Standard email/password registration & login
- **google**: Google Sign-In OAuth flow (id_token sent to backend)
- Located in [constants/enums.dart](lib/constants/enums.dart) - use when building multi-method auth controllers

## Code Style Notes

- **Comments**: Use `// ================= SECTION =================` headers
- **Language**: Mix Indonesian/English (follow existing conventions)
- **UI Framework**: Material Design, custom colors in [colors.dart](lib/constants/colors.dart)
- **Icons**: Iconsax & Ionicons packages (avoid MaterialIcons when custom available)

## Cross-Component Communication

### HRD (HR Manager) Flow
1. **Register/Login**: HrdSignupController / HrdLoginController → AuthRepository → `/api/hrd/register` or `/api/hrd/login`
2. **Save Session**: AuthRepository saves token + user data to SharedPreferences
3. **Dashboard**: HrdHomeScreen loads (check `isLoggedIn()` first via auth guard)
4. **Post Job**: HrdJobformController → JobRepository → `/api/hrd/jobs/store`
5. **Logout**: Clear all SharedPreferences via `repository.logout()` → back to HrdLoginScreen

### Jobseeker Flow
1. **Browse Jobs**: HomeScreen → JobRepository → `/api/jobs` (public, no auth)
2. **Job Detail**: Select job → JobRepository → `/api/jobs/{id}`
3. **Apply**: [TO BE IMPLEMENTED] ApplicationRepository → user authentication required
4. **User Dashboard**: [TO BE IMPLEMENTED] View applications, saved jobs

### Key Integration Points
- **Navigation Binding**: Controllers bound to routes in [main.dart](lib/main.dart) - check before creating new controllers
- **Repository Injection**: Controllers instantiate repositories directly (no dependency injection framework)
- **Error Handling**: All repositories return `{'success': bool}` flag - controllers check this before navigation
- **API Base URL**: Centralized in [api_constants.dart](lib/constants/api_constants.dart) - update for different environments

## File Structure Reference
```
lib/
├── features/
│   ├── authentications/
│   │   ├── controllers/    ← Business logic
│   │   └── screen/         ← UI
│   ├── hrd_dashboard/
│   └── user_dashboard/
├── data/
│   ├── repositories/       ← API layer
│   ├── models/             ← Data models
│   └── datasources/        ← (placeholder)
└── constants/              ← Enums, configs

api/
├── routes/api.php          ← Route definitions
├── app/Http/Controllers/Api/ ← Handlers
└── database/migrations/    ← Schema
```
