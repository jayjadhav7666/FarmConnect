# FarmConnect

FarmConnect is a Flutter-based application designed to streamline farmer registration and manage digital agriculture data effectively. It features a modern, clean UI and robust architecture to ensure a seamless user experience.

## Features

*   **Farmer Registration Wizard**: A Step-by-step generic application form (Stepper) for registering farmers.
    *   **Personal Info**: Name, Mobile number validation.
    *   **Location Services**:
        *   **PIN Code integration**: Auto-fills State, District, and Taluka based on the entered PIN code.
        *   **Geocoding**: Converts entered village address into GPS coordinates.
        *   **Distance Calculator**: Automatically calculates the distance from the farmer's location to the **Kalmeshwar APMC Market**.
    *   **Farm Details**: Crop selection, Acreage input, and Harvesting Date picker.
    *   **Confirmation**: Review all details before submission.
*   **Farmer Dashboard**: View a list of registered farmers.
*   **Offline Storage**: Uses **Hive** for persisting farmer data locally on the device.
*   **Clean Architecture**: Built using Domain-Driven Design (DDD) principles with separate Data, Domain, and Presentation layers.
*   **Dependency Injection**: Uses `get_it` for scalable service location.
*   **Responsive UI**: Optimized scrolling behavior and custom themed components.

## Architecture

The project follows **Clean Architecture** principles:

*   **Presentation Layer**: BLoC (State Management), Screens, Widgets.
*   **Domain Layer**: Entities, Use Cases, Repository Interfaces.
*   **Data Layer**: Models, Data Sources (Hive), Repository Implementations.

## Libraries Used

*   **flutter_bloc**: For predictable state management.
*   **get_it**: For Service Locator / Dependency Injection.
*   **hive & hive_flutter**: For fast, lightweight, NoSQL local storage.
*   **geolocator**: For location-related primitives.
*   **geocoding**: To convert addresses into coordinates (Lat/Long).
*   **intl**: For date formatting and internationalization.
*   **http**: For making network requests (used for PIN code API).
*   **equatable**: For value equality comparisons in BLoC states.

## Getting Started

### Prerequisites

*   Flutter SDK (Version 3.10.7 or higher)
*   Dart SDK
*   Android Studio / VS Code with Flutter extensions

### Installation

1.  **Clone the repository**:
    ```bash
    git clone https://github.com/your-repo/farmconnect.git
    cd farmconnect
    ```

2.  **Install Dependencies**:
    ```bash
    flutter pub get
    ```

3.  **Run the Application**:
    *   Connect your Android device or start an emulator.
    *   Run the command:
        ```bash
        flutter run
        ```

### Folder Structure

```
lib/
├── core/                # Core utilities, constants, theme, and failures
├── data/                # Data layer (Models, Repositories, Data Sources)
├── domain/              # Domain layer (Entities, Use Cases, Repository Interfaces)
├── presentation/        # UI layer (Screens, Widgets, BLoC)
├── injectable_init.dart # Dependency Injection setup
└── main.dart            # Entry point
```

## How to use

1.  Open the app to see the Dashboard.
2.  Click on **"Register"** to add a new farmer.
3.  Fill in the details in the stepper form.
    *   Enter a **PIN Code** to auto-populate location fields.
    *   Enter **Village** and other details.
    *   Click **"Distance: Calculate..."** to get the distance from the market.
4.  Review and Submit.
5.  Switch to the **"Farmers"** tab to see the list of registered farmers.
6.
 <img src="https://github.com/user-attachments/assets/1094822e-ec3d-47d0-a4af-b09693f45637"
     width="300" />

<img src="https://github.com/user-attachments/assets/c97bda03-bfa8-4565-8e7d-55c66fc30806"
     width="300" />

<img src="https://github.com/user-attachments/assets/3f417b9c-6bcb-4b9e-bc18-46912f7e6f82"
     width="300" />

