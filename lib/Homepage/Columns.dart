import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

class Columns extends StatelessWidget {
  final int index;

  const Columns({super.key, required this.index});

  Widget _getContentWidget(int index) {
    switch (index) {
      case 1:
        return Experts1Content();
      case 2:
        return Experts2Content();
      case 3:
        return Experts3Content();
      default:
        return const Center(
          child: Text(
            '상세 정보를 확인해 주세요.',
            style: TextStyle(fontSize: 24),
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.favorite_border)),
          IconButton(onPressed: () {}, icon: const Icon(Symbols.upload)),
        ],
      ),
      body: _getContentWidget(index),
    );
  }
}

class Experts1Content extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(left: 25),
            child: Text(
              '임신 중 운동해도 될까요?', 
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w700,
                color: Color(0XFFFFAB47),
              )
            ),
          ),
        ],
      ),
    );
  }
}

class Experts2Content extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(left: 25),
            child: Text(
              '조기 진통이 있다면?', 
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w700,
                color: Color(0XFFFFAB47),
              )
            ),
          ),
        ],
      ),
    );
  }
}

class Experts3Content extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(left: 25),
            child: Text(
              '임신 우울증이 있다면?', 
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w700,
                color: Color(0XFFFFAB47),
              )
            ),
          ),
        ],
      ),
    );
  }
}
