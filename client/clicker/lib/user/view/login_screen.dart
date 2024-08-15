// 로그인 화면 -> 앱의 완성도를 위한 형식적인 구성

import 'package:clicker/common/const/colors.dart';
import 'package:clicker/common/view/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:clicker/user/provider/user_provider.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  // 학생 번호와 비밀번호 입력 필드를 제어하는 컨트롤러
  final TextEditingController _studentNumberController =
      TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // 폼의 상태를 관리하는 키
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // 로딩 상태를 나타내는 플래그
  bool _isLoading = false;

  @override
  void dispose() {
    // 위젯이 해제될 때 컨트롤러도 함께 해제
    _studentNumberController.dispose();
    _passwordController.dispose();

    super.dispose();
  }

  // 로그인 시도 메서드
  Future<void> _login() async {
    // 폼 유효성 검사
    if (!_formKey.currentState!.validate()) return;

    _setLoading(true);

    // 입력된 학생 번호와 비밀번호를 가져옴
    final int studentNumber = int.parse(_studentNumberController.text);
    final String password = _passwordController.text;

    try {
      // 유저 프로바이더를 통해 로그인 시도
      await ref.read(userProvider.notifier).login(studentNumber, password);

      // 로그인 성공 시 스낵바 표시 및 홈 화면으로 이동
      _showSnackbar('Login successful');
      _navigateToHomeScreen();
    } catch (e) {
      // 로그인 실패 시 스낵바 표시
      _showSnackbar('Login failed. Please try again.');
    } finally {
      _setLoading(false);
    }
  }

  // 로딩 상태 업데이트
  void _setLoading(bool value) {
    setState(() {
      _isLoading = value;
    });
  }

  // 스낵바 메시지 표시
  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  // 홈 화면으로 이동
  void _navigateToHomeScreen() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const HomeScreen()),
    );
  }

  // 로그인 화면 UI 빌드
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: PRIMARY_COLOR,
        title: const Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // 학생 번호 입력 필드
              CustomTextField(
                controller: _studentNumberController,
                label: 'Student Number',
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your student number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              // 비밀번호 입력 필드
              CustomTextField(
                controller: _passwordController,
                label: 'Password',
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              // 로그인 버튼 또는 로딩 인디케이터
              _isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: _login,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: PRIMARY_COLOR,
                      ),
                      child: const Text('Login'),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}

// 커스텀 입력 필드 위젯
class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final bool obscureText;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;

  const CustomTextField({
    required this.controller,
    required this.label,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.validator,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(labelText: label),
      obscureText: obscureText,
      keyboardType: keyboardType,
      validator: validator,
    );
  }
}
