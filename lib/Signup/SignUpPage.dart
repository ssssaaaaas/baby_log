import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'SignUpPage2.dart'; // Import the new page
class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);
  @override
  _SignupPageState createState() => _SignupPageState();
}
class _SignupPageState extends State<SignUpPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _birthdateController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Future<void> _sendVerificationEmail() async {
    try {
      await _auth.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      User? user = _auth.currentUser;
      if (user != null && !user.emailVerified) {
        await user.sendEmailVerification();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('인증 이메일이 발송되었습니다. 이메일을 확인하세요.'),
            duration: Duration(milliseconds: 500),
          ),
        );
      }
    } catch (e) {
      print("이메일 인증 실패: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('이메일 인증 실패: ${e.toString()}'),
          duration: Duration(milliseconds: 500),
        ),
      );
    }
  }
  Future<void> _verifyEmail() async {
    try {
      User? user = _auth.currentUser;
      await user?.reload();
      if (user != null && user.emailVerified) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('이메일 인증 완료!'),
            duration: Duration(milliseconds: 500),
          ),
        );
        await _firestore.collection('users').doc(user.uid).set({
          'ID': _idController.text.trim(),
          'birthdate': _birthdateController.text.trim(),
          'email': _emailController.text.trim(),
        });
        // 이메일 인증이 완료되면 SignUpPage2로 이동
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => SignUpPage2()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('이메일 인증을 완료해주세요.'),
            duration: Duration(milliseconds: 500),
          ),
        );
      }
    } catch (e) {
      print("이메일 확인 실패: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('이메일 확인 실패: ${e.toString()}'),
          duration: Duration(milliseconds: 500),
        ),
      );
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('회원가입'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '아이와 부모를 위한\nBaby_log',
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32.0),
              TextField(
                controller: _idController,
                decoration: InputDecoration(
                  labelText: '아이디',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16.0),
              TextField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: '비밀번호',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
              ),
              const SizedBox(height: 16.0),
              TextField(
                controller: _birthdateController,
                decoration: InputDecoration(
                  labelText: '생년월일 (YYYY/MM/DD)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.datetime,
              ),
              const SizedBox(height: 16.0),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: '이메일 인증',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 8.0),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _sendVerificationEmail,
                      child: Text('인증받기'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        padding:
                            EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                        textStyle: TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                  SizedBox(width: 8.0),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _verifyEmail,
                      child: Text('인증확인'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        padding:
                            EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                        textStyle: TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32.0),
              ElevatedButton(
                onPressed: _verifyEmail,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  textStyle: TextStyle(fontSize: 18),
                ),
                child: const Text('다음으로'),
              ),
              const SizedBox(height: 8.0),
              TextButton(
                onPressed: () {
                  // 로그인 페이지로 이동하는 코드 추가
                },
                child: const Text('이미 계정이 있으신가요? 로그인'),
              ),
              const SizedBox(height: 16.0),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('뒤로가기'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}