import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  String? _validatePhone(String? v) {
    final value = (v ?? '').trim();
    final digitsOnly = value.replaceAll(RegExp(r'\D'), '');
    // ตัวอย่าง: เบอร์ไทย 10 หลักขึ้นต้น 0
    if (digitsOnly.isEmpty) return 'กรุณากรอกเบอร์โทรศัพท์';
    if (!RegExp(r'^0\d{9}$').hasMatch(digitsOnly)) return 'เบอร์โทรต้องเป็น 10 หลัก (ขึ้นต้น 0)';
    // Note: RegExp checks 10 digits starting with 0
    return null;
  }

  void _register() {
    if (!_formKey.currentState!.validate()) return;

    // ที่นี่สามารถเรียก API เพื่อสมัครสมาชิกได้
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('สมัครสมาชิกสำเร็จ'),
        content: const Text('คุณสมัครสมาชิกเรียบร้อยแล้ว โปรดเข้าสู่ระบบ'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushReplacementNamed(context, '/login');
            },
            child: const Text('ตกลง'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('สมัครสมาชิก')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
          child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.always,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'ชื่อ'),
                validator: (v) => (v ?? '').trim().isEmpty ? 'กรุณากรอกชื่อ' : null,
                onChanged: (v) => setState(() {}),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'อีเมล'),
                keyboardType: TextInputType.emailAddress,
                validator: (v) {
                  final value = (v ?? '').trim();
                  if (value.isEmpty) return 'กรุณากรอกอีเมล';
                  if (!RegExp(r"^[^@\s]+@[^@\s]+\.[^@\s]+$").hasMatch(value)) return 'อีเมลไม่ถูกต้อง';
                  return null;
                },
                onChanged: (v) => setState(() {}),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(labelText: 'เบอร์โทรศัพท์', hintText: '0XXXXXXXXX'),
                keyboardType: TextInputType.phone,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                maxLength: 10,
                validator: _validatePhone,
                onChanged: (v) => setState(() {}),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(labelText: 'รหัสผ่าน'),
                obscureText: true,
                validator: (v) {
                  final value = (v ?? '').trim();
                  if (value.isEmpty) return 'กรุณากรอกรหัสผ่าน';
                  if (value.length < 6) return 'รหัสผ่านต้องมีอย่างน้อย 6 ตัวอักษร';
                  return null;
                },
                onChanged: (v) => setState(() {}),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _confirmController,
                decoration: const InputDecoration(labelText: 'ยืนยันรหัสผ่าน'),
                obscureText: true,
                validator: (v) {
                  final value = (v ?? '').trim();
                  if (value.isEmpty) return 'กรุณายืนยันรหัสผ่าน';
                  if (value != _passwordController.text.trim()) return 'รหัสผ่านไม่ตรงกัน';
                  return null;
                },
                onChanged: (v) => setState(() {}),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _register,
                  child: const Text('สมัครสมาชิก'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
