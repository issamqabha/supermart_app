import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/utils/app_utils.dart';
import '../../../shared/widgets/custom_button.dart';
import '../../../shared/animations/opaque_transition.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(height: 80),
                OpaqueTransition(
                  child: _buildLogo(),
                ),
                const SizedBox(height: 40),
                OpaqueTransition(
                  child: _buildEmailField(),
                  delay: const Duration(milliseconds: 200),
                ),
                const SizedBox(height: 20),
                OpaqueTransition(
                  child: _buildPasswordField(),
                  delay: const Duration(milliseconds: 400),
                ),
                const SizedBox(height: 30),
                OpaqueTransition(
                  child: _buildLoginButton(),
                  delay: const Duration(milliseconds: 600),
                ),
                const SizedBox(height: 20),
                OpaqueTransition(
                  child: _buildRegisterLink(),
                  delay: const Duration(milliseconds: 700),
                ),
                const SizedBox(height: 20),
                OpaqueTransition(
                  child: _buildTestLogin(),
                  delay: const Duration(milliseconds: 800),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Container(
      width: 150,
      height: 150,
      decoration: BoxDecoration(
        gradient: AppUtils.getGradient(AppColors.primary, AppColors.accent),
        borderRadius: BorderRadius.circular(75),
        boxShadow: [BoxShadow(color: AppColors.primary.withOpacity(0.3), blurRadius: 15)],
      ),
      child: const Icon(
        Icons.shopping_bag,
        size: 70,
        color: Colors.white,
      ),
    ).animate().scale(duration: 600.ms).shake(delay: 300.ms);
  }

  Widget _buildEmailField() {
    return TextFormField(
      controller: _emailController,
      validator: (value) => !value!.contains('@') ? 'بريد إلكتروني غير صحيح' : null,
      decoration: InputDecoration(
        labelText: 'البريد الإلكتروني',
        prefixIcon: const Icon(Icons.email),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
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
        prefixIcon: const Icon(Icons.lock),
        suffixIcon: IconButton(
          icon: Icon(_isPasswordVisible ? Icons.visibility : Icons.visibility_off),
          onPressed: () => setState(() => _isPasswordVisible = !_isPasswordVisible),
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
      ),
    );
  }

  Widget _buildLoginButton() {
    return CustomButton(
      text: 'تسجيل الدخول',
      onPressed: () {
        if (_formKey.currentState!.validate()) {
          Navigator.pushNamed(context, '/home');
        }
      },
    );
  }

  Widget _buildRegisterLink() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text('ليس لديك حساب؟'),
        TextButton(
          onPressed: () => Navigator.pushNamed(context, '/register'),
          child: Text('إنشاء حساب', style: TextStyle(color: Theme.of(context).primaryColor)),
        ),
      ],
    );
  }

  Widget _buildTestLogin() {
    return Column(
      children: [
        const Text('أو جرب التطبيق الآن'),
        const SizedBox(height: 20),
        CustomButton(
          text: 'دخول تجريبي',
          onPressed: () {
            Navigator.pushNamed(context, '/home');
          },
          color: AppColors.secondary,
        ),
      ],
    );
  }
}