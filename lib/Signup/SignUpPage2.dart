import 'Pregnant.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SignUpPage2 extends StatefulWidget {
  const SignUpPage2({Key? key}) : super(key: key);

  @override
  _SignUpPage2State createState() => _SignUpPage2State();
}

class _SignUpPage2State extends State<SignUpPage2> {
  final TextEditingController _nickNameController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String _selectedIcon = '';

  Future<void> _saveAdditionalInfo() async {
    if (_nickNameController.text.trim().isEmpty ||
        _genderController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('닉네임과 성별을 모두 입력해주세요.'),
          duration: Duration(milliseconds: 500),
        ),
      );
      return;
    }

    try {
      User? user = _auth.currentUser;
      if (user != null) {
        await _firestore.collection('users').doc(user.uid).update({
          'nickName': _nickNameController.text.trim(),
          'gender': _genderController.text.trim(),
          'status': _selectedIcon,
          'nickname': _selectedIcon == '임신 중이에요' ? null : 'default',
          'dueDate': _selectedIcon == '임신 중이에요' ? null : 'default',
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('추가 정보가 저장되었습니다.'),
            duration: Duration(milliseconds: 500),
          ),
        );

        if (_selectedIcon == '임신 중이에요') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => PregnantPage()),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('사용자 정보가 없습니다. 다시 시도해주세요.'),
            duration: Duration(milliseconds: 500),
          ),
        );
      }
    } catch (e) {
      print("추가 정보 저장 실패: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('추가 정보 저장 실패: ${e.toString()}'),
          duration: Duration(milliseconds: 500),
        ),
      );
    }
  }

  Widget _buildIcon(String label, IconData iconData) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedIcon = label;
        });
      },
      child: Container(
        decoration: BoxDecoration(
          color: _selectedIcon == label ? Colors.orange.shade100 : Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: _selectedIcon == label ? Colors.orange : Colors.grey,
            width: 2,
          ),
        ),
        padding: EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(iconData,
                color: _selectedIcon == label ? Colors.orange : Colors.grey),
            SizedBox(width: 8),
            Text(label),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('추가 정보 입력'),
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
                controller: _nickNameController,
                decoration: InputDecoration(
                  labelText: '닉네임',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16.0),
              TextField(
                controller: _genderController,
                decoration: InputDecoration(
                  labelText: '성별',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 32.0),
              Text('아이콘 설정',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16.0),
              _buildIcon('둘러볼게요', Icons.explore),
              const SizedBox(height: 16.0),
              _buildIcon('임신 중이에요', Icons.pregnant_woman),
              const SizedBox(height: 16.0),
              _buildIcon('아기를 키우고 있어요', Icons.child_care),
              const SizedBox(height: 32.0),
              ElevatedButton(
                onPressed: _saveAdditionalInfo,
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
