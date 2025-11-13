import 'package:flutter/material.dart';
import 'package:twilio_app/send_sms_feature.dart';

class OtpVerificationPage extends StatefulWidget {
  const OtpVerificationPage({super.key});

  @override
  State<OtpVerificationPage> createState() => _OtpVerificationPageState();
}

class _OtpVerificationPageState extends State<OtpVerificationPage> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  
  String resultMessage = "";
  bool isOtpSent = false;
  bool isLoading = false;

  String _formatPhoneNumber(String phone) {
    // Remove all non-digit characters
    String cleaned = phone.replaceAll(RegExp(r'[^\d+]'), '');
    
    // If doesn't start with +, add +91 for India
    if (!cleaned.startsWith('+')) {
      cleaned = '+91$cleaned';
    }
    
    return cleaned;
  }

  Future<void> _sendOtp() async {
    if (_phoneController.text.isEmpty) {
      setState(() {
        resultMessage = "Please enter a phone number";
      });
      return;
    }

    setState(() {
      isLoading = true;
      resultMessage = "Sending OTP...";
    });

    String formattedPhone = _formatPhoneNumber(_phoneController.text);
    final result = await TwilioVerifyService.sendOtp(formattedPhone);

    setState(() {
      isLoading = false;
      if (result['success']) {
        isOtpSent = true;
        resultMessage = "✅ ${result['message']}\nCheck your phone for OTP";
      } else {
        resultMessage = "❌ ${result['message']}";
      }
    });
  }

  Future<void> _verifyOtp() async {
    if (_otpController.text.isEmpty) {
      setState(() {
        resultMessage = "Please enter the OTP code";
      });
      return;
    }

    setState(() {
      isLoading = true;
      resultMessage = "Verifying OTP...";
    });

    String formattedPhone = _formatPhoneNumber(_phoneController.text);
    final result = await TwilioVerifyService.verifyOtp(
      formattedPhone,
      _otpController.text,
    );

    setState(() {
      isLoading = false;
      if (result['success']) {
        resultMessage = "✅ ${result['message']}";
      } else {
        resultMessage = "❌ ${result['message']}";
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Twilio OTP Verification'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 40),
            const Icon(
              Icons.phone_android,
              size: 80,
              color: Colors.deepPurple,
            ),
            const SizedBox(height: 40),
            
            // Phone Number Input
            TextField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              enabled: !isOtpSent,
              decoration: InputDecoration(
                labelText: 'Phone Number',
                hintText: '9502774125 or +919502774125',
                helperText: 'Enter 10-digit number (country code optional)',
                prefixIcon: const Icon(Icons.phone),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 20),
            
            // Send OTP Button
            if (!isOtpSent)
              ElevatedButton(
                onPressed: isLoading ? null : _sendOtp,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text(
                        'Send OTP',
                        style: TextStyle(fontSize: 16),
                      ),
              ),
            
            // OTP Input (shown after sending OTP)
            if (isOtpSent) ...[
              TextField(
                controller: _otpController,
                keyboardType: TextInputType.number,
                maxLength: 6,
                decoration: InputDecoration(
                  labelText: 'Enter OTP',
                  hintText: '123456',
                  prefixIcon: const Icon(Icons.lock),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              
              // Verify OTP Button
              ElevatedButton(
                onPressed: isLoading ? null : _verifyOtp,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Colors.green,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Text(
                        'Verify OTP',
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
              ),
              const SizedBox(height: 12),
              
              // Reset Button
              TextButton(
                onPressed: () {
                  setState(() {
                    isOtpSent = false;
                    _otpController.clear();
                    resultMessage = "";
                  });
                },
                child: const Text('Change Phone Number'),
              ),
            ],
            
            const SizedBox(height: 30),
            
            // Result Message
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                resultMessage.isEmpty ? "Enter your phone number to receive OTP" : resultMessage,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: resultMessage.startsWith('✅')
                      ? Colors.green[700]
                      : resultMessage.startsWith('❌')
                          ? Colors.red[700]
                          : Colors.grey[700],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _otpController.dispose();
    super.dispose();
  }
}