import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
//import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../services/ScreenAdaper.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // 轮播图
  //轮播图
  Widget _swiperWidget() {
    List<Map> imgList = [
      {"url": "https://www.itying.com/images/flutter/slide01.jpg"},
      {"url": "https://www.itying.com/images/flutter/slide02.jpg"},
      {"url": "https://www.itying.com/images/flutter/slide03.jpg"},
    ];

    return Container(
      child: AspectRatio(
        aspectRatio: 2 / 1,
        child: Swiper(
            itemBuilder: (BuildContext context, int index) {
              return new Image.network(
                imgList[index]["url"],
                fit: BoxFit.fill,
              );
            },
            itemCount: imgList.length,
            pagination: new SwiperPagination(),
            autoplay: true),
      ),
    );
  }

  Widget _titleWidget(value) {
    return Container(
      height: ScreenAdaper.height(32),
      margin: EdgeInsets.only(left: ScreenAdaper.width(20)),
      padding: EdgeInsets.only(left: ScreenAdaper.width(20)),
      decoration: BoxDecoration(
          border: Border(
              left: BorderSide(
        color: Colors.red,
        width: ScreenAdaper.width(10),
      ))),
      child: Text(
        value,
        style: TextStyle(color: Colors.black54),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // ScreenUtil.instance = ScreenUtil(width: 750, height: 1334)..init(context);
    ScreenAdaper.init(context);
    return ListView(
      children: <Widget>[
        _swiperWidget(),
        SizedBox(height: ScreenAdaper.width(10)),
        _titleWidget("猜你喜欢"),
        _hotProductListWidget(),
        SizedBox(height: ScreenAdaper.width(10)),
        _titleWidget("热门推荐"),
      ],
    );
  }

  Widget _hotProductListWidget() {
    return Container(
        height: ScreenAdaper.height(234),
        padding: EdgeInsets.all(ScreenAdaper.width(20)),
        width: double.infinity,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            return Column(children: <Widget>[
              Container(
                  height: ScreenAdaper.height(140),
                  width: ScreenAdaper.width(140),
                  margin: EdgeInsets.only(right: ScreenAdaper.width(20)),
                  child: Image.network(
                      "https://www.itying.com/images/flutter/hot${index+1}.jpg",
                      fit: BoxFit.cover)
              ),
              Container(
                padding: EdgeInsets.only(top:ScreenAdaper.height(10)),
                height: ScreenAdaper.height(44),
                child: Text("第${index+1}条"),
              )              
            ]);
          },
          itemCount: 10,
        ));
  }
}
