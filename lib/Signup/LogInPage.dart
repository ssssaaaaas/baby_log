import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'SignUpPage.dart';
import '../navigationBar.dart';
class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);
  @override
  _LoginPageState createState() => _LoginPageState();
}
class _LoginPageState extends State<LoginPage> {
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Future<String?> _getEmailById(String id) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('users')
          .where('ID', isEqualTo: id)
          .limit(1)
          .get();
      if (snapshot.docs.isNotEmpty) {
        return snapshot.docs.first['email'] as String?;
      }
    } catch (e) {
      print("이메일 조회 실패: $e");
    }
    return null;
  }
  Future<void> _login() async {
    try {
      String? email = await _getEmailById(_idController.text.trim());
      if (email != null) {
        UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email,
          password: _passwordController.text.trim(),
        );
        // 로그인 성공 후 NavigationBar로 이동
        print("로그인 성공: ${userCredential.user?.email}");
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const navigationBar()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('아이디를 찾을 수 없습니다.'),
            duration: Duration(milliseconds: 500),
          ),
        );
      }
    } on FirebaseAuthException catch (e) {
      // FirebaseAuthException 처리
      debugPrint("로그인 실패: ${e.message}");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('로그인 실패: ${e.message}')),
      );
    } catch (e) {
      // 일반 예외 처리
      debugPrint("로그인 실패: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('로그인 실패: ${e.toString()}')),
      );
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.center,
              end: Alignment.bottomCenter,
              colors: [Colors.white, Colors.orange[50]!],
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 90.0),
                Image.asset('assets/logo_word.png', width: 183, height: 75),
                const SizedBox(height: 99.0),
                const Padding(
                  padding: EdgeInsets.only(left: 43.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      '아이디',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontFamily: 'Pretendard Variable',
                        fontWeight: FontWeight.w600,
                        height: 0,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8.0),
                Padding(
                  padding: const EdgeInsets.fromLTRB(43.0, 0, 43, 0),
                  child: Container(
                    width: 350,
                    height: 31,
                    decoration: const BoxDecoration(color: Colors.white),
                    child: Center(
                      child: TextField(
                        controller: _idController,
                        cursorColor: const Color(0XFFFFDCB2),
                        decoration: const InputDecoration(
                          hintText: '아이디',
                          hintStyle: TextStyle(
                            color: Color(0xFFA7A7A7),
                            fontSize: 13,
                            fontFamily: 'Pretendard Variable',
                            fontWeight: FontWeight.w500,
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Color(0xFFA8A8A8)),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Color(0xFFA7A7A7)),
                          ),
                          contentPadding: EdgeInsets.symmetric(vertical: 15),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16.0),
                const Padding(
                  padding: EdgeInsets.only(left: 43.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      '비밀번호',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontFamily: 'Pretendard Variable',
                        fontWeight: FontWeight.w600,
                        height: 0,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8.0),
                Padding(
                  padding: const EdgeInsets.fromLTRB(43.0, 0, 43, 0),
                  child: Container(
                    width: 350,
                    height: 31,
                    decoration: const BoxDecoration(color: Colors.white),
                    child: Center(
                      child: TextField(
                        controller: _passwordController,
                        cursorColor: const Color(0XFFFFDCB2),
                        decoration: const InputDecoration(
                          hintText: '영문, 숫자, 특수문자 포함 8자리 이상',
                          hintStyle: TextStyle(
                            color: Color(0xFFA7A7A7),
                            fontSize: 13,
                            fontFamily: 'Pretendard Variable',
                            fontWeight: FontWeight.w500,
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Color(0xFFA8A8A8)),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Color(0xFFA7A7A7)),
                          ),
                          contentPadding: EdgeInsets.symmetric(vertical: 15),
                        ),
                        obscureText: true,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16.0),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                      onPressed: () {
                        // 아이디/비밀번호 찾기 화면으로 이동
                      },
                      child: const Text(
                        '아이디 / 비밀번호 찾기',
                        style: TextStyle(
                          color: Color(0xFF2D2D2D),
                          fontSize: 13,
                          fontFamily: 'Pretendard Variable',
                          fontWeight: FontWeight.w500,
                          height: 0,
                        ),
                      )),
                ),
                const SizedBox(height: 252.0),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 50, 0, 20),
                  child: SizedBox(
                    width: 375,
                    height: 64,
                    child: ElevatedButton(
                      onPressed: _login,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFFBC6B),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 50.0,
                          vertical: 15.0,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4.0),
                        ),
                        shadowColor: const Color(0x3FFFAB47),
                        elevation: 8.0,
                      ),
                      child: const Text(
                        '시작하기',
                        style: TextStyle(
                          fontSize: 20.0,
                          fontFamily: 'Pretendard Variable',
                          fontWeight: FontWeight.w700,
                          color: Color(0xFFFFDFBB),
                        ),
                      ),
                    ),
                  ),
                ),
                //const SizedBox(height: 8.0),
                TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SignUpPage(),
                        ),
                      );
                    },
                    child: const Text(
                      '회원가입',
                      style: TextStyle(
                        color: Color(0xFF2D2D2D),
                        fontSize: 13,
                        fontFamily: 'Pretendard Variable',
                        fontWeight: FontWeight.w500,
                        decoration: TextDecoration.underline,
                        height: 0,
                      ),
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}