import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'signup_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  final _otpController = TextEditingController();
  
  bool _isLoading = false;
  bool _codeSent = false;

  @override
  void dispose() {
    _phoneController.dispose();
    _otpController.dispose();
    super.dispose();
  }

  Future<void> _sendOTP() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      String phoneNumber = _phoneController.text.trim();
      
      // Add country code if not present
      if (!phoneNumber.startsWith('+')) {
        phoneNumber = '+91$phoneNumber'; // Default to India (+91)
      }

      // For testing purposes, directly set the OTP screen without Firebase verification
      if (mounted) {
        setState(() {
          _codeSent = true;
          _isLoading = false;
        });
        
        // Auto-fill the OTP field with 6-digit test OTP
        _otpController.text = '123456';
        
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Test OTP is 123456')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _verifyOTP() async {
    final otp = _otpController.text.trim();
    
    if (otp.isEmpty || otp.length != 6) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please enter a valid 6-digit OTP')),
        );
      }
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // For testing with hardcoded 6-digit OTP '123456'
      if (otp == '123456') {
        // Clear the OTP field
        _otpController.clear();
        
        if (mounted) {
          // Show success message
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Login successful!')),
          );
          
          // Navigate to home screen
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => const HomeScreen(),
            ),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Invalid OTP. Please enter 123456 for testing.')),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _resendOTP() {
    setState(() {
      _codeSent = false;
      _otpController.clear();
    });
    _sendOTP();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 40),
              Icon(
                Icons.phone_android,
                size: 80,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(height: 24),
              Text(
                _codeSent ? 'Enter OTP' : 'Enter Phone Number',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                _codeSent
                    ? 'We sent a code to ${_phoneController.text}'
                    : 'We will send you a one-time password',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey[600],
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              if (!_codeSent) ...[
                TextFormField(
                  controller: _phoneController,
                  decoration: InputDecoration(
                    labelText: 'Phone Number',
                    hintText: '10-digit mobile number',
                    prefixIcon: const Icon(Icons.phone),
                    prefixText: '+91 ',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  keyboardType: TextInputType.phone,
                  maxLength: 10,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your phone number';
                    }
                    if (value.length != 10) {
                      return 'Please enter a valid 10-digit number';
                    }
                    if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                      return 'Please enter only numbers';
                    }
                    return null;
                  },
                ),
              ] else ...[
                TextFormField(
                  controller: _otpController,
                  decoration: InputDecoration(
                    labelText: 'OTP',
                    hintText: '6-digit code',
                    prefixIcon: const Icon(Icons.lock),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                  maxLength: 6,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 24,
                    letterSpacing: 8,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Didn't receive the code? "),
                    TextButton(
                      onPressed: _isLoading ? null : _resendOTP,
                      child: const Text('Resend'),
                    ),
                  ],
                ),
              ],
              const SizedBox(height: 24),
              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                      onPressed: _codeSent ? _verifyOTP : _sendOTP,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        _codeSent ? 'Verify OTP' : 'Send OTP',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
              if (_codeSent) ...[
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () {
                    setState(() {
                      _codeSent = false;
                      _otpController.clear();
                    });
                  },
                  child: const Text('Change Phone Number'),
                ),
              ],
              if (!_codeSent) ...[
                const SizedBox(height: 16),
                Center(
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const SignUpScreen()),
                      );
                    },
                    child: const Text('Create an account'),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
