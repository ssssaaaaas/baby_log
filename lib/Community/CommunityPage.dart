import 'package:flutter/material.dart';
import 'CommunityTab.dart';
import 'PostForm.dart';

class CommunityPage extends StatefulWidget {
  @override
  _CommunityPageState createState() => _CommunityPageState();
}

class _CommunityPageState extends State<CommunityPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showRulesBottomSheet(context);
    });
  }

  void _showRulesBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isDismissible: false,
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '👶 베이비 로그는 아이를 위한 정보, 고민 나눔을\n할 수 있는 공간이에요.'
                '\n기본적으로 서로 존댓말을 사용해요.',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
              ),
              SizedBox(height: 22),
              Text(
                '🤰타인을 존중하고 배려해요. 만약 누군가 작성한\n글이 규칙 위반이라고 생각한다면, '
                '댓글을 통해\n싸우는 것이 아닌 신고를 해주세요. ',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
              ),
              SizedBox(height: 22),
              Text(
                '🍼 베이비 로그에서 글을 작성하실 때 카테고리를\n설정할 수 있어요.\n'
                '자유롭게 글을 적는 자유로그, 궁금한 점을 질문하는\n'
                '질문로그, 서로의 꿀팁을 공유하는 꿀팁로그\n아이 사진을 올리는 자랑로그가 있어요.',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
              ),
              SizedBox(height: 44),
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  backgroundColor: Color(0xffFF9C27),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Row(
                  children: [
                    Icon(Icons.check, color: Colors.white),
                    Text(
                      '확인했어요!', 
                      style: TextStyle(
                        fontSize: 18, 
                        fontWeight: FontWeight.w600, 
                        color: Colors.white
                      )
                    ),
                  ],
                ),
              ),
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
          title: Text('커뮤니티'),
          bottom: TabBar(
            tabs: [
              Tab(text: '자유로그'),
              Tab(text: '질문로그'),
              Tab(text: '꿀팁로그'),
              Tab(text: '자랑로그'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            CommunityTab(tabType: '자유로그'),
            CommunityTab(tabType: '질문로그'),
            CommunityTab(tabType: '꿀팁로그'),
            CommunityTab(tabType: '자랑로그'),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            showModalBottomSheet(
              context: context,
              builder: (BuildContext context) {
                return Container(
                  height: 200,
                  child: Column(
                    children: <Widget>[
                      ListTile(
                        title: Text('자유로그'),
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PostForm(initialType: '자유로그'),
                            ),
                          );
                        },
                      ),
                      ListTile(
                        title: Text('질문로그'),
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PostForm(initialType: '질문로그'),
                            ),
                          );
                        },
                      ),
                      ListTile(
                        title: Text('꿀팁로그'),
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PostForm(initialType: '꿀팁로그'),
                            ),
                          );
                        },
                      ),
                      ListTile(
                        title: Text('자랑로그'),
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PostForm(initialType: '자랑로그'),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}