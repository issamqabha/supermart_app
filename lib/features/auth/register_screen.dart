import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/utils/app_utils.dart';
import '../../../shared/widgets/custom_button.dart';
import '../../../shared/animations/opaque_transition.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  bool _isPasswordVisible = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: AppUtils.getGradient(AppColors.background, Colors.white),
            ),
          ),
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    const SizedBox(height: 60),
                    OpaqueTransition(
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: IconButton(
                          icon: const Icon(Icons.arrow_back),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ),
                    ),
                    OpaqueTransition(
                      child: _buildAnimatedLogo(),
                      delay: const Duration(milliseconds: 100),
                    ),
                    const SizedBox(height: 30),
                    OpaqueTransition(
                      child: Text(
                        'انضم إلينا الآن!',
                        style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: AppColors.textDark),
                      ),
                      delay: const Duration(milliseconds: 200),
                    ),
                    const SizedBox(height: 30),
                    OpaqueTransition(
                      child: _buildTextField('الاسم الكامل', _nameController, Icons.person, (v) => v!.isEmpty ? 'أدخل اسمك' : null),
                      delay: const Duration(milliseconds: 300),
                    ),
                    const SizedBox(height: 20),
                    OpaqueTransition(
                      child: _buildTextField('البريد الإلكتروني', _emailController, Icons.email, (v) => !v!.contains('@') ? 'بريد غير صحيح' : null),
                      delay: const Duration(milliseconds: 400),
                    ),
                    const SizedBox(height: 20),
                    OpaqueTransition(
                      child: _buildPasswordField(),
                      delay: const Duration(milliseconds: 500),
                    ),
                    const SizedBox(height: 20),
                    OpaqueTransition(
                      child: _buildTextField('رقم الهاتف', _phoneController, Icons.phone, null, TextInputType.phone),
                      delay: const Duration(milliseconds: 600),
                    ),
                    const SizedBox(height: 20),
                    OpaqueTransition(
                      child: _buildTextField('العنوان', _addressController, Icons.location_on),
                      delay: const Duration(milliseconds: 700),
                    ),
                    const SizedBox(height: 30),
                    OpaqueTransition(
                      child: _buildRegisterButton(),
                      delay: const Duration(milliseconds: 800),
                    ),
                    const SizedBox(height: 20),
                    OpaqueTransition(
                      child: _buildLoginLink(),
                      delay: const Duration(milliseconds: 900),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedLogo() {
    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        gradient: AppUtils.getGradient(AppColors.primary, AppColors.accent),
        borderRadius: BorderRadius.circular(60),
        boxShadow: [BoxShadow(color: AppColors.primary.withOpacity(0.3), blurRadius: 15)],
      ),
      child: const Icon(Icons.person_add, size: 50, color: Colors.white),
    ).animate().scale(duration: 800.ms, curve: Curves.elasticOut).shake(duration: 600.ms);
  }

  Widget _buildTextField(String label, TextEditingController controller, IconData icon, [String? Function(String?)? validator, TextInputType? keyboardType = TextInputType.text]) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: AppColors.primary),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: AppColors.primary, width: 2),
        ),
      ),
    );
  }

  Widget _buildPasswordField() {
    return TextFormField(
      controller: _passwordController,
      obscureText: !_isPasswordVisible,
      validator: (value) => value!.length < 6 ? 'كلمة المرور قصيرة' : null,
      decoration: InputDecoration(
        labelText: 'كلمة المرور',
        prefixIcon: Icon(Icons.lock, color: AppColors.primary),
        suffixIcon: IconButton(
          icon: Icon(_isPasswordVisible ? Icons.visibility : Icons.visibility_off, color: AppColors.primary),
          onPressed: () => setState(() => _isPasswordVisible = !_isPasswordVisible),
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
      ),
    );
  }

  Widget _buildRegisterButton() {
    return Container(
      width: double.infinity,
      height: 55,
      decoration: BoxDecoration(
        gradient: AppUtils.getGradient(AppColors.primary, AppColors.accent),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [BoxShadow(color: AppColors.primary.withOpacity(0.4), blurRadius: 10, offset: const Offset(0, 5))],
      ),
      child: CustomButton(
        text: 'إنشاء حساب',
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            showDialog(
              context: context,
              builder: (context) => _buildSuccessDialog(),
            );
          }
        },
      ),
    );
  }

  Widget _buildLoginLink() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text('لديك حساب بالفعل؟'),
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('سجل الدخول', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }

  Widget _buildSuccessDialog() {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(30),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppColors.success.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.check, size: 40, color: AppColors.success),
            ).animate().scale(duration: 500.ms, curve: Curves.elasticOut),
            const SizedBox(height: 20),
            const Text('تم إنشاء الحساب بنجاح!', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            const Text('مرحباً بك في عائلة Supermart'),
            const SizedBox(height: 20),
            CustomButton(
              text: 'ابدء التسوق',
              onPressed: () {
                Navigator.pop(context);
                Navigator.pushReplacementNamed(context, '/home');
              },
            ),
          ],
        ),
      ),
    ).animate().fadeIn().scale();
  }
}