import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter/cupertino.dart';

class PregnantPage extends StatefulWidget {
  const PregnantPage({Key? key}) : super(key: key);

  @override
  _PregnantPageState createState() => _PregnantPageState();
}

class _PregnantPageState extends State<PregnantPage> {
  final TextEditingController _nicknameController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    initializeDateFormatting('ko_KR', null).then((_) {
      setState(() {});
    });
  }

  Future<void> _savePregnancyInfo() async {
    if (_nicknameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('태명을 입력해주세요.'),
          duration: const Duration(milliseconds: 500),
        ),
      );
      return;
    }

    try {
      User? user = _auth.currentUser;
      if (user != null) {
        await _firestore.collection('users').doc(user.uid).update({
          'nickname': _nicknameController.text.trim(),
          'dueDate': _selectedDate.toString(),
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('정보가 저장되었습니다.'),
            duration: const Duration(milliseconds: 500),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('사용자 정보가 없습니다. 다시 시도해주세요.'),
            duration: const Duration(milliseconds: 500),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('정보 저장 실패: ${e.toString()}'),
          duration: const Duration(milliseconds: 500),
        ),
      );
    }
  }

  void _showDatePicker() {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 216,
          padding: const EdgeInsets.only(top: 6.0),
          margin: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          color: CupertinoColors.systemBackground.resolveFrom(context),
          child: SafeArea(
            top: false,
            child: CupertinoDatePicker(
              mode: CupertinoDatePickerMode.date,
              initialDateTime: _selectedDate,
              minimumYear: 1900,
              maximumYear: 2101,
              onDateTimeChanged: (DateTime newDateTime) {
                setState(() {
                  _selectedDate = newDateTime;
                });
              },
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('임신 정보 입력'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: _nicknameController,
                decoration: const InputDecoration(
                  labelText: '태명',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16.0),
              GestureDetector(
                onTap: _showDatePicker,
                child: AbsorbPointer(
                  child: TextField(
                    controller: TextEditingController(
                      text: DateFormat('yyyy년 MM월 dd일', 'ko_KR')
                          .format(_selectedDate),
                    ),
                    decoration: const InputDecoration(
                      labelText: '출산 예정일',
                      border: OutlineInputBorder(),
                      suffixIcon: Icon(Icons.calendar_today),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 32.0),
              ElevatedButton(
                onPressed: _savePregnancyInfo,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  textStyle: const TextStyle(fontSize: 18),
                ),
                child: const Text('저장하기'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
