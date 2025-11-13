# 📱 Twilio OTP Verification - Flutter App

A secure Flutter application that implements phone number verification using Twilio's Verify API. This app sends OTP (One-Time Password) codes via SMS and verifies them in real-time.

![Flutter](https://img.shields.io/badge/Flutter-02569B?style=flat&logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-0175C2?style=flat&logo=dart&logoColor=white)
![Twilio](https://img.shields.io/badge/Twilio-F22F46?style=flat&logo=twilio&logoColor=white)

## ✨ Features

- 🔐 **Secure OTP Authentication** - Phone number verification via SMS
- 🌍 **International Support** - Works with phone numbers worldwide (E.164 format)
- 🎨 **Modern UI** - Clean and intuitive Material Design interface
- 🔒 **Environment Variables** - Credentials stored securely in `.env` file
- ⚡ **Real-time Verification** - Instant OTP validation
- 📱 **Flexible Input** - Accepts various phone number formats

## 🚀 Getting Started

### Prerequisites

- Flutter SDK (3.0.0 or higher)
- Dart SDK
- A Twilio account ([Sign up here](https://www.twilio.com/try-twilio))
- Android Studio / VS Code with Flutter extensions

### Twilio Setup

1. **Create a Twilio Account**
   - Go to [Twilio Console](https://console.twilio.com/)
   - Sign up for a free account

2. **Get Your Credentials**
   - Navigate to [Account Dashboard](https://console.twilio.com/)
   - Copy your `Account SID` and `Auth Token`

3. **Create a Verify Service**
   - Go to [Verify Services](https://console.twilio.com/us1/develop/verify/services)
   - Click "Create new Service"
   - Give it a name (e.g., "My App OTP")
   - Copy the `Service SID`

### Installation

1. **Clone the repository**
```bash
   git clone https://github.com/yourusername/twilio-otp-verify.git
   cd twilio-otp-verify
```

2. **Install dependencies**
```bash
   flutter pub get
```

3. **Configure environment variables**
   
   Create a `.env` file in the project root:
```bash
   cp .env.example .env
```
   
   Edit `.env` and add your Twilio credentials:
```env
   TWILIO_ACCOUNT_SID=ACxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
   TWILIO_AUTH_TOKEN=your_auth_token_here
   TWILIO_VERIFY_SERVICE_SID=VAxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
```

4. **Run the app**
```bash
   flutter run
```

## 📂 Project Structure
```
lib/
├── main.dart                    # App entry point & UI
└── twilio_verify_service.dart   # Twilio API integration

.env                             # Environment variables (DO NOT COMMIT)
.env.example                     # Template for environment variables
.gitignore                       # Git ignore rules
pubspec.yaml                     # Flutter dependencies
README.md                        # This file
```

## 🔧 Configuration

### Environment Variables

| Variable | Description | Example |
|----------|-------------|---------|
| `TWILIO_ACCOUNT_SID` | Your Twilio Account SID | `AC1234567890abcdef...` |
| `TWILIO_AUTH_TOKEN` | Your Twilio Auth Token | `your_secret_token` |
| `TWILIO_VERIFY_SERVICE_SID` | Verify Service SID | `VA1234567890abcdef...` |

### Phone Number Format

The app automatically formats phone numbers to E.164 format:

- **Input:** `9502774125` → **Formatted:** `+919502774125`
- **Input:** `+919502774125` → **Formatted:** `+919502774125`
- **Input:** `95 027 741 25` → **Formatted:** `+919502774125`

Default country code: `+91` (India). To change, modify `_formatPhoneNumber()` in `main.dart`.

## 📖 How to Use

1. **Launch the app**
2. **Enter your phone number** (with or without country code)
3. **Click "Send OTP"** - You'll receive a 6-digit code via SMS
4. **Enter the OTP code** you received
5. **Click "Verify OTP"** - App will confirm if the code is valid ✅

## 🛠️ API Integration

### Send OTP
```dart
final result = await TwilioVerifyService.sendOtp('+919502774125');
```

**Response:**
```dart
{
  "success": true,
  "message": "OTP sent successfully",
  "sid": "VExxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx",
  "status": "pending"
}
```

### Verify OTP
```dart
final result = await TwilioVerifyService.verifyOtp('+919502774125', '123456');
```

**Response:**
```dart
{
  "success": true,
  "message": "OTP verified successfully",
  "status": "approved"
}
```

## 🔒 Security Best Practices

- ✅ **Never commit `.env` file** to version control
- ✅ **Use `.env.example`** as a template for other developers
- ✅ **Rotate credentials regularly** in production
- ✅ **Use different credentials** for development and production
- ✅ **Enable rate limiting** on Twilio dashboard
- ✅ **Implement IP whitelisting** for production APIs

## 🐛 Troubleshooting

### Error: "Invalid parameter 'To'"
**Solution:** Make sure phone number includes country code (e.g., `+919502774125`)

### Error: "Twilio credentials not configured"
**Solution:** Check if `.env` file exists and contains valid credentials

### OTP not received
**Solution:** 
- Verify phone number is correct and can receive SMS
- Check Twilio account has sufficient balance
- Review Twilio console logs for delivery status

### Build errors
**Solution:**
```bash
flutter clean
flutter pub get
flutter run
```

## 📊 Twilio Pricing

- **Free Trial:** $15.50 credit (approx 500 verifications)
- **Verify API:** $0.05 per verification attempt
- **SMS Delivery:** Included in verification cost

[View detailed pricing](https://www.twilio.com/verify/pricing)

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

1. Fork the project
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🔗 Resources

- [Twilio Verify API Documentation](https://www.twilio.com/docs/verify/api)
- [Flutter Documentation](https://docs.flutter.dev/)
- [Twilio Console](https://console.twilio.com/)
- [E.164 Phone Number Format](https://en.wikipedia.org/wiki/E.164)

## 💬 Support

If you encounter any issues or have questions:

- 📧 Email: your.email@example.com
- 🐛 [Open an issue](https://github.com/yourusername/twilio-otp-verify/issues)
- 📚 [Twilio Support](https://support.twilio.com/)

---

**Made with ❤️ using Flutter and Twilio**