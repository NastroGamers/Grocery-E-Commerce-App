# 🧪 Complete Testing Checklist

This document provides a comprehensive testing checklist for verifying the Grocery E-Commerce Platform after installation. Follow this checklist step-by-step to ensure all components are working correctly.

---

## ✅ Pre-Testing Verification

### System Requirements Check

- [ ] Node.js v18+ installed (`node --version`)
- [ ] npm v9+ installed (`npm --version`)
- [ ] MongoDB installed and running (`mongosh --version`)
- [ ] Redis installed and running (`redis-cli ping`)
- [ ] Flutter SDK 3.0+ installed (`flutter --version`)
- [ ] Android Studio installed (for Android development)
- [ ] Xcode installed (for iOS development - macOS only)
- [ ] Git installed (`git --version`)

### Installation Verification

- [ ] Repository cloned successfully
- [ ] Backend dependencies installed (`backend/node_modules` exists)
- [ ] Backend `.env` file configured
- [ ] Customer app dependencies installed (`flutter pub get` completed)
- [ ] Admin app dependencies installed
- [ ] Delivery app dependencies installed
- [ ] Vendor app dependencies installed

---

## 🔧 Backend Testing

### 1. Service Health Checks

#### MongoDB Connection
```bash
# Test MongoDB connection
mongosh

# Expected: MongoDB shell opens successfully
# Run in MongoDB shell:
show dbs
exit
```
- [ ] MongoDB shell opens
- [ ] Can list databases
- [ ] No connection errors

#### Redis Connection
```bash
# Test Redis connection
redis-cli ping

# Expected output: PONG
redis-cli
PING
exit
```
- [ ] Redis responds with PONG
- [ ] Redis CLI works
- [ ] No connection errors

### 2. Backend Server Startup

```bash
cd backend
npm run dev
```

**Expected Console Output:**
```
✓ MongoDB Connected: localhost
✓ Redis Connected: localhost:6379
✓ Server running on port 5000
✓ WebSocket server initialized
Server listening on http://localhost:5000
```

- [ ] MongoDB connection successful
- [ ] Redis connection successful
- [ ] Server starts on port 5000
- [ ] WebSocket server initialized
- [ ] No startup errors

### 3. API Endpoint Testing

#### Health Check Endpoint
```bash
# In a new terminal window
curl http://localhost:5000/health
```

**Expected Response:**
```json
{
  "status": "success",
  "message": "Server is running",
  "timestamp": "2025-11-14T..."
}
```
- [ ] Status 200 returned
- [ ] JSON response received
- [ ] All fields present

#### API Base Endpoint
```bash
curl http://localhost:5000/api/v1/
```

**Expected Response:**
```json
{
  "status": "success",
  "message": "FreshCart Grocery E-Commerce API v1",
  "version": "v1",
  "docs": "/api/v1/docs"
}
```
- [ ] Status 200 returned
- [ ] API version information displayed
- [ ] No errors

### 4. Authentication Endpoints Testing

#### User Registration
```bash
curl -X POST http://localhost:5000/api/v1/auth/register \
  -H "Content-Type: application/json" \
  -d '{
    "name": "Test User",
    "email": "testuser@example.com",
    "phone": "+1234567890",
    "password": "Test@1234"
  }'
```

**Expected Response:**
```json
{
  "status": "success",
  "message": "User registered successfully",
  "data": {
    "user": {
      "_id": "...",
      "name": "Test User",
      "email": "testuser@example.com"
    },
    "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
  }
}
```
- [ ] Registration successful (Status 201)
- [ ] User object returned
- [ ] JWT token received
- [ ] No validation errors

#### User Login
```bash
curl -X POST http://localhost:5000/api/v1/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "email": "testuser@example.com",
    "password": "Test@1234"
  }'
```

**Expected Response:**
```json
{
  "status": "success",
  "message": "Login successful",
  "data": {
    "user": {...},
    "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
  }
}
```
- [ ] Login successful (Status 200)
- [ ] User data returned
- [ ] JWT token received
- [ ] Token different from registration

### 5. WebSocket Connection Testing

Install wscat (WebSocket testing tool):
```bash
npm install -g wscat
```

Test WebSocket connection:
```bash
wscat -c ws://localhost:5000
```

Send test message:
```json
{"type":"ping"}
```

**Expected Response:**
```json
{"type":"pong","timestamp":"..."}
```

- [ ] WebSocket connection established
- [ ] Can send messages
- [ ] Receives responses
- [ ] No connection drops

### 6. Database Verification

```bash
mongosh

# Switch to database
use grocery_ecommerce

# Check collections
show collections

# Expected collections:
# - users
# - products (if seeded)
# - categories (if seeded)
# - orders, carts, etc.

# Check user count
db.users.countDocuments()

# View created user
db.users.find().pretty()
```

- [ ] Database created (`grocery_ecommerce`)
- [ ] Collections exist
- [ ] Test user inserted
- [ ] Data structure correct

### 7. Redis Cache Verification

```bash
redis-cli

# Check keys
KEYS *

# Check if session data exists
GET session:*

# Monitor real-time operations
MONITOR
```

- [ ] Redis accessible
- [ ] Can query keys
- [ ] Cache operations working
- [ ] No errors

---

## 📱 Flutter Apps Testing

### 1. Customer App Testing

#### Setup Verification
```bash
cd customer_app
flutter doctor -v
```

- [ ] No issues reported for Flutter
- [ ] Android toolchain ready
- [ ] iOS toolchain ready (macOS only)
- [ ] At least one device available

#### Dependency Check
```bash
flutter pub get
```

**Expected Output:**
```
Running "flutter pub get" in customer_app...
Resolving dependencies...
Got dependencies!
```
- [ ] All dependencies resolved
- [ ] No version conflicts
- [ ] No errors

#### Code Generation
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

**Expected Output:**
```
[INFO] Generating build script...
[INFO] Generating build script completed...
[INFO] Running build...
[INFO] Running build completed...
```
- [ ] Build runner completes
- [ ] Generated files created
- [ ] No generation errors

#### Configuration Check

Check `lib/core/config/app_config.dart`:
```dart
class AppConfig {
  static const String baseUrl = 'http://10.0.2.2:5000/api/v1'; // For Android Emulator
  // OR
  static const String baseUrl = 'http://localhost:5000/api/v1'; // For iOS Simulator
  // OR
  static const String baseUrl = 'http://YOUR_IP:5000/api/v1'; // For Physical Device
}
```

- [ ] Base URL configured correctly
- [ ] API endpoints accessible
- [ ] WebSocket URL configured

#### App Launch
```bash
# List available devices
flutter devices

# Run on specific device
flutter run -d <device_id>

# Or run on any available device
flutter run
```

**Expected Output:**
```
Launching lib/main.dart on <device> in debug mode...
Running Gradle task 'assembleDebug'...
✓ Built build/app/outputs/flutter-apk/app-debug.apk
Installing build/app/outputs/flutter-apk/app-debug.apk...
Syncing files to device...
```

- [ ] App builds successfully
- [ ] No compilation errors
- [ ] App installs on device
- [ ] App launches successfully

#### UI Testing

**Splash Screen:**
- [ ] Splash screen displays
- [ ] Logo appears correctly
- [ ] App name visible
- [ ] Transitions to next screen (2-3 seconds)

**Onboarding/Welcome Screen:**
- [ ] Onboarding slides display
- [ ] Images load correctly
- [ ] Text readable
- [ ] Navigation between slides works
- [ ] "Skip" button works
- [ ] "Get Started" button works

**Authentication Screens:**

*Registration:*
- [ ] Registration screen loads
- [ ] All input fields visible
- [ ] Form validation works
- [ ] Email format validation
- [ ] Password strength indicator
- [ ] Phone number format validation
- [ ] "Sign Up" button enabled when valid
- [ ] Can navigate to login

*Login:*
- [ ] Login screen accessible
- [ ] Email field works
- [ ] Password field works
- [ ] "Show/Hide password" toggle works
- [ ] "Remember me" checkbox works
- [ ] "Forgot Password" link works
- [ ] Login button functional
- [ ] Google Sign-In button visible

*Phone OTP:*
- [ ] Phone number input works
- [ ] OTP sent confirmation shown
- [ ] OTP input screen displays
- [ ] Can resend OTP
- [ ] OTP verification works
- [ ] Timer countdown works

*Forgot Password:*
- [ ] Email input field works
- [ ] Reset link sent message
- [ ] Can return to login

**Home Screen:**
- [ ] Home screen loads after login
- [ ] Navigation bar displays
- [ ] Categories section visible
- [ ] Product list displays
- [ ] Banners/promotions load
- [ ] Search bar visible
- [ ] Cart icon visible with count
- [ ] Profile icon accessible

**Product Catalog:**
- [ ] Category list displays
- [ ] Can browse categories
- [ ] Products load in grid/list
- [ ] Product images display
- [ ] Product names visible
- [ ] Prices displayed correctly
- [ ] Add to cart button works
- [ ] Wishlist icon works
- [ ] Pagination/infinite scroll works
- [ ] Pull to refresh works

**Search:**
- [ ] Search bar functional
- [ ] Can type search query
- [ ] Search suggestions appear
- [ ] Search results display
- [ ] Filters work
- [ ] Sort options work
- [ ] No results message displays when appropriate

**Product Details:**
- [ ] Product detail screen opens
- [ ] Image gallery works
- [ ] Can swipe between images
- [ ] Product description visible
- [ ] Price displayed
- [ ] Stock status shown
- [ ] Variants selectable (if applicable)
- [ ] Quantity selector works
- [ ] Add to cart works
- [ ] Add to wishlist works
- [ ] Reviews section visible
- [ ] Rating displayed
- [ ] Can write review

**Cart:**
- [ ] Cart screen accessible
- [ ] Cart items display
- [ ] Item images show
- [ ] Quantities editable
- [ ] Remove item works
- [ ] Price calculations correct
- [ ] Subtotal displayed
- [ ] Tax/fees shown
- [ ] Total amount correct
- [ ] "Proceed to Checkout" enabled

**Wishlist:**
- [ ] Wishlist screen accessible
- [ ] Wishlist items display
- [ ] Can remove items
- [ ] Can move to cart
- [ ] Empty state shows when no items

**Address Management:**
- [ ] Address screen accessible
- [ ] Saved addresses display
- [ ] Can add new address
- [ ] Location auto-detection works
- [ ] Map integration works
- [ ] Can edit address
- [ ] Can delete address
- [ ] Can set default address

**Checkout:**
- [ ] Checkout screen loads
- [ ] Order summary displays
- [ ] Delivery address shown
- [ ] Can change address
- [ ] Time slot selection works
- [ ] Payment methods display
- [ ] Can select payment method
- [ ] Apply coupon works
- [ ] Coupon discount applied
- [ ] Final amount correct
- [ ] Place order button works

**Payment Integration:**
- [ ] Payment gateway opens
- [ ] Razorpay/Stripe loads
- [ ] Can select payment method
- [ ] Test payment works
- [ ] Payment success callback
- [ ] Order confirmation shown

**Order Tracking:**
- [ ] Order placed confirmation
- [ ] Order ID displayed
- [ ] Order status visible
- [ ] Real-time tracking works
- [ ] Map shows delivery location
- [ ] Delivery partner info shown
- [ ] Can call delivery partner
- [ ] Status updates in real-time

**Order History:**
- [ ] Order history accessible
- [ ] Past orders display
- [ ] Order details viewable
- [ ] Order status shown
- [ ] Can reorder
- [ ] Can rate order
- [ ] Can track ongoing orders

**Push Notifications:**
- [ ] Permission requested
- [ ] Test notification received
- [ ] Notification opens app
- [ ] Opens correct screen

**Profile:**
- [ ] Profile screen accessible
- [ ] User info displays
- [ ] Can edit profile
- [ ] Can update photo
- [ ] Can change password
- [ ] Settings accessible
- [ ] Logout works

**Chat Support:**
- [ ] Support screen accessible
- [ ] Can send messages
- [ ] Receives responses
- [ ] Real-time chat works
- [ ] Can send images
- [ ] FAQ section visible

**Voice Search:**
- [ ] Microphone permission requested
- [ ] Can start voice search
- [ ] Speech recognized
- [ ] Search results display

**QR Payment:**
- [ ] Camera permission requested
- [ ] Can scan QR code
- [ ] QR payment processes
- [ ] Payment confirmation shown

**Loyalty Program:**
- [ ] Loyalty screen accessible
- [ ] Points balance shown
- [ ] Tier displayed
- [ ] Rewards list visible
- [ ] Can redeem rewards

### 2. Admin App Testing

```bash
cd admin_app
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
flutter run
```

#### Admin Dashboard
- [ ] Admin login works
- [ ] Dashboard loads
- [ ] Statistics display (users, orders, revenue)
- [ ] Charts render correctly
- [ ] Real-time data updates
- [ ] Navigation menu works

#### Customer Management
- [ ] Customer list displays
- [ ] Pagination works
- [ ] Search functionality
- [ ] Filter options work
- [ ] View customer details
- [ ] Can block/unblock user
- [ ] Export customer data

#### Order Management
- [ ] Orders list displays
- [ ] Filter by status works
- [ ] Search orders
- [ ] View order details
- [ ] Update order status
- [ ] Assign delivery partner
- [ ] Cancel order works
- [ ] Refund processing

#### Product Management
- [ ] Products list displays
- [ ] Add new product works
- [ ] Upload product images
- [ ] Edit product works
- [ ] Delete product works
- [ ] Bulk operations work
- [ ] Category management

#### Inventory Management
- [ ] Stock levels display
- [ ] Low stock alerts shown
- [ ] Update stock works
- [ ] Stock history visible
- [ ] Export inventory report

#### Vendor Management
- [ ] Vendors list displays
- [ ] Add vendor works
- [ ] Edit vendor details
- [ ] Approve/reject vendor
- [ ] View vendor products
- [ ] Vendor performance stats

#### Promotions & Banners
- [ ] Banner list displays
- [ ] Add banner works
- [ ] Upload banner image
- [ ] Set banner schedule
- [ ] Edit banner works
- [ ] Delete banner works
- [ ] Coupon management
- [ ] Create coupon works
- [ ] Set coupon rules

#### Reports & Analytics
- [ ] Sales report generates
- [ ] Date range selection works
- [ ] Customer analytics display
- [ ] Product performance shown
- [ ] Revenue charts render
- [ ] Export reports (CSV/PDF)
- [ ] Real-time data updates

### 3. Delivery App Testing

```bash
cd delivery_app
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
flutter run
```

#### Delivery Partner Dashboard
- [ ] Delivery login works
- [ ] Home screen displays
- [ ] Profile setup works
- [ ] Document upload works
- [ ] Verification status shown
- [ ] Toggle availability works

#### Order Assignment
- [ ] New orders notification
- [ ] Order list displays
- [ ] Order details viewable
- [ ] Accept order works
- [ ] Reject order works
- [ ] Multiple orders manageable

#### Navigation & Tracking
- [ ] Location permission granted
- [ ] GPS tracking works
- [ ] Google Maps integration
- [ ] Route to pickup displays
- [ ] Route to customer displays
- [ ] Turn-by-turn navigation
- [ ] Real-time location updates

#### Delivery Flow
- [ ] Mark "Arrived at store" works
- [ ] Mark "Picked up" works
- [ ] Can call customer
- [ ] Mark "Arrived at location" works
- [ ] Proof of delivery works
- [ ] Take photo works
- [ ] Get signature works
- [ ] Mark "Delivered" works
- [ ] COD collection works

#### Earnings Dashboard
- [ ] Earnings screen accessible
- [ ] Today's earnings shown
- [ ] Weekly/monthly stats
- [ ] Trip history displays
- [ ] Payment pending shown
- [ ] Completed payments shown
- [ ] Ratings displayed
- [ ] Performance metrics

### 4. Vendor App Testing

```bash
cd vendor_app
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
flutter run
```

#### Vendor Dashboard
- [ ] Vendor login works
- [ ] Dashboard displays
- [ ] Sales statistics shown
- [ ] Pending orders count
- [ ] Today's revenue displayed

#### Product Management
- [ ] Products list displays
- [ ] Add product works
- [ ] Edit product works
- [ ] Update stock works
- [ ] Update price works
- [ ] Product images upload
- [ ] Enable/disable product

#### Order Management
- [ ] Incoming orders display
- [ ] Order notification works
- [ ] View order details
- [ ] Accept order works
- [ ] Mark items packed
- [ ] Mark ready for pickup
- [ ] Order history

#### Inventory
- [ ] Stock levels display
- [ ] Low stock alerts
- [ ] Update stock works
- [ ] Stock history

#### Analytics
- [ ] Sales reports display
- [ ] Product performance
- [ ] Customer insights
- [ ] Revenue charts

---

## 🔗 Integration Testing

### End-to-End Customer Journey

1. **Complete Purchase Flow:**
   ```
   Register → Browse Products → Add to Cart →
   Select Address → Choose Time Slot → Apply Coupon →
   Make Payment → Track Order → Receive Order → Rate & Review
   ```

   - [ ] All steps work sequentially
   - [ ] Data persists across screens
   - [ ] No crashes or errors
   - [ ] Order reflects in admin panel
   - [ ] Delivery partner receives order
   - [ ] Real-time updates work

2. **Multi-Device Sync:**
   - [ ] Login on multiple devices
   - [ ] Cart syncs across devices
   - [ ] Wishlist syncs
   - [ ] Orders sync
   - [ ] Profile updates sync

### Backend-Frontend Integration

- [ ] API calls succeed
- [ ] Data formats match
- [ ] Error handling works
- [ ] Loading states display
- [ ] Success messages shown
- [ ] Error messages clear
- [ ] Network error handling
- [ ] Offline mode (if implemented)

### Real-Time Features

- [ ] Order status updates in real-time
- [ ] Delivery tracking updates
- [ ] Chat messages instant
- [ ] Notifications arrive promptly
- [ ] Stock updates reflect immediately
- [ ] Admin sees real-time orders

### Payment Integration

- [ ] Razorpay test payments work
- [ ] Stripe test payments work
- [ ] UPI payments work
- [ ] COD option selectable
- [ ] Payment callbacks work
- [ ] Failed payment handling
- [ ] Refund processing

---

## 🔐 Security Testing

### Authentication & Authorization

- [ ] Cannot access protected routes without login
- [ ] JWT tokens expire correctly
- [ ] Refresh token works
- [ ] Logout clears tokens
- [ ] Role-based access control works
- [ ] Admin cannot access delivery features
- [ ] Customer cannot access admin panel

### Input Validation

- [ ] Email validation works
- [ ] Phone number validation
- [ ] Password strength requirements
- [ ] SQL injection prevention
- [ ] XSS attack prevention
- [ ] CSRF protection (if implemented)

### Data Protection

- [ ] Passwords hashed
- [ ] Sensitive data encrypted
- [ ] HTTPS enforced (production)
- [ ] API keys not exposed
- [ ] Environment variables secure

---

## ⚡ Performance Testing

### App Performance

- [ ] App starts in < 3 seconds
- [ ] Screens load quickly
- [ ] Images load efficiently
- [ ] Smooth scrolling
- [ ] No UI freezing
- [ ] Animations smooth (60 FPS)
- [ ] Memory usage reasonable

### Backend Performance

- [ ] API responses < 500ms
- [ ] Handles 100+ concurrent users
- [ ] Database queries optimized
- [ ] Caching works correctly
- [ ] No memory leaks
- [ ] CPU usage reasonable

### Network Performance

- [ ] Works on slow networks (3G)
- [ ] Handles network interruptions
- [ ] Retry logic works
- [ ] Offline mode (if applicable)
- [ ] Image compression effective
- [ ] API payload sizes reasonable

---

## 🐛 Error Handling Testing

### User-Facing Errors

- [ ] Invalid login shows error
- [ ] Network error messages clear
- [ ] Form validation messages helpful
- [ ] Payment failure handled gracefully
- [ ] Out of stock shown clearly
- [ ] Server error messages user-friendly

### Developer Errors

- [ ] Backend logs errors properly
- [ ] Flutter errors logged
- [ ] Stack traces captured
- [ ] Error monitoring works (if implemented)
- [ ] Alerts for critical errors

---

## 📝 Testing Summary

After completing all tests above, fill out this summary:

### Test Results Overview

**Backend:**
- Total Tests: ___
- Passed: ___
- Failed: ___
- Blocked: ___

**Customer App:**
- Total Tests: ___
- Passed: ___
- Failed: ___
- Blocked: ___

**Admin App:**
- Total Tests: ___
- Passed: ___
- Failed: ___
- Blocked: ___

**Delivery App:**
- Total Tests: ___
- Passed: ___
- Failed: ___
- Blocked: ___

**Vendor App:**
- Total Tests: ___
- Passed: ___
- Failed: ___
- Blocked: ___

### Critical Issues Found

1.
2.
3.

### Non-Critical Issues Found

1.
2.
3.

### Recommendations

1.
2.
3.

---

## 📞 Getting Help

If you encounter issues during testing:

1. Check the [INSTALLATION_GUIDE.md](INSTALLATION_GUIDE.md) troubleshooting section
2. Review error logs:
   - Backend: `backend/logs/app.log`
   - Flutter: Console output from `flutter run`
3. Open an issue on GitHub with:
   - Test case that failed
   - Error messages
   - Screenshots
   - System information

---

**Last Updated**: 2025-11-14
**Version**: 1.0.0
**Maintained by**: Grocery E-Commerce Team
