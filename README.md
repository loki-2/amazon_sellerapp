# Scratch Flutter E-commerce App

A Flutter-based e-commerce application that provides a platform for sellers to manage their products and orders.

## Features

### Authentication
- Secure user authentication using Firebase Auth
- User registration and login functionality
- Session management

### Product Management
- Add new products with detailed information:
  - Product name and description
  - Price and original price
  - Discount percentage
  - Stock quantity
  - Category and brand
  - Product images (Base64 encoded)
- Limited time deals configuration
- Free shipping eligibility settings
- View and manage product listings
- Delete products

### Order Management
- View pending orders in real-time
- Order details display:
  - Order ID and status
  - Buyer information (name, address, contact)
  - Product details (quantity, price)
  - Order total
- Update order status with multiple stages:
  - Ordered
  - Processing
  - Shipped
  - Out for Delivery
  - Delivered
- Order tracking information

## Technical Stack

### Frontend
- Flutter SDK (>=3.2.6 <4.0.0)
- Material Design UI components
- Provider for state management

### Backend & Services
- Firebase Core (^2.24.2)
- Firebase Auth (^4.15.3)
- Cloud Firestore (^4.13.1)
- Firebase Storage (^11.5.1)

### Additional Dependencies
- Image Picker (^1.0.4) for handling product images
- Flutter Localizations for multi-language support

## Getting Started

1. Clone the repository
2. Install dependencies:
   ```bash
   flutter pub get
   ```
3. Configure Firebase:
   - Create a new Firebase project
   - Add Android/iOS apps in Firebase console
   - Download and add the configuration files
   - Enable Authentication and Firestore in Firebase console

4. Run the app:
   ```bash
   flutter run
   ```

## Assets

The `assets` directory contains:
- `images/`: Application images and icons

## Localization

This project supports localization through:
- ARB files in `lib/src/localization`
- Flutter's built-in localization system
- Support for multiple languages

## Contributing

Feel free to submit issues and enhancement requests.

## License

This project is licensed under the terms specified in the LICENSE file.