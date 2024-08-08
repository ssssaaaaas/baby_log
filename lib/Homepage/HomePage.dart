import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'WeekInfo.dart';
import 'Experts.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor:  Color(0XFFF6F7F9),
          systemNavigationBarColor: Colors.white,
        ),
        backgroundColor: Colors.white,
        scrolledUnderElevation: 0,
      ),
      body: SingleChildScrollView(
        child: Center(
          child:Column(
            children: [
              const Text('DAY-50', 
                style: TextStyle(
                  fontSize: 40, 
                  fontWeight: FontWeight.w500, 
                  color: Colors.black,
                ),
              ),
              const Text('<12주차>', 
                style: TextStyle(
                  fontSize: 25, 
                  fontWeight: FontWeight.w500, 
                  color: Colors.black,
                ),
              ),
              Image.asset('assets/Rectangle 145.png'), 
              ScrollCards(), 
              Experts(),   
            ],
          ),
        ),
      ),
    );
  }
}

//주차별 안내사항 카드
class ScrollCards extends StatelessWidget {
  const ScrollCards({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(0, 116, 0, 30),
          child: Text(
            '주차별 안내사항',
            style: TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.w700,
              color: Color(0XFFFFAB47),
            ),
          ),
        ),
        Container(
          height: 380,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 10,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => WeekInfo(index: index + 1),
                    ),
                  );
                },
                child: Container(
                  width: 300,
                  child: Card(
                    color: Colors.white,
                    elevation: 0,
                    child: Stack(
                      children: [
                        Image.asset('assets/Mask group.png'),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(13, 0, 0, 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                '임신 ${index + 1}주차',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 40,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const Text(
                                '신체 변화가 시작되는 중요한 시기에요.\n'
                                '피부가 변화하고 현기증이 생길 수 있어요..',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
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
