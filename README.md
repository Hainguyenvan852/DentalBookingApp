**Summary**
Dental Booking App is a cross-platform mobile application built with Flutter, connecting patients and dentists. 
The application provides a comprehensive dental appointment management system and dental product sales.

**Technologies**
Framework:	Flutter(Dart)
Backend:	Firebase (Firestore, Auth, Storage)
State Management:	Cubit/BLoC
Database:	Firestore
Authentication:	Firebase Auth
Payment:	Payment Gateway (VNPay)

**Project Structure**
Dental Booking App
│
├── 🎨 UI Layer (View)
│   ├── User Screens
│   │   ├── Authentication (Sign In/Up)
│   │   ├── Home Page
│   │   ├── Booking Page
│   │   ├── My Appointments
│   │   ├── Product Catalog
│   │   ├── Cart & Orders
│   │   ├── Notifications
│   │   ├── Chat
│   │   ├── Medical Costs
│   │   └── Personal Profile
│   └── Doctor Screens
│       ├── Appointments Dashboard
│       └── 
│
├── 💼 Business Logic Layer
│   ├── Cubit/BLoC (State Management)
│   ├── Authentication Logic
│   ├── Booking Logic
│   ├── Payment Logic
│   └── Notification Logic
│
├── 💾 Data Layer
│   ├── Models (Appointment, Product, Order, User...)
│   ├── Repositories (API calls, Database)
│   └── Firebase Services
│
└── 🔌 External Services
    ├── Firebase (Auth, Firestore, Storage)
    ├── Payment Gateway
    ├── Email Service
    └── Push Notifications

