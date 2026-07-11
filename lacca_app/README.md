# LACA App — Tanzania's Logistics Super-App

**LACA** is a comprehensive logistics and delivery platform built with **Flutter**, designed to serve the Tanzanian market with package delivery, cargo clearing, vehicle import, agro-business, freight booking, shipment tracking, and fleet management — all in one app.

---

## Table of Contents

1. [Overview](#overview)
2. [Features](#features)
   - [Onboarding & Authentication](#1-onboarding--authentication)
   - [Home Dashboard](#2-home-dashboard)
   - [Send Package](#3-send-package)
   - [Schedule Transport](#4-schedule-transport)
   - [Import Car](#5-import-car)
   - [Cargo Clearing & Forwarding](#6-cargo-clearing--forwarding)
   - [Agro Business](#7-agro-business)
   - [Track Shipment](#8-track-shipment)
   - [My Vehicles](#9-my-vehicles)
   - [Bolt Ride Options](#10-bolt-ride-options)
   - [Orders](#11-orders)
   - [Business Tools (Become Inspector / IT Driver / Winga)](#12-business-tools-become-inspector--it-driver--winga)
   - [Inspectors Directory](#13-inspectors-directory)
   - [Cargo Inspection Companies](#14-cargo-inspection-companies)
   - [Profile & Account](#15-profile--account)
   - [Design System (Glassmorphism, Neumorphism, Bento UI)](#16-design-system)
3. [Navigation Structure](#navigation-structure)
4. [Tech Stack](#tech-stack)
5. [Project Structure](#project-structure)
6. [Setup & Installation](#setup--installation)
7. [Building APK](#building-apk)
8. [Credits](#credits)

---

## Overview

LACA is a multi-service logistics super-app that consolidates the following into a single platform:

- **Package Delivery** — Send packages anywhere in Tanzania with real-time tracking
- **Vehicle Import** — Import cars with tax calculators and savings wallets
- **Cargo Clearing & Forwarding** — Clear cargo via air, road, rail, or ocean
- **Agro Business** — Farm inputs, markets, and transport for agricultural produce
- **Freight Booking** — 3-step booking wizard for heavy cargo
- **Shipment Tracking** — Real-time fleet tracking with live maps
- **Fleet Management** — Manage your own vehicles with health dashboards
- **Ride Hailing** — Bolt-like ride booking with OSRM routing
- **Inspector Directory** — International inspectors for verifying overseas businesses
- **Cargo Inspection** — Tanzania-based cargo inspection companies
- **Business Registration** — Become an Inspector, IT Driver, or Winga (social media reseller)

---

## Features

### 1. Onboarding & Authentication

- **4-page onboarding carousel** covering Fast Delivery, Agro Business, Import & Cargo, and Growth & Success
- Full-screen image backgrounds with gradient overlays
- Animated dot indicators and skip/next buttons
- **Login screen** with email + password, remember me, forgot password, social login (Google & Apple)
- Simple tap-to-login flow (simulated for MVP)

### 2. Home Dashboard

- **Personalized greeting** with avatar, name, and activity snippet
- **3 stat cards**: Active, Processing, and Delivered with color-coded tints and chevrons
- **6-service grid** (2-column layout):
  - Send Package, Schedule Transport, Import Car, Cargo Clearing, Agro Business, Track Shipment
- Each card features **skeuomorphic icon containers** and **neumorphic press animations**
- **Recent Activity** feed with timestamped entries
- **Top-right menu**: Become Inspector, Become IT Driver, Become a Winga
- Bouncing scroll physics and smooth card animations

### 3. Send Package

- **Full-screen map** with Google Maps tiles + road/satellite toggle
- **User's real GPS location** obtained via `geolocator`
- **Free place search** via Nominatim (OpenStreetMap)
- **Route calculation** via OSRM routing API with distance and ETA
- **Draggable bottom sheet** (3 snap positions: 15% / 42% / 85%)
- **"Where are you going?"** search field with clear and my-location buttons
- **Saved Places** (Home, Work) with geocoding
- **History section** showing previously visited locations
- **Route polyline** displayed on the map from pickup → drop-off
- **"Continue to Book"** → Vehicle selection screen (Boda, Bajaji, Carry Truck, Town Hiace)

### 4. Schedule Transport

- Reuses the Send Package map + search pattern
- **Nominatim search** for destination + OSRM routing
- **Draggable sheet** with saved places, history, and booking button
- **"Continue to Book"** → Cargo Booking screen

### 5. Import Car

- **Kibubu Wallet**: Savings goal tracker with deposit input and quick amounts
- **Popular sources**: BE FORWARD, SBT Japan, Local Dealers
- **TRA Tax Calculator**:
  - Inputs: FOB value, freight, insurance
  - Dropdowns: vehicle age, engine CC
  - Calculates: Import Duty (25%), Excise Duty, VAT (18%), SDL (1.5%), IDF (0.6%)
- **Inspection Services**: Basic, Full Mechanical, Pre-Export

### 6. Cargo Clearing & Forwarding

- **4 transport modes** with gradient cards: Freight Booking (Air), Landing Booking (Road), Ocean Booking (Sea), Rail
- Each card shows icon, title, subtitle, description, price range, and booking button
- **Unified freight booking form** (3-step wizard):
  1. **Details**: Full Name, Contact, Shipper Name, Shipper Address, Consignee Name, Consignee Address, Goods Description, HS Code, Quantity, Weight, Transport Mode, Carrier Name, ETD, ETA
  2. **Vehicle Selection**: Motorcycle, Pickup Truck, Box Truck, Semi Truck
  3. **Confirm**: Review all details and confirm booking
- Tracking number generated on confirmation (LCA-FRT-2025-5211)

### 7. Agro Business

- **Gradient header** with Pembeyeo • Masoko • Usafirishaji tagline
- **3 category cards**: Pembeyeo (Farm Inputs), Masoko (Markets), Usafirishaji (Transport)
- **Featured products** carousel (Urea Fertilizer, Maize Seeds, Organic Compost)
- **Recent listings** with region info and quote requests

### 8. Track Shipment

- **Interactive GoogleMapView** with vehicle markers and route polylines
- **Tracking number input** with QR scan icon
- **Shipment cards** with ID, route, status badges, and progress bars
- Driver info and ETA display
- **Quick stats**: Total Active, Delivered, Pending
- "My Vehicles" banner linking to fleet management

### 9. My Vehicles

- **Fleet List**: Summary stats, vehicle cards with fuel gauge, mileage, location
- **Vehicle Detail**: Health dashboard with 7 components (Engine 85%, Brakes 70%, Tyres 60%, Battery 90%, etc.), live map, "Start Engine" button
- **Vehicle Tracking**: Full-screen map with live tracking indicator, route polyline, activity timeline

### 10. Bolt Ride Options

- **Real OSRM routing** for driving directions with Haversine fallback
- **4 vehicle types**: Boda Boda (TZS 350/km), Bajaji (TZS 550/km), Carry Truck (TZS 750/km), Town Hiace (TZS 950/km)
- Animated vehicle selection with price formatting
- Booking confirmation with total price dialog
- Full interactive map with pickup/drop-off markers

### 11. Orders

- **6 mock orders** covering various service types
- Order cards with **color-coded status badges** (Delivered, In Transit, Scheduled, Pending, Confirmed)
- **Pickup → drop-off route** visualization
- Info chips: date, vehicle type, price
- **Linear progress bars** showing delivery completion

### 12. Business Tools (Become Inspector / IT Driver / Winga)

Three separate **3-step registration wizards**:

#### Inspector Registration:
1. **Personal Info**: Name, Phone, Email, Location, Years of Experience
2. **Professional Details**: Inspection type (Vehicle, Electronics, Cargo, Agricultural, Industrial), Specialization, Certifications
3. **Documents Upload**: National ID, Professional Certificate, CV/Resume

#### IT Driver Registration:
1. **Personal Info**: Name, Phone, Email, Location, Vehicle Plate, Vehicle Type
2. **Delivery Preferences**: Delivery area (6 Tanzanian cities), Vehicle category (Motorcycle, Boda, Bajaji, Pickup, Box Truck), License checkbox
3. **Documents**: National ID, Driving License, Profile Photo

#### Winga Registration:
1. **Personal Info**: Name, Phone, Email, Location, Social Media Handle
2. **Business Details**: Primary platform (WhatsApp/Instagram/TikTok/Facebook/Twitter), Product categories (10 categories), T&C agreement
3. **Documents**: National ID, Social Media Profile Screenshot, Proof of Previous Sales

All forms feature animated progress bars, document upload toggles, admin review messaging, and success confirmation dialogs.

### 13. Inspectors Directory

- **5 international inspectors** from Japan, China, UAE, Germany, and USA
- Each card shows:
  - Gradient avatar with initials
  - Name, country flag, star rating
  - Price per inspection
  - **Specialty chips** (e.g., Vehicle Inspection, Electronics, Container Cargo)
  - Detailed description
  - **Verification count** and "Contact Inspector" button

### 14. Cargo Inspection Companies

- **5 Tanzanian inspection companies**: TBS, SGS, Bureau Veritas, Intertek, TICTS
- Each card shows:
  - Company icon, name, rating + review count
  - **Service chips** (e.g., Quality Inspection, Pre-Shipment, Container Inspection)
  - Description, location, phone number
  - "Request Inspection" and "Call" action buttons

### 15. Profile & Account

- **Glassmorphism gradient header** with centered avatar
- **Verified Member badge** and contact info
- **3 stat boxes**: Orders (12), Rating (4.9), Reviews (8)
- **Account Settings**: Edit Profile, My Orders, Payment Methods, Notifications
- **Business Tools**: Become Inspector (with "New" badge), Become IT Driver, Become a Winga
- **Support**: Help Center, Privacy Policy, Terms & Conditions
- **Logout** with destructive styling

### 16. Design System

The app features a modern design system blending **Glassmorphism, Neumorphism, Skeuomorphism, and Bento UI**:

| Style | Usage |
|-------|-------|
| **Glassmorphism** | Headers, overlay cards, stat card backgrounds — translucent with blur |
| **Neumorphism** | Pressable cards and buttons — inset/outset dual shadows with animated press states |
| **Skeuomorphism** | Icon containers — realistic gradient buttons with highlights |
| **Bento UI** | Content cards, list tiles — clean rounded borders with minimal shadows |

The `DesignSystem` utility class provides reusable static methods:
- `glassMorphism()` — Translucent overlay effect
- `neumorphism()` — Soft shadow card with press depression
- `skeuomorphic()` — 3D gradient effect
- `bentoCard()` — Clean bordered card
- `glassCard()` — Combined glass + neumorphism
- `NeumorphicPressEffect` — Reusable animated press widget
- `GlassContainer` — BackdropFilter wrapper

---

## Navigation Structure

```
OnboardingScreen → LoginScreen → MainNavigationScreen
                                     │
                    ┌────────────────┼──────────────────┐
                    │                │                   │
                 HomeScreen      OrdersScreen      AccountScreen
                    │                                  │
        ┌───────────┼──────────────┐           ┌───────┼─────────┐
        │           │              │           │       │         │
 SendPackage  Schedule     ImportCar     Inspector  Driver   Winga
     │        Transport                    Reg.     Reg.     Reg.
     │            │
 BookingScreen  CargoBooking
  (Boda,        (Box Truck,
   Bajaji,       Semi Truck
   Carry Truck,  + Date/Time)
   Town Hiace)

Bottom Nav Bar (5 tabs):
[🏠 Home] [📋 Orders] [✅ Inspectors] [📦 Cargo Insp.] [👤 Account]
```

---

## Tech Stack

| Component | Technology |
|-----------|-----------|
| **Framework** | Flutter 3.x (Dart ^3.11.5) |
| **Map Tiles** | Google Maps Tiles (`mt1.google.com/vt`) |
| **Routing** | OSRM (`router.project-osrm.org`) |
| **Geocoding** | Nominatim (`nominatim.openstreetmap.org`) |
| **Location** | Geolocator (device GPS) |
| **Map Widget** | flutter_map ^8.3.0 |
| **Coordinates** | latlong2 ^0.9.1 |
| **HTTP** | http ^1.2.2 |
| **Design** | Material 3 with custom DesignSystem |

### Free Map Stack ($0 Cost)
- **Map Tiles**: Google MT road and satellite tiles
- **Place Search**: Nominatim (OpenStreetMap)
- **Route Calculation**: OSRM (Project OSRM)
- **Current Location**: Geolocator (built-in GPS)

---

## Project Structure

```
lacca_app/
├── lib/
│   ├── main.dart                              # App entry point
│   ├── core/
│   │   ├── theme/
│   │   │   ├── app_colors.dart                 # Color palette (42 colors)
│   │   │   ├── app_theme.dart                  # Material3 light theme
│   │   │   └── design_system.dart              # Glassmorphism, Neumorphism, Bento UI utilities
│   │   ├── utils/
│   │   │   └── responsive.dart                 # Screen-adaptive sizing utilities
│   │   └── widgets/
│   │       ├── primary_button.dart             # PrimaryButton, SecondaryButton, GreenButton
│   │       ├── custom_text_field.dart          # CustomTextField, LabeledTextField
│   │       ├── service_card.dart               # ServiceCard, StatCard, SectionHeader
│   │       └── google_map_tile.dart            # GoogleMapView, MapMarkerHelper, MapRouteHelper
│   └── features/
│       ├── auth/
│       │   ├── onboarding_screen.dart          # Onboarding + Login screens
│       │   ├── inspector_registration_screen.dart
│       │   ├── driver_registration_screen.dart
│       │   └── winga_registration_screen.dart
│       ├── home/
│       │   ├── main_navigation.dart            # Pill-style bottom nav (5 tabs)
│       │   ├── home_screen.dart                # Dashboard
│       │   ├── send_package_screen.dart        # Package delivery with map + search
│       │   ├── booking_screen.dart             # Vehicle selection (Boda, Bajaji, etc.)
│       │   ├── schedule_transport_screen.dart   # Schedule large cargo transport
│       │   ├── cargo_booking_screen.dart        # Box Truck/Semi Truck + date/time picker
│       │   ├── car_import_screen.dart           # Import car + tax calculator
│       │   ├── cargo_clearing_screen.dart       # Cargo clearing modes
│       │   ├── track_shipment_screen.dart       # Shipment tracking with map
│       │   └── bolt_ride_options_screen.dart    # Ride hailing with OSRM
│       ├── agro/
│       │   └── agro_business_screen.dart        # Farm inputs, markets, transport
│       ├── freight/
│       │   └── freight_booking_screen.dart      # 3-step freight booking with clearance form
│       ├── cargo/
│       │   └── cargo_clearance_form_screen.dart # Cargo clearance form request
│       ├── profile/
│       │   └── account_screen.dart              # User profile with glassmorphism
│       ├── orders/
│       │   └── orders_screen.dart              # Order history with mock data
│       ├── inspectors/
│       │   └── inspectors_screen.dart           # International inspectors directory
│       ├── cargo_inspection/
│       │   └── cargo_inspection_screen.dart     # Tanzanian cargo inspection companies
│       └── vehicles/
│           └── my_vehicles_screen.dart          # Fleet management (3 screens in 1)
├── assets/images/                               # 20+ UI mockup images
├── android/                                     # Android native config
├── ios/                                         # iOS native config
├── pubspec.yaml                                 # Dependencies
└── README.md
```

---

## Setup & Installation

### Prerequisites
- Flutter SDK (^3.11.5)
- Android Studio / Xcode
- Android SDK or iOS Simulator

### Installation
```bash
# Clone the repository
git clone https://github.com/Laca57/LACA-APP.git
cd LACA-APP/lacca_app

# Install dependencies
flutter pub get

# Run on connected device
flutter run
```

### Platform Permissions
- **Android**: Internet, Fine Location, Coarse Location (in `AndroidManifest.xml`)
- **iOS**: When In Use Location, Always Location (in `Info.plist`)

---

## Building APK

```bash
# Navigate to app directory
cd lacca_app

# Build debug APK
flutter build apk --debug

# Build release APK (smaller, optimized)
flutter build apk --release

# The APK will be at:
# build/app/outputs/flutter-apk/app-debug.apk
```

---

## Credits

**LACA App** — Developed by Laca57

**Free Services Used:**
- Google Maps Tiles (visual map)
- Nominatim by OpenStreetMap (place search)
- OSRM by Project OSRM (routing)
- Geolocator (device GPS)

**Design System:**
- Glassmorphism, Neumorphism, Skeuomorphism, and Bento UI principles applied throughout the app via the custom `DesignSystem` class.

---

**Built with ❤️ for Tanzania**