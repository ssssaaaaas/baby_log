import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'CommunityTab.dart';
import 'PostForm.dart';

class CommunityPage extends StatefulWidget {
  @override
  _CommunityPageState createState() => _CommunityPageState();
}

class _CommunityPageState extends State<CommunityPage> {
  bool _showBottomSheet = true;
  
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_showBottomSheet) {
        _showRulesBottomSheet(context);
      }
    });
  }

  void _showRulesBottomSheet(BuildContext context) {
    showModalBottomSheet(
      backgroundColor: Colors.white,
      context: context,
      isDismissible: false,
      builder: (BuildContext context) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //Image.asset('assets/Mask group.png'),
              SizedBox(height: 10),
              Text(
                '👶 베이비 로그는 아이를 위한 정보와 고민을\n'
                '  수 있는 공간이에요. 서로 존댓말을 사용해요.\n',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
              ),
              Text(
                '🤰타인을 존중하고 배려해요. 만약 누군가 작성한\n'
                ' 글이 규칙 위반이라고 생각한다면, 신고를 해주세요.\n',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
              ),
              Text(
                '🍼 베이비 로그에서 글을 작성하실 때 카테고리를\n 설정할 수 있어요.\n'
                ' -자유롭게 글을 적는 자유로그\n'
                ' -궁금한 점을 질문하는 질문로그\n'
                ' -서로의 꿀팁을 공유하는 꿀팁로그\n'
                ' -아이 사진을 올리는 자랑로그가 있어요.\n\n',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 120),
                child: SizedBox(
                  width: 200,
                  height: 47,
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      backgroundColor: Color(0xffFF9C27),
                      side: BorderSide.none,
                    ),
                    onPressed: () {Navigator.pop(context);},
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.check, color: Colors.white, size: 24),
                        SizedBox(width: 8),
                        Text(
                          '확인했어요',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(width: 23),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Align(
            alignment: Alignment.topRight,
            child: IconButton(
              icon: Icon(Icons.search),
              onPressed: () {},
            )
          ),
          bottom: TabBar(
            labelColor: Color(0XFFFFAB47),
            unselectedLabelColor: Colors.black,
            indicatorColor: Color(0XFFFFAB47),
            tabs: [
              Tab(text: '자유로그'),
              Tab(text: '질문로그'),
              Tab(text: '꿀팁로그'),
              Tab(text: '자랑로그'),
            ],
          ),
        ),
        backgroundColor: Colors.white,
        body: TabBarView(
          children: [
            CommunityTab(tabType: '자유로그'),
            CommunityTab(tabType: '질문로그'),
            CommunityTab(tabType: '꿀팁로그'),
            CommunityTab(tabType: '자랑로그'),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Color(0XFFFFBC6B),
          elevation: 4,
          child: Icon(Symbols.edit, color: Colors.black),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(23)),
          onPressed: () async {
            final result = await Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => PostForm()),
            );
            if (result == 'fromPostForm') {
              setState(() {
                _showBottomSheet = false;
              });
            }
          },
        ),
      ),
    );
  }
}