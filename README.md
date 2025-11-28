Summary

    Dental Booking App is a cross-platform mobile application built with Flutter, connecting patients and dentists. The application provides a comprehensive dental appointment management system and dental product sales.

Technologies

    Framework: Flutter (Dart)
    
    Backend: Firebase - Use Cloud services like Firestore, Authentication, and Storage.
    
    State Management: Cubit/BLoC
    
    Database: Firestore
    
    Authentication: Firebase Auth - Manage registration and login securely for both users and doctors.
    
    Payment: Payment Gateway (VNPay) - Integrate online payment gateways for product purchases and service payments.

Project Structure

```
Dental Booking App
│
├── UI Layer (View)
│   ├── User Screens (Patient Interface)
│   │   ├── Authentication (Sign In/Up)
│   │   ├── Home Page
│   │   ├── Booking Page
│   │   ├── My Appointments
│   │   ├── Product Catalog
│   │   ├── Cart & Orders
│   │   ├── Notifications
│   │   ├── Contact & Support
│   │   ├── Medical Costs
│   │   └── Personal Profile
│   └── Doctor Screens
│       ├── Appointments Dashboard
│       └── Management Screens
│
├── Business Logic Layer
│   ├── Cubit/BLoC (State Management)
│   ├── Authentication Logic
│   ├── Booking Logic
│   ├── Payment Logic
│   └── Notification Logic
│
├── Data Layer
│   ├── Models (Appointment, Product, Order, User...)
│   ├── Repositories (API calls, Database)
│   └── Firebase Services
│
└── External Services
    ├── Firebase (Auth, Firestore, Storage)
    ├── Payment Gateway
    ├── Email Service (Send confirmation email)
    └── Push Notifications (upcoming appointment notification)
```

