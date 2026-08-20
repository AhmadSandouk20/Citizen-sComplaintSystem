# 📋 Complaint System - Flutter Mobile App

A multi-role complaint management system built with Flutter, designed to connect citizens with government agencies. Citizens can submit complaints, staff can process them, and admins gain full system oversight.

[![Flutter Version](https://img.shields.io/badge/Flutter-3.x-blue.svg)](https://flutter.dev)
[![Dart Version](https://img.shields.io/badge/Dart-3.x-blue.svg)](https://dart.dev)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg)](CONTRIBUTING.md)

---

## 📱 Overview

This application serves as the frontend client for a [Laravel-based complaint system API](your_backend_repo_link). It provides a seamless experience for citizens to submit and track complaints, and for government staff to manage and resolve them efficiently.

### 🎯 Key Features

- **🔐 Secure Authentication**  
  OTP-based registration, login, password reset, and account lock protection.

- **👥 Role-Based Access Control (RBAC)**  
  Three distinct user roles with tailored interfaces and permissions:
  - **Citizen**: Submit, view, and track personal complaints.
  - **Staff**: Process complaints assigned to their specific agency (Lock, Update Status, Resolve).
  - **Admin**: Full system management (Users, Agencies, Statistics, Reports).

- **🌐 Multi-Language & RTL Support**  
  Fully internationalized with **English** and **Arabic** support. Seamless RTL layout switching.

- **📱 Responsive Design**  
  Adaptive UI using `go_router` and `LayoutBuilder`:
  - **Bottom Navigation Bar** for mobile devices (< 600px).
  - **Navigation Rail** for tablets, desktops, and web views (> 600px).

- **🧩 Clean Architecture**  
  Implemented using **Bloc/Cubit** for state management, **GetIt** for dependency injection, and **Dio** for robust networking (Interceptors included).

---

## 🛠️ Tech Stack

| Category | Technology |
| :--- | :--- |
| **Framework** | Flutter (Dart) |
| **State Management** | BLoC / Cubit |
| **Routing** | `go_router` (Declarative, Shell-based) |
| **Dependency Injection** | `get_it` |
| **Networking** | `dio` (with Auth & Error Interceptors) |
| **Localization** | `easy_localization` |
| **Async Storage** | `shared_preferences` |
| **Architecture Pattern** | Feature-first (Clean Architecture) |

---

## 📁 Project Architecture

The codebase is organized by **feature modules**, ensuring scalability and separation of concerns:

lib/
├── core/ # Shared utilities
│ ├── localization/ # LocaleKeys & translation files
│ ├── router/ # go_router configuration & navigation guards
│ ├── theme/ # Light/Dark theme definitions (AppColors)
│ └── widgets/ # Shared widgets (AdaptiveShell, NavigationRail, etc.)
├── features/
│ ├── auth/ # Authentication (Login, OTP, Register)
│ ├── citizen/ # Citizen specific screens (Submit, List, Track)
│ ├── staff/ # Staff specific screens (Queue, Lock, Status)
│ ├── admin/ # Admin specific screens (Stats, Users, Agencies)
│ ├── locale/ # Locale Cubit (Language persistence)
│ └── theme/ # Theme Cubit (Dark/Light persistence)
└── main.dart

---

## 🚀 Getting Started

### Prerequisites

- Flutter SDK (>= 3.0.0)
- Dart SDK (>= 3.0.0)
- Android Studio / VS Code
- Git

### Installation

1. **Clone the repository**

   ```bash
   git clone https://github.com/AhmadSandouk20/Citizen-sComplaintSystem
   cd complaint_system_flutter
 
 2. **Install dependencies**
    
    flutter pub get
    
 4. **Run the app**
    
    flutter run
    
