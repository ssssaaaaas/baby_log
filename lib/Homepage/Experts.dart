import 'package:flutter/material.dart';

import 'Columns.dart';

class Experts extends StatelessWidget {
  const Experts({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(0, 120, 0, 30),
          child: Text(
            '전문가 칼럼',
            style: TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.w700,
              color: Color(0XFFFFAB47),
            ),
          ),
        ),
        Container(
          height: 466,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 3,
            itemBuilder: (context, index) {
              final images = [
                'assets/expert1.png',
                'assets/expert2.png',
                'assets/expert3.png',
              ];

              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Columns(index: index + 1),
                    ),
                  );
                },
                child: Container(
                  width: 357,
                  child: Card(
                    color: Colors.white,
                    elevation: 0,
                    child: Container(
                      child: Image.asset(images[index]),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
