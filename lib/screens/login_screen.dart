import 'package:flutter/material.dart';
// No model import needed here since we pass a Map to HomeScreen

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      // จำลองการรอ API (ของจริงก็เรียก API ตรงนี้)
      await Future.delayed(const Duration(seconds: 1));

      final newUser = {
        'name': 'User',
        'email': _emailController.text.trim(),
        'phone': '0123456789',
      };

      if (!mounted) return;
      Navigator.pushNamed(context, '/home', arguments: newUser);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('เข้าสู่ระบบ')),
      body: Stack(
        children: [
          // ปิดการโต้ตอบของฟอร์มขณะโหลด
          AbsorbPointer(
            absorbing: _isLoading,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextFormField(
                      controller: _emailController,
                      enabled: !_isLoading,
                      decoration: const InputDecoration(labelText: 'อีเมล'),
                      keyboardType: TextInputType.emailAddress,
                      validator: (v) {
                        final value = (v ?? '').trim();
                        if (value.isEmpty) return 'กรุณากรอกอีเมล';
                        if (!RegExp(r"^[^@\s]+@[^@\s]+\.[^@\s]+$").hasMatch(value)) return 'อีเมลไม่ถูกต้อง';
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _passwordController,
                      enabled: !_isLoading,
                      decoration: const InputDecoration(labelText: 'รหัสผ่าน'),
                      obscureText: true,
                      validator: (v) => (v ?? '').trim().isEmpty ? 'กรุณากรอกรหัสผ่าน' : null,
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _login,
                        child: _isLoading
                            ? const SizedBox(
                                height: 16,
                                width: 16,
                                child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                              )
                            : const Text('เข้าสู่ระบบ'),
                      ),
                    ),
                    TextButton(
                      onPressed: _isLoading ? null : () => Navigator.pushNamed(context, '/register'),
                      child: const Text('สมัครสมาชิก'),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Overlay loading indicator
          if (_isLoading)
            Positioned.fill(
              child: Container(
                color: Colors.black45,
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
