import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/user_model.dart';

class ProfileScreen extends StatefulWidget {
  final User user;
  const ProfileScreen({super.key, required this.user});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _name;
  late final TextEditingController _email;
  late final TextEditingController _phone;

  @override
  void initState() {
    super.initState();
    _name = TextEditingController(text: widget.user.name);
    _email = TextEditingController(text: widget.user.email);
    _phone = TextEditingController(text: widget.user.phone);
  }

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _phone.dispose();
    super.dispose();
  }

  String? _validatePhone(String? v) {
    final value = (v ?? '').trim().replaceAll(RegExp(r'\D'), '');
    if (value.isEmpty) return 'กรุณากรอกเบอร์โทรศัพท์';
    if (!RegExp(r'^0\d{9}$').hasMatch(value)) return 'เบอร์โทรต้องเป็น 10 หลัก (ขึ้นต้น 0)';
    return null;
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;

    final updated = widget.user.copyWith(
      name: _name.text.trim(),
      email: _email.text.trim(),
      phone: _phone.text.trim().replaceAll(RegExp(r'\D'), ''),
    );

    Navigator.pop(context, updated); // ส่ง user ที่แก้แล้วกลับไปหน้าเดิม
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.always,
          child: Column(
            children: [
              TextFormField(
                controller: _name,
                decoration: const InputDecoration(labelText: 'ชื่อ'),
                validator: (v) => (v == null || v.trim().isEmpty) ? 'กรุณากรอกชื่อ' : null,
              ),
              TextFormField(
                controller: _email,
                decoration: const InputDecoration(labelText: 'อีเมล'),
                keyboardType: TextInputType.emailAddress,
                validator: (v) {
                  final value = (v ?? '').trim();
                  if (value.isEmpty) return 'กรุณากรอกอีเมล';
                  if (!RegExp(r'^[^@]+@[^@]+\.[^@]+$').hasMatch(value)) return 'รูปแบบอีเมลไม่ถูกต้อง';
                  return null;
                },
              ),
              TextFormField(
                controller: _phone,
                decoration: const InputDecoration(labelText: 'เบอร์โทรศัพท์', hintText: '0XXXXXXXXX'),
                keyboardType: TextInputType.phone,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                maxLength: 10,
                validator: _validatePhone,
              ),
              const SizedBox(height: 16),
              ElevatedButton(onPressed: _save, child: const Text('Save')),
            ],
          ),
        ),
      ),
    );
  }
}
