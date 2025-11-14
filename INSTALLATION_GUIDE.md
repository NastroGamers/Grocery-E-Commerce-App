# 📦 Complete Installation Guide - Grocery E-Commerce Platform

## 📋 Table of Contents

1. [System Requirements](#system-requirements)
2. [Prerequisites Installation](#prerequisites-installation)
3. [Backend Setup](#backend-setup)
4. [Flutter Apps Setup](#flutter-apps-setup)
5. [Third-Party Services Configuration](#third-party-services-configuration)
6. [Testing All Apps](#testing-all-apps)
7. [Troubleshooting](#troubleshooting)
8. [Production Deployment](#production-deployment)

---

## 🖥️ System Requirements

### Minimum Requirements
- **OS**: Windows 10+, macOS 10.14+, or Ubuntu 18.04+
- **RAM**: 8GB (16GB recommended)
- **Storage**: 20GB free space
- **Internet**: Stable broadband connection

### Supported Development Platforms
- Windows 10/11 (64-bit)
- macOS Catalina (10.15) or later
- Linux (Ubuntu 18.04+, Debian 10+, Fedora, Arch)

---

## 📥 Prerequisites Installation

### Step 1: Install Node.js and npm

#### Windows
1. Download Node.js v18+ from [nodejs.org](https://nodejs.org/)
2. Run the installer and follow the prompts
3. Verify installation:
```bash
node --version  # Should show v18.0.0 or higher
npm --version   # Should show v9.0.0 or higher
```

#### macOS
```bash
# Using Homebrew
brew install node@18

# Verify installation
node --version
npm --version
```

#### Linux (Ubuntu/Debian)
```bash
# Add NodeSource repository
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -

# Install Node.js
sudo apt-get install -y nodejs

# Verify installation
node --version
npm --version
```

### Step 2: Install MongoDB

#### Windows
1. Download MongoDB Community Server from [mongodb.com](https://www.mongodb.com/try/download/community)
2. Run the installer and select "Complete" installation
3. Install MongoDB as a Service
4. Verify installation:
```bash
mongod --version
```

#### macOS
```bash
# Using Homebrew
brew tap mongodb/brew
brew install mongodb-community@7.0

# Start MongoDB service
brew services start mongodb-community@7.0

# Verify installation
mongosh --version
```

#### Linux (Ubuntu/Debian)
```bash
# Import MongoDB public GPG key
curl -fsSL https://www.mongodb.org/static/pgp/server-7.0.asc | \
   sudo gpg -o /usr/share/keyrings/mongodb-server-7.0.gpg --dearmor

# Add MongoDB repository
echo "deb [ signed-by=/usr/share/keyrings/mongodb-server-7.0.gpg ] https://repo.mongodb.org/apt/ubuntu jammy/mongodb-org/7.0 multiverse" | \
   sudo tee /etc/apt/sources.list.d/mongodb-org-7.0.list

# Update package database
sudo apt-get update

# Install MongoDB
sudo apt-get install -y mongodb-org

# Start MongoDB service
sudo systemctl start mongod
sudo systemctl enable mongod

# Verify installation
mongosh --version
```

### Step 3: Install Redis

#### Windows
1. Download Redis for Windows from [github.com/microsoftarchive/redis](https://github.com/microsoftarchive/redis/releases)
2. Extract and run `redis-server.exe`
3. Or use WSL2 with Linux installation

#### macOS
```bash
# Using Homebrew
brew install redis

# Start Redis service
brew services start redis

# Verify installation
redis-cli ping  # Should return "PONG"
```

#### Linux (Ubuntu/Debian)
```bash
# Install Redis
sudo apt-get update
sudo apt-get install -y redis-server

# Start Redis service
sudo systemctl start redis-server
sudo systemctl enable redis-server

# Verify installation
redis-cli ping  # Should return "PONG"
```

### Step 4: Install Flutter SDK

#### Windows
1. Download Flutter SDK from [flutter.dev](https://docs.flutter.dev/get-started/install/windows)
2. Extract zip to `C:\src\flutter`
3. Add Flutter to PATH:
   - Search for "Environment Variables"
   - Add `C:\src\flutter\bin` to PATH
4. Run Flutter Doctor:
```bash
flutter doctor
```

#### macOS
```bash
# Download Flutter SDK
cd ~/development
git clone https://github.com/flutter/flutter.git -b stable

# Add to PATH (add to ~/.zshrc or ~/.bash_profile)
export PATH="$PATH:$HOME/development/flutter/bin"

# Reload shell
source ~/.zshrc

# Run Flutter Doctor
flutter doctor
```

#### Linux
```bash
# Download Flutter SDK
cd ~/development
git clone https://github.com/flutter/flutter.git -b stable

# Add to PATH (add to ~/.bashrc)
export PATH="$PATH:$HOME/development/flutter/bin"

# Reload shell
source ~/.bashrc

# Run Flutter Doctor
flutter doctor
```

### Step 5: Install Android Studio (for Android development)

1. Download Android Studio from [developer.android.com](https://developer.android.com/studio)
2. Install Android Studio and Android SDK
3. Open Android Studio → SDK Manager
4. Install:
   - Android SDK Platform 33+
   - Android SDK Build-Tools
   - Android Emulator
   - Intel x86 Emulator Accelerator (HAXM) - Windows/Linux only
5. Accept Android licenses:
```bash
flutter doctor --android-licenses
```

### Step 6: Install Xcode (macOS only - for iOS development)

```bash
# Install Xcode from App Store or
xcode-select --install

# Install CocoaPods
sudo gem install cocoapods

# Verify installation
pod --version
```

### Step 7: Install Git

#### Windows
Download Git from [git-scm.com](https://git-scm.com/download/win) and install

#### macOS
```bash
brew install git
```

#### Linux
```bash
sudo apt-get install -y git
```

Verify installation:
```bash
git --version
```

---

## 🔧 Backend Setup

### Step 1: Clone Repository

```bash
# Clone the repository
git clone https://github.com/NastroGamers/Grocery-E-Commerce-App.git

# Navigate to project directory
cd Grocery-E-Commerce-App
```

### Step 2: Configure Backend Environment

```bash
# Navigate to backend directory
cd backend

# Copy environment template
cp .env.example .env

# Edit .env file with your configuration
# Use your preferred text editor (nano, vim, code, notepad, etc.)
nano .env
```

### Step 3: Configure Required Environment Variables

Edit the `.env` file with the following minimum configuration:

```env
# Server Configuration
NODE_ENV=development
PORT=5000
API_VERSION=v1

# Database
MONGODB_URI=mongodb://localhost:27017/grocery_ecommerce

# JWT (Generate secure secrets)
JWT_SECRET=your_super_secret_jwt_key_minimum_32_characters_long
JWT_EXPIRE=7d
JWT_REFRESH_SECRET=your_refresh_token_secret_minimum_32_characters
JWT_REFRESH_EXPIRE=30d

# Security
BCRYPT_ROUNDS=12
RATE_LIMIT_MAX_REQUESTS=100
RATE_LIMIT_WINDOW_MS=900000

# CORS
ALLOWED_ORIGINS=http://localhost:3000,http://localhost:8080

# Redis
REDIS_HOST=localhost
REDIS_PORT=6379
REDIS_PASSWORD=

# Logging
LOG_LEVEL=info
LOG_FILE=logs/app.log
```

**Note**: For development, you can leave third-party service variables empty. They'll be configured later.

### Step 4: Install Backend Dependencies

```bash
# Make sure you're in the backend directory
npm install
```

This will install all required packages including:
- Express.js (Web framework)
- Mongoose (MongoDB ODM)
- Socket.IO (Real-time communication)
- JWT (Authentication)
- Security middleware (Helmet, CORS, etc.)

### Step 5: Start MongoDB

#### Windows
```bash
# MongoDB should be running as a service
# If not, start it manually:
mongod --dbpath C:\data\db
```

#### macOS
```bash
brew services start mongodb-community@7.0
```

#### Linux
```bash
sudo systemctl start mongod
```

Verify MongoDB is running:
```bash
mongosh
# You should see MongoDB shell
# Type 'exit' to leave
```

### Step 6: Start Redis

#### Windows
```bash
redis-server
```

#### macOS
```bash
brew services start redis
```

#### Linux
```bash
sudo systemctl start redis-server
```

Verify Redis is running:
```bash
redis-cli ping
# Should return: PONG
```

### Step 7: Start Backend Server

```bash
# Development mode (with hot reload)
npm run dev

# Or production mode
npm start
```

You should see output like:
```
✓ MongoDB Connected: localhost
✓ Redis Connected: localhost:6379
✓ Server running on port 5000
✓ WebSocket server initialized
```

### Step 8: Verify Backend

Open a new terminal and test the backend:

```bash
# Health check
curl http://localhost:5000/health

# Should return:
# {"status":"success","message":"Server is running","timestamp":"..."}

# API version check
curl http://localhost:5000/api/v1/

# Should return API information
```

---

## 📱 Flutter Apps Setup

### Common Setup for All Apps

Before setting up individual apps, ensure Flutter is properly configured:

```bash
# Run Flutter doctor to check setup
flutter doctor -v

# Expected output should show:
# [✓] Flutter (Channel stable, version 3.x.x)
# [✓] Android toolchain - develop for Android devices
# [✓] Xcode - develop for iOS and macOS (macOS only)
# [✓] Chrome - develop for the web
# [✓] Android Studio
# [✓] VS Code (if installed)
# [✓] Connected device
```

### Step 1: Customer App Setup

```bash
# Navigate to customer app directory
cd customer_app

# Install dependencies
flutter pub get

# Run code generation (for models, DI, etc.)
flutter pub run build_runner build --delete-conflicting-outputs
```

#### Configure Customer App

1. Edit `lib/core/config/app_config.dart`:

```dart
class AppConfig {
  static const String baseUrl = 'http://localhost:5000/api/v1';

  // For Android Emulator, use: http://10.0.2.2:5000/api/v1
  // For iOS Simulator, use: http://localhost:5000/api/v1
  // For Physical Device, use: http://YOUR_IP:5000/api/v1

  static const String wsUrl = 'ws://localhost:5000';

  // Update these when you configure services
  static const String googleMapsApiKey = 'YOUR_GOOGLE_MAPS_KEY';
  static const String razorpayKey = 'YOUR_RAZORPAY_KEY';
  static const String stripePublishableKey = 'YOUR_STRIPE_KEY';
}
```

2. Configure Firebase (will be done in Third-Party Services section)

#### Run Customer App

```bash
# List available devices
flutter devices

# Run on specific device
flutter run -d <device_id>

# Or simply run on available device
flutter run

# For web
flutter run -d chrome

# For Android emulator
flutter run -d android

# For iOS simulator (macOS only)
flutter run -d ios
```

### Step 2: Admin App Setup

```bash
# Navigate to admin app directory (from project root)
cd admin_app

# Install dependencies
flutter pub get

# Run code generation
flutter pub run build_runner build --delete-conflicting-outputs

# Configure base URL in lib/core/config/app_config.dart (same as customer app)

# Run the app
flutter run
```

### Step 3: Delivery App Setup

```bash
# Navigate to delivery app directory (from project root)
cd delivery_app

# Install dependencies
flutter pub get

# Run code generation
flutter pub run build_runner build --delete-conflicting-outputs

# Configure base URL in lib/core/config/app_config.dart

# Run the app
flutter run
```

### Step 4: Vendor App Setup

```bash
# Navigate to vendor app directory (from project root)
cd vendor_app

# Install dependencies
flutter pub get

# Run code generation
flutter pub run build_runner build --delete-conflicting-outputs

# Configure base URL in lib/core/config/app_config.dart

# Run the app
flutter run
```

### Configuring API URLs for Different Environments

#### For Android Emulator
```dart
static const String baseUrl = 'http://10.0.2.2:5000/api/v1';
```

#### For iOS Simulator
```dart
static const String baseUrl = 'http://localhost:5000/api/v1';
```

#### For Physical Device
```bash
# Find your computer's IP address

# Windows
ipconfig
# Look for IPv4 Address

# macOS/Linux
ifconfig | grep inet
# Or
ip addr show
```

```dart
static const String baseUrl = 'http://YOUR_IP_ADDRESS:5000/api/v1';
// Example: 'http://192.168.1.100:5000/api/v1'
```

---

## 🔐 Third-Party Services Configuration

### 1. Firebase Setup

#### Create Firebase Project

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Click "Add Project"
3. Enter project name: "Grocery-E-Commerce"
4. Disable Google Analytics (optional)
5. Click "Create Project"

#### Configure Firebase for Android

```bash
# Install Firebase CLI
npm install -g firebase-tools

# Login to Firebase
firebase login

# Navigate to customer_app directory
cd customer_app

# Initialize Firebase
firebase init
```

Select:
- Authentication
- Firestore (if using)
- Cloud Messaging

Download `google-services.json`:
1. In Firebase Console → Project Settings
2. Add Android app
3. Package name: `com.freshcart.customer` (for customer app)
4. Download `google-services.json`
5. Place in `customer_app/android/app/`

#### Configure Firebase for iOS (macOS only)

Download `GoogleService-Info.plist`:
1. In Firebase Console → Project Settings
2. Add iOS app
3. Bundle ID: `com.freshcart.customer`
4. Download `GoogleService-Info.plist`
5. Place in `customer_app/ios/Runner/`

#### Enable Authentication Methods

In Firebase Console:
1. Go to Authentication → Sign-in method
2. Enable:
   - Email/Password
   - Phone
   - Google

#### Get Firebase Admin SDK Credentials (for Backend)

1. Firebase Console → Project Settings → Service Accounts
2. Click "Generate New Private Key"
3. Save the JSON file
4. Add to backend `.env`:

```env
FIREBASE_PROJECT_ID=your-project-id
FIREBASE_PRIVATE_KEY="-----BEGIN PRIVATE KEY-----\n...\n-----END PRIVATE KEY-----\n"
FIREBASE_CLIENT_EMAIL=firebase-adminsdk-xxxxx@your-project.iam.gserviceaccount.com
```

**Repeat for all apps** (admin_app, delivery_app, vendor_app) with different package names.

### 2. Google Maps API Setup

#### Create Google Cloud Project

1. Go to [Google Cloud Console](https://console.cloud.google.com/)
2. Create new project: "Grocery-E-Commerce"
3. Enable APIs:
   - Maps SDK for Android
   - Maps SDK for iOS
   - Places API
   - Geocoding API
   - Directions API

#### Get API Key

1. APIs & Services → Credentials
2. Create Credentials → API Key
3. Restrict key by:
   - Application restrictions (Android/iOS apps)
   - API restrictions (select enabled APIs)

#### Add to Apps

**Android** (`android/app/src/main/AndroidManifest.xml`):
```xml
<manifest>
    <application>
        <meta-data
            android:name="com.google.android.geo.API_KEY"
            android:value="YOUR_GOOGLE_MAPS_API_KEY"/>
    </application>
</manifest>
```

**iOS** (`ios/Runner/AppDelegate.swift`):
```swift
import GoogleMaps

GMSServices.provideAPIKey("YOUR_GOOGLE_MAPS_API_KEY")
```

**Backend** (`.env`):
```env
GOOGLE_MAPS_API_KEY=your_google_maps_api_key
```

### 3. Payment Gateway Setup

#### Razorpay Setup

1. Sign up at [Razorpay](https://razorpay.com/)
2. Get API keys from Dashboard → Settings → API Keys
3. Add to backend `.env`:

```env
RAZORPAY_KEY_ID=rzp_test_xxxxxxxxxxxxx
RAZORPAY_KEY_SECRET=your_razorpay_secret
```

4. Add to app config:
```dart
static const String razorpayKey = 'rzp_test_xxxxxxxxxxxxx';
```

#### Stripe Setup

1. Sign up at [Stripe](https://stripe.com/)
2. Get API keys from Developers → API Keys
3. Add to backend `.env`:

```env
STRIPE_SECRET_KEY=sk_test_xxxxxxxxxxxxx
STRIPE_PUBLISHABLE_KEY=pk_test_xxxxxxxxxxxxx
STRIPE_WEBHOOK_SECRET=whsec_xxxxxxxxxxxxx
```

4. Add to app config:
```dart
static const String stripePublishableKey = 'pk_test_xxxxxxxxxxxxx';
```

### 4. Cloudinary Setup (for image uploads)

1. Sign up at [Cloudinary](https://cloudinary.com/)
2. Get credentials from Dashboard
3. Add to backend `.env`:

```env
CLOUDINARY_CLOUD_NAME=your_cloud_name
CLOUDINARY_API_KEY=your_api_key
CLOUDINARY_API_SECRET=your_api_secret
```

### 5. Twilio Setup (for SMS/OTP)

1. Sign up at [Twilio](https://www.twilio.com/)
2. Get phone number and credentials
3. Add to backend `.env`:

```env
TWILIO_ACCOUNT_SID=ACxxxxxxxxxxxxx
TWILIO_AUTH_TOKEN=your_auth_token
TWILIO_PHONE_NUMBER=+1234567890
```

### 6. Email Setup (NodeMailer with Gmail)

1. Enable 2-Factor Authentication on your Gmail account
2. Generate App Password:
   - Google Account → Security → 2-Step Verification → App Passwords
   - Select "Mail" and "Other (Custom name)"
   - Copy the generated password

3. Add to backend `.env`:

```env
SMTP_HOST=smtp.gmail.com
SMTP_PORT=587
SMTP_USER=your_email@gmail.com
SMTP_PASS=your_app_password
EMAIL_FROM=noreply@freshcart.com
```

### 7. WhatsApp Business API (Optional)

1. Sign up for [WhatsApp Business API](https://business.whatsapp.com/)
2. Get credentials
3. Add to backend `.env`:

```env
WHATSAPP_BUSINESS_PHONE_ID=your_phone_id
WHATSAPP_ACCESS_TOKEN=your_access_token
```

---

## 🧪 Testing All Apps

### Backend Testing

#### Test 1: Health Check

```bash
curl http://localhost:5000/health
```

Expected response:
```json
{
  "status": "success",
  "message": "Server is running",
  "timestamp": "2025-11-14T..."
}
```

#### Test 2: User Registration

```bash
curl -X POST http://localhost:5000/api/v1/auth/register \
  -H "Content-Type: application/json" \
  -d '{
    "name": "Test User",
    "email": "test@example.com",
    "phone": "+1234567890",
    "password": "Password123!"
  }'
```

Expected: Success response with user data

#### Test 3: User Login

```bash
curl -X POST http://localhost:5000/api/v1/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "email": "test@example.com",
    "password": "Password123!"
  }'
```

Expected: Success response with JWT token

#### Test 4: WebSocket Connection

```bash
# Install wscat for WebSocket testing
npm install -g wscat

# Connect to WebSocket server
wscat -c ws://localhost:5000

# Send test message
{"type":"ping"}
```

Expected: Connection established and pong response

### Customer App Testing

#### Launch the App

```bash
cd customer_app
flutter run
```

#### Test Checklist

1. **Splash Screen**
   - [ ] App launches successfully
   - [ ] Logo displays correctly
   - [ ] Navigates to onboarding/home

2. **Authentication**
   - [ ] Registration screen loads
   - [ ] Email registration works
   - [ ] Phone OTP registration works
   - [ ] Google Sign-In works
   - [ ] Login works
   - [ ] Forgot password works

3. **Home Screen**
   - [ ] Categories display
   - [ ] Banners/promotions display
   - [ ] Products load
   - [ ] Search functionality works

4. **Product Features**
   - [ ] Product details screen works
   - [ ] Add to cart works
   - [ ] Add to wishlist works
   - [ ] Product reviews display

5. **Cart & Checkout**
   - [ ] Cart screen displays items
   - [ ] Quantity update works
   - [ ] Remove from cart works
   - [ ] Checkout flow works
   - [ ] Address selection works
   - [ ] Payment method selection works

6. **Location**
   - [ ] Location permission requested
   - [ ] Current location detected
   - [ ] Address management works

7. **Orders**
   - [ ] Order placement works
   - [ ] Order history displays
   - [ ] Order tracking works
   - [ ] Reorder works

8. **Profile**
   - [ ] Profile screen displays
   - [ ] Profile edit works
   - [ ] Logout works

### Admin App Testing

```bash
cd admin_app
flutter run
```

#### Test Checklist

1. **Admin Login**
   - [ ] Admin login works
   - [ ] Dashboard displays

2. **Dashboard**
   - [ ] Statistics display
   - [ ] Charts render
   - [ ] Real-time data updates

3. **Customer Management**
   - [ ] Customer list displays
   - [ ] Search/filter works
   - [ ] Customer details view works
   - [ ] Block/unblock user works

4. **Order Management**
   - [ ] Orders list displays
   - [ ] Order status update works
   - [ ] Assign delivery works
   - [ ] Order details view works

5. **Product Management**
   - [ ] Products list displays
   - [ ] Add product works
   - [ ] Edit product works
   - [ ] Delete product works

6. **Inventory**
   - [ ] Stock levels display
   - [ ] Low stock alerts work
   - [ ] Update stock works

7. **Reports**
   - [ ] Sales report generates
   - [ ] Export functionality works

### Delivery App Testing

```bash
cd delivery_app
flutter run
```

#### Test Checklist

1. **Delivery Login**
   - [ ] Delivery partner login works
   - [ ] Home screen displays

2. **Orders**
   - [ ] Assigned orders display
   - [ ] Accept order works
   - [ ] Order details display

3. **Navigation**
   - [ ] Google Maps integration works
   - [ ] Navigation to customer works
   - [ ] Real-time tracking works

4. **Delivery Flow**
   - [ ] Mark as picked up works
   - [ ] Mark as delivered works
   - [ ] Proof of delivery capture works
   - [ ] Cash collection (COD) works

5. **Earnings**
   - [ ] Earnings dashboard displays
   - [ ] Payment history works

### Vendor App Testing

```bash
cd vendor_app
flutter run
```

#### Test Checklist

1. **Vendor Login**
   - [ ] Vendor login works
   - [ ] Dashboard displays

2. **Products**
   - [ ] Product list displays
   - [ ] Add product works
   - [ ] Update stock works
   - [ ] Update price works

3. **Orders**
   - [ ] Incoming orders display
   - [ ] Accept order works
   - [ ] Mark as ready works

4. **Analytics**
   - [ ] Sales statistics display
   - [ ] Product performance shows

### Integration Testing

#### End-to-End Flow Test

1. **Customer Journey**
   ```
   Registration → Browse Products → Add to Cart →
   Checkout → Payment → Order Tracking → Delivery → Review
   ```

2. **Admin Flow**
   ```
   Login → View New Order → Assign Delivery Partner →
   Monitor Delivery → View Reports
   ```

3. **Delivery Flow**
   ```
   Login → Accept Order → Navigate → Pick Up →
   Deliver → Update Status → View Earnings
   ```

4. **Vendor Flow**
   ```
   Login → View Order → Accept → Prepare Items →
   Mark Ready → View Sales
   ```

---

## 🐛 Troubleshooting

### Common Backend Issues

#### Issue: MongoDB Connection Failed

**Error**: `MongoServerError: connect ECONNREFUSED`

**Solution**:
```bash
# Check if MongoDB is running
sudo systemctl status mongod  # Linux
brew services list | grep mongodb  # macOS

# Start MongoDB
sudo systemctl start mongod  # Linux
brew services start mongodb-community@7.0  # macOS

# Check MongoDB logs
tail -f /var/log/mongodb/mongod.log  # Linux
tail -f /usr/local/var/log/mongodb/mongo.log  # macOS
```

#### Issue: Redis Connection Failed

**Solution**:
```bash
# Check Redis status
redis-cli ping

# Start Redis
sudo systemctl start redis-server  # Linux
brew services start redis  # macOS
```

#### Issue: Port 5000 Already in Use

**Solution**:
```bash
# Find process using port 5000
# Linux/macOS
lsof -i :5000
# Windows
netstat -ano | findstr :5000

# Kill the process
kill -9 <PID>  # Linux/macOS
taskkill /PID <PID> /F  # Windows

# Or change port in backend/.env
PORT=5001
```

#### Issue: JWT Token Invalid

**Solution**:
- Ensure JWT_SECRET is at least 32 characters
- Check token expiration settings
- Clear app data and re-login

### Common Flutter Issues

#### Issue: Flutter Command Not Found

**Solution**:
```bash
# Add Flutter to PATH
# Linux/macOS (add to ~/.bashrc or ~/.zshrc)
export PATH="$PATH:/path/to/flutter/bin"

# Windows - Add to Environment Variables
# C:\src\flutter\bin

# Verify
flutter --version
```

#### Issue: Gradle Build Failed (Android)

**Error**: `Could not resolve dependencies`

**Solution**:
```bash
cd android
./gradlew clean

cd ..
flutter clean
flutter pub get

# If still failing, delete build folders
rm -rf build/
rm -rf android/.gradle/
rm -rf android/app/build/

flutter run
```

#### Issue: CocoaPods Installation Failed (iOS)

**Solution**:
```bash
cd ios
rm Podfile.lock
rm -rf Pods/

pod repo update
pod install

cd ..
flutter clean
flutter run
```

#### Issue: Build Runner Fails

**Error**: `Conflicting outputs`

**Solution**:
```bash
flutter pub run build_runner build --delete-conflicting-outputs

# If still failing
flutter clean
rm -rf .dart_tool/
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
```

#### Issue: App Can't Connect to Backend

**Problem**: Network error, connection refused

**Solution**:

1. **For Android Emulator**, use:
```dart
static const String baseUrl = 'http://10.0.2.2:5000/api/v1';
```

2. **For iOS Simulator**, use:
```dart
static const String baseUrl = 'http://localhost:5000/api/v1';
```

3. **For Physical Device**:
   - Ensure device and computer are on same Wi-Fi
   - Use computer's IP address
   ```dart
   static const String baseUrl = 'http://192.168.1.100:5000/api/v1';
   ```
   - Check firewall settings

4. **Check backend is running**:
```bash
curl http://localhost:5000/health
```

#### Issue: Firebase Configuration Error

**Solution**:
1. Verify `google-services.json` (Android) is in `android/app/`
2. Verify `GoogleService-Info.plist` (iOS) is in `ios/Runner/`
3. Check package name matches Firebase console
4. Rebuild app after adding config files

#### Issue: Google Maps Not Displaying

**Solution**:
1. Verify API key is correct
2. Check API is enabled in Google Cloud Console
3. For Android, check SHA-1 certificate:
```bash
cd android
./gradlew signingReport
```
4. Add SHA-1 to Firebase project settings

### Database Issues

#### Issue: MongoDB Out of Disk Space

**Solution**:
```bash
# Check disk usage
df -h

# Clean old logs
sudo rm /var/log/mongodb/*.log.gz

# Compact database
mongosh
use grocery_ecommerce
db.runCommand({ compact: 'your_collection' })
```

#### Issue: Redis Memory Issues

**Solution**:
```bash
# Check memory usage
redis-cli info memory

# Clear all cache
redis-cli FLUSHALL

# Set max memory in redis.conf
maxmemory 256mb
maxmemory-policy allkeys-lru
```

### Performance Issues

#### Issue: App Runs Slowly

**Solution**:
1. Run in Release mode:
```bash
flutter run --release
```

2. Enable performance overlay:
```bash
flutter run --profile
```

3. Check for memory leaks
4. Optimize images and assets

#### Issue: Backend Response Slow

**Solution**:
1. Check MongoDB indexes
2. Enable Redis caching
3. Optimize database queries
4. Check server resources

---

## 🚀 Production Deployment

### Backend Deployment

#### Option 1: Docker Deployment

```bash
cd backend

# Build Docker image
docker build -t grocery-backend:latest .

# Run with docker-compose
docker-compose up -d
```

#### Option 2: Cloud Deployment (Heroku, AWS, DigitalOcean)

**Requirements**:
- Set all environment variables
- Use production MongoDB URI (MongoDB Atlas)
- Use production Redis instance
- Enable HTTPS
- Set up monitoring

**Environment Variables for Production**:
```env
NODE_ENV=production
MONGODB_URI=mongodb+srv://user:pass@cluster.mongodb.net/grocery_ecommerce
# ... all other production credentials
```

### Flutter App Deployment

#### Android APK/AAB Build

```bash
cd customer_app

# Build APK (for testing)
flutter build apk --release

# Build App Bundle (for Play Store)
flutter build appbundle --release

# Output files:
# build/app/outputs/flutter-apk/app-release.apk
# build/app/outputs/bundle/release/app-release.aab
```

#### iOS Build (macOS only)

```bash
cd customer_app

# Build iOS app
flutter build ios --release

# Open Xcode to archive and upload to App Store
open ios/Runner.xcworkspace
```

#### Web Build

```bash
flutter build web --release

# Output: build/web/
# Deploy to Firebase Hosting, Netlify, or any web server
```

### Pre-Deployment Checklist

#### Backend
- [ ] All environment variables configured
- [ ] Database backed up
- [ ] SSL/TLS certificates installed
- [ ] Monitoring tools set up (e.g., PM2, New Relic)
- [ ] Log rotation configured
- [ ] Rate limiting enabled
- [ ] CORS configured for production domains
- [ ] API documentation updated
- [ ] Load testing completed
- [ ] Security audit completed

#### Flutter Apps
- [ ] API endpoints point to production
- [ ] Firebase production project configured
- [ ] Payment gateways in production mode
- [ ] App icons and splash screens final
- [ ] App signing configured
- [ ] Privacy policy and terms of service added
- [ ] Analytics configured
- [ ] Crash reporting enabled (e.g., Sentry, Crashlytics)
- [ ] Performance testing completed
- [ ] Beta testing completed

---

## 📞 Support & Additional Resources

### Documentation
- **Flutter**: https://docs.flutter.dev/
- **Node.js**: https://nodejs.org/docs/
- **MongoDB**: https://docs.mongodb.com/
- **Firebase**: https://firebase.google.com/docs
- **Express.js**: https://expressjs.com/

### Community
- GitHub Issues: https://github.com/NastroGamers/Grocery-E-Commerce-App/issues
- Stack Overflow: Tag questions with relevant framework tags

### Useful Commands Reference

#### Flutter Commands
```bash
flutter doctor -v              # Check setup
flutter devices                # List devices
flutter pub get                # Install dependencies
flutter clean                  # Clean build files
flutter run                    # Run app
flutter build apk             # Build Android APK
flutter build ios             # Build iOS app
flutter test                  # Run tests
```

#### Backend Commands
```bash
npm install                   # Install dependencies
npm run dev                   # Development mode
npm start                     # Production mode
npm test                      # Run tests
npm run lint                  # Check code quality
```

#### MongoDB Commands
```bash
mongosh                       # Start MongoDB shell
show dbs                      # List databases
use grocery_ecommerce        # Switch database
show collections             # List collections
db.users.find()              # Query users
```

#### Redis Commands
```bash
redis-cli                     # Start Redis CLI
PING                          # Test connection
KEYS *                        # List all keys
GET key                       # Get value
FLUSHALL                      # Clear all data
```

---

## 📊 Project Status Summary

After completing this installation guide, you should have:

✅ Backend server running on http://localhost:5000
✅ MongoDB database connected and ready
✅ Redis cache server running
✅ Customer App running on emulator/device
✅ Admin App running on emulator/device
✅ Delivery App running on emulator/device
✅ Vendor App running on emulator/device
✅ Firebase configured for all apps
✅ Payment gateways configured (dev mode)
✅ Google Maps working
✅ Real-time features (WebSocket) operational

---

## 🎉 Next Steps

1. **Explore the Apps**: Test all features across different apps
2. **Configure Services**: Set up remaining third-party services
3. **Customize**: Update branding, colors, and content
4. **Add Test Data**: Populate database with sample products and data
5. **Implement Backend Controllers**: Complete backend business logic
6. **Write Tests**: Add unit and integration tests
7. **Deploy**: Follow production deployment guide

---

**Last Updated**: 2025-11-14
**Version**: 1.0.0
**Maintained by**: Grocery E-Commerce Team

For issues or questions, please open an issue on GitHub or refer to the troubleshooting section above.
