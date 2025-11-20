
# Very Good Coffee from Peter

Very Good Coffee from Peter is a Flutter application that fetches and displays random coffee images from a remote API. Users can browse, view, and save their favorite coffee images locally within the app.

The app uses the Cubit state management pattern (from the `flutter_bloc` package) to handle UI state, business logic, and asynchronous operations in a predictable and testable way.

## Navigation with GoRouter

Navigation is handled by the [go_router](https://pub.dev/packages/go_router) package, which provides declarative and type-safe routing. All navigation logic and route definitions are centralized in `lib/app_router/`, using named routes and typed parameters for maintainability. The bottom navigation bar and screen transitions are managed by GoRouter, making it easy to add or change routes as the app evolves.

## Main features

- **Random Coffee**: View a new random coffee image at the tap of a button.
- **Favorites**: Save your favorite coffee images locally and access them anytime.
- **Offline support**: Access your saved favorites even without an internet connection.
- **Image download**: Download coffee images to your device.
- **Connectivity feedback**: The app notifies you if you lose internet connection.

### App screens

1. **Splash Screen**: Briefly shown while the app initializes.
2. **Random Coffee Screen**: Displays a random coffee image, with options to save as favorite or download.
3. **Favorites Screen**: Shows a gallery of all coffee images you've saved locally.
4. **Home/Navigation**: Bottom navigation bar to switch between Random and Favorites screens.

## Main dependencies and packages

This project uses the following main packages:

- **flutter_bloc**: State management using Cubit and Bloc patterns.
- **equatable**: Simplifies value equality for Dart objects, used in state classes.
- **http**: For making HTTP requests to fetch coffee images.
- **connectivity_plus**: Detects network connectivity changes.
- **path_provider**: Accesses device file system paths for saving images.
- **image_downloader**: Handles image downloads to the device.
- **very_good_analysis**: Lint rules and static analysis for code quality.

Internal packages in the `packages/` directory:
- **random_coffee_repository**: Fetches random coffee images from the API.
- **favorited_images_repository**: Manages local storage of favorite images.
- **http_client**: Custom HTTP abstraction and error handling.
- **local_image_client**: Handles local image operations.
- **image_download_service**: Service for downloading images.
- **vgcfp_core**: Shared utilities and core logic.
- **vgcfp_ui**: Shared UI components and themes.
## Project structure and architecture

This repository uses a modular architecture, separating the main application from reusable packages:

- `lib/`: Contains the main Flutter app code, including UI, routing, configuration, and feature modules (e.g., random coffees, favorites).
- `packages/`: Houses independent Dart/Flutter packages, each with its own logic and responsibilities. These are designed for reuse and testability, and can be published or used in other projects. Notable packages include:
	- `random_coffee_repository`: Fetches random coffee images from a remote API.
	- `favorited_images_repository`: Manages local storage of favorite coffee images.
	- `http_client`: Provides a wrapper for HTTP requests and error handling.
	- `local_image_client`, `image_download_service`, `vgcfp_core`, `vgcfp_ui`: Utilities, UI components, and shared logic.

This separation allows for better code organization, easier testing, and the ability to evolve or replace features independently. The main app (`lib/`) wires together these packages and provides the user interface.

## Requirements
- Flutter 3.22.0 or newer
- Dart 3.9.2 or newer

## Project setup

Install dependencies:

```sh
flutter pub get
```

## Environment folder setup


Create an `env/` directory in the project root and add a file inside it (for example `env/configs.txt`) containing a JSON object with your base URL. Example:

```json
{
  "RANDOM_COFFEE_API_BASE_URL": "https://fictional.coffee.api/v1/random"
}
```

This keeps the API URL in a single place that you can reuse across commands.

## How the app reads the base URL

`AppConfig.randomCoffeeApiUri` parses the `RANDOM_COFFEE_API_BASE_URL` value supplied at build time via `String.fromEnvironment`. If the define is missing, the getter throws a `StateError`, making the failure obvious during startup. The resulting `Uri` is injected into `RandomCoffeeRemoteRepositoryImpl` when the app boots in `lib/app/app.dart`.

## Running with `--dart-define`

The app relies on the `RANDOM_COFFEE_API_BASE_URL` environment variable provided via `--dart-define` to resolve the random coffee API base URL.

Run the app with the desired URL (example using the current public API):

```sh
flutter run --dart-define=RANDOM_COFFEE_API_BASE_URL=https://coffee.alexflipnote.dev/random.json
```

Repeat the same `--dart-define` for tests or other Flutter commands, for example:

```sh
flutter test --dart-define=RANDOM_COFFEE_API_BASE_URL=https://coffee.alexflipnote.dev/random.json
```

If you use a different API, replace the URL with an endpoint that returns JSON compatible with the `RandomCoffeePayload` model. Alternatively, pass all defines at once with:

```sh
flutter run --dart-define-from-file=env/configs.txt
```

## VS Code launch configuration

You can trigger the same setup from VS Code by adding the following entry to `.vscode/launch.json`:

```jsonc
{
	"name": "very_good_coffee_from_peter (env configs)",
	"request": "launch",
	"type": "dart",
	"toolArgs": [
		"--dart-define-from-file=env/configs.txt"
	]
}
```

This loads every key/value pair declared in `env/configs.txt` and forwards them as `--dart-define` arguments to `flutter run`.

## Android Studio run configuration

1. Open **Run ▸ Edit Configurations…**.
2. Select your Flutter run configuration (or create a new one based on *Flutter*).
3. In the **Additional run args** (or **Additional run arguments**) field, add:

   ```
   --dart-define-from-file=env/configs.txt
   ```

4. Apply and run. Android Studio will forward this argument to `flutter run`, and the Flutter tool will load all environment variables from your JSON file at startup.

> **Note:** Android Studio does not process or parse `env/configs.txt` itself. It only passes the argument to Flutter, which must be version 3.17 or newer to support `--dart-define-from-file`.
