import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../controllers/controllers.dart';
import '../../utils/utils.dart';
import 'reset_password_view.dart';

class EnterOtpView extends StatefulWidget {
  final String? email; // Make email optional

  const EnterOtpView({
    super.key,
    this.email, // Optional parameter
  });

  @override
  State<EnterOtpView> createState() => _EnterOtpViewState();
}

class _EnterOtpViewState extends State<EnterOtpView> {
  final List<TextEditingController> _otpControllers =
      List.generate(6, (index) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (index) => FocusNode());

  @override
  void dispose() {
    for (var controller in _otpControllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  void _onOtpChanged(String value, int index) {
    if (value.isNotEmpty && index < 5) {
      _focusNodes[index + 1].requestFocus();
    } else if (value.isEmpty && index > 0) {
      _focusNodes[index - 1].requestFocus();
    }

    // Check if all fields are filled
    bool allFilled =
        _otpControllers.every((controller) => controller.text.isNotEmpty);
    if (allFilled) {
      _handleVerifyOtp();
    }
  }

  Future<void> _handleVerifyOtp() async {
    final otp = _otpControllers.map((controller) => controller.text).join();
    final email = widget.email ?? 'user@example.com'; // Provide default if null

    if (otp.length != 6) {
      DialogUtils.showError(
        context,
        message: 'Please enter the complete OTP',
      );
      return;
    }

    final authController = Provider.of<AuthController>(context, listen: false);

    final success = await authController.verifyOtp(email, otp);

    if (!mounted) return;

    if (success) {
      // Navigate to reset password with token (in real app, token would come from API)
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ResetPasswordView(token: 'verified-$otp'),
        ),
      );
    } else {
      DialogUtils.showError(
        context,
        message: authController.error ?? 'Invalid OTP',
      );
      // Clear OTP fields on error
      for (var controller in _otpControllers) {
        controller.clear();
      }
      _focusNodes[0].requestFocus();
    }
  }

  Future<void> _handleResendOtp() async {
    final authController = Provider.of<AuthController>(context, listen: false);
    final email = widget.email ?? 'user@example.com'; // Provide default if null

    final success = await authController.forgotPassword(email);

    if (!mounted) return;

    if (success) {
      DialogUtils.showAlert(
        context,
        title: 'OTP Resent',
        message: 'A new OTP has been sent to your email address.',
      );
    } else {
      DialogUtils.showError(
        context,
        message: authController.error ?? 'Failed to resend OTP',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Consumer<AuthController>(
        builder: (context, authController, child) {
          return SingleChildScrollView(
            child: Column(
              children: [
                // Curved teal header with mail icon
                Container(
                  height: 200,
                  decoration: const BoxDecoration(
                    color: Color(0xFF4ECDC4),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(100),
                      bottomRight: Radius.circular(100),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 120),
                    child: Center(
                      child: Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(40),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Image.asset(
                            'assets/images/otp.png',
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) {
                              return const Icon(
                                Icons.lock_outline,
                                size: 35,
                                color: Color(0xFF4285F4),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                // Content
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Back button
                      Align(
                        alignment: Alignment.centerLeft,
                        child: IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: const Icon(
                            Icons.arrow_back,
                            color: Color(0xFF2D3748),
                            size: 24,
                          ),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                      ),

                      const SizedBox(height: 32),

                      // Title
                      const Text(
                        'OTP Verification',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2D3748),
                        ),
                      ),

                      const SizedBox(height: 8),

                      Text(
                        'Enter the verification code we just sent on your email address.',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                          height: 1.4,
                        ),
                      ),

                      const SizedBox(height: 32),

                      // OTP input fields
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: List.generate(6, (index) {
                          return SizedBox(
                            width: 45,
                            height: 55,
                            child: TextFormField(
                              controller: _otpControllers[index],
                              focusNode: _focusNodes[index],
                              keyboardType: TextInputType.number,
                              textAlign: TextAlign.center,
                              maxLength: 1,
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF2D3748),
                              ),
                              decoration: InputDecoration(
                                counterText: "",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide:
                                      BorderSide(color: Colors.grey[300]!),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide:
                                      BorderSide(color: Colors.grey[300]!),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(
                                      color: Color(0xFF4ECDC4), width: 2),
                                ),
                                filled: true,
                                fillColor: Colors.grey[50],
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 12,
                                ),
                              ),
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                              onChanged: (value) => _onOtpChanged(value, index),
                            ),
                          );
                        }),
                      ),

                      const SizedBox(height: 32),

                      // Verify button
                      ElevatedButton(
                        onPressed:
                            authController.isLoading ? null : _handleVerifyOtp,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2D3748),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 18),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 0,
                        ),
                        child: authController.isLoading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white),
                                ),
                              )
                            : const Text(
                                'Verify',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                      ),

                      const SizedBox(height: 24),

                      // Resend code
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Didn't received code? ",
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 14,
                            ),
                          ),
                          TextButton(
                            onPressed: authController.isLoading
                                ? null
                                : _handleResendOtp,
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                            ),
                            child: const Text(
                              'Resend',
                              style: TextStyle(
                                color: Color(0xFF4ECDC4),
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
