import 'package:flutter/material.dart';
import 'Cart.dart';
import 'Category.dart';
import 'Home.dart';
import 'User.dart';

class Tabs extends StatefulWidget {
  // ignore: missing_required_param
  Tabs({Key key}) : super(key: key);
  _TabsState createState() => _TabsState();
}

class _TabsState extends State<Tabs> {
  int _currentIndex = 0;
  // 跳转页面的列表
  List _pageList = [HomePage(), CategoryPage(), CartPage(), UserPage()];
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("京东商城"),
      ),
      body: this._pageList[this._currentIndex],
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: this._currentIndex,
          onTap: (index) {
            setState(() {
              this._currentIndex = index;
            });
          },
          type: BottomNavigationBarType.fixed,
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.home), title: Text("首页")),
            BottomNavigationBarItem(
                icon: Icon(Icons.category), title: Text("分类")),
            BottomNavigationBarItem(
                icon: Icon(Icons.shopping_cart), title: Text("购物车")),
            BottomNavigationBarItem(
                icon: Icon(Icons.person), title: Text("我的")),
          ]),
    );
  }
}
