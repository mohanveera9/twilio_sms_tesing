import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class TwilioVerifyService {
  // Load credentials from .env file
  static String get accountSid => dotenv.env['TWILIO_ACCOUNT_SID'] ?? '';
  static String get authToken => dotenv.env['TWILIO_AUTH_TOKEN'] ?? '';
  static String get verifyServiceSid => dotenv.env['TWILIO_VERIFY_SERVICE_SID'] ?? '';

  // Send OTP to phone number
  static Future<Map<String, dynamic>> sendOtp(String phoneNumber) async {
    if (accountSid.isEmpty || authToken.isEmpty || verifyServiceSid.isEmpty) {
      return {
        "success": false,
        "message": "Twilio credentials not configured. Check your .env file.",
      };
    }

    final String url =
        "https://verify.twilio.com/v2/Services/$verifyServiceSid/Verifications";
    
    final String basicAuth =
        "Basic ${base64Encode(utf8.encode('$accountSid:$authToken'))}";

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          HttpHeaders.authorizationHeader: basicAuth,
          "Content-Type": "application/x-www-form-urlencoded",
        },
        body: {
          "To": phoneNumber,
          "Channel": "sms",
        },
      );

      print("STATUS CODE: ${response.statusCode}");
      print("RESPONSE: ${response.body}");

      if (response.statusCode == 201 || response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {
          "success": true,
          "message": "OTP sent successfully",
          "sid": data['sid'],
          "status": data['status'],
        };
      } else {
        final error = jsonDecode(response.body);
        return {
          "success": false,
          "message": error['message'] ?? "Failed to send OTP",
          "code": error['code'],
        };
      }
    } catch (e) {
      return {
        "success": false,
        "message": "Exception: $e",
      };
    }
  }

  // Verify OTP entered by user
  static Future<Map<String, dynamic>> verifyOtp(
    String phoneNumber,
    String otpCode,
  ) async {
    final String url =
        "https://verify.twilio.com/v2/Services/$verifyServiceSid/VerificationCheck";
    
    final String basicAuth =
        "Basic ${base64Encode(utf8.encode('$accountSid:$authToken'))}";

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          HttpHeaders.authorizationHeader: basicAuth,
          "Content-Type": "application/x-www-form-urlencoded",
        },
        body: {
          "To": phoneNumber,
          "Code": otpCode,
        },
      );

      print("VERIFY STATUS CODE: ${response.statusCode}");
      print("VERIFY RESPONSE: ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == 'approved') {
          return {
            "success": true,
            "message": "OTP verified successfully",
            "status": data['status'],
          };
        } else {
          return {
            "success": false,
            "message": "Invalid OTP code",
            "status": data['status'],
          };
        }
      } else {
        final error = jsonDecode(response.body);
        return {
          "success": false,
          "message": error['message'] ?? "Verification failed",
        };
      }
    } catch (e) {
      return {
        "success": false,
        "message": "Exception: $e",
      };
    }
  }
}