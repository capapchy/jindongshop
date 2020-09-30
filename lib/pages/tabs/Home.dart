import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:dio/dio.dart';
import '../../services/ScreenAdaper.dart';
import '../../model/FocusModel.dart';
import '../../model/ProductModel.dart';
import '../../config/Config.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // 轮播图
  List<FocusItemModel> _focusData=[];
  //才您喜欢
  List<ProductItemModel> _hotProductList = [];
  //推荐产品
  List _bestProductList = [];
  @override
  void initState(){
    super.initState();
    _getFocusData();
    _getHotProductData();
    _getBestProductData();
  }
  //获取轮播图
  _getFocusData() async{
    var api="${Config.domain}api/focus";
    var result=await Dio().get(api);
    var focusList=FocusModel.fromJson(result.data);

    setState(() {
      this._focusData=focusList.result;
    });
  }
  //获取猜你喜欢的数据
  _getHotProductData() async {
    var api = '${Config.domain}api/plist?is_hot=1';
    var result = await Dio().get(api);
    var hotProductList = ProductModel.fromJson(result.data);
    setState(() {
      this._hotProductList = hotProductList.result;
    });
  }
  //获取热门推荐的数据
  _getBestProductData() async {
    var api = '${Config.domain}api/plist?is_best=1';
    var result = await Dio().get(api);
    var bestProductList = ProductModel.fromJson(result.data);    
    setState(() {
      this._bestProductList = bestProductList.result;
    });
  }

  //轮播图
  Widget _swiperWidget() {
    if(this._focusData.length>0){
      return Container(
        child: AspectRatio(
          aspectRatio: 2 / 1,
          child: Swiper(
              itemBuilder: (BuildContext context, int index) {

                  String pic=this._focusData[index].pic;
                return new Image.network(
                    "${Config.domain}${pic.replaceAll('\\', '/')}",
                  fit: BoxFit.fill,
                );
              },
              itemCount: this._focusData.length,
              pagination: new SwiperPagination(),
              autoplay: true),
        ),
      );
    }
    else{
      return Text('加载中...');
    }
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
        _recProductItemWidget()
        
      ],
    );
  }

  Widget _hotProductListWidget() {
    if(this._hotProductList.length>0){
    return Container(
        height: ScreenAdaper.height(234),
        padding: EdgeInsets.all(ScreenAdaper.width(20)),
        width: double.infinity,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {           
            //处理图片
            String sPic = this._hotProductList[index].sPic;
            sPic = Config.domain + sPic.replaceAll('\\', '/');
            return Column(children: <Widget>[
              Container(
                  height: ScreenAdaper.height(140),
                  width: ScreenAdaper.width(140),
                  margin: EdgeInsets.only(right: ScreenAdaper.width(20)),
                  child: Image.network(
                      sPic,
                      fit: BoxFit.cover)
              ),
              Container(
                padding: EdgeInsets.only(top:ScreenAdaper.height(10)),
                height: ScreenAdaper.height(44),
                child: Text(
                    "¥${this._hotProductList[index].price}",
                    style: TextStyle(color: Colors.red),
                  ),
              )              
            ]);
          },
          itemCount: this._hotProductList.length,
        ));
    }
    else{
      return Text("正在加载中......");
    }
  }

  Widget _recProductItemWidget(){
    var itemWidth=(ScreenAdaper.getScreenWidth()-30)/2;
    return Container(
          padding: EdgeInsets.all(10),
          child: Wrap(
            runSpacing: 10,
            spacing: 10,
            children:this._bestProductList.map((value) {              
              //图片
              String sPic=value.sPic;
              sPic=Config.domain+sPic.replaceAll('\\', '/');
               return Container(
                  // color: Colors.green,
                  padding: EdgeInsets.all(10),
                  width: itemWidth,
                  decoration: BoxDecoration(
                    border: Border.all(color: Color.fromRGBO(233, 233, 233, 0.9),width: 1)
                  ),
                  child: Column(
                    children: <Widget>[
                      Container(
                        width: double.infinity,
                        child: AspectRatio(
                          aspectRatio: 1/1,
                          child: Image.network("$sPic",fit:BoxFit.cover),
                          ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top:ScreenAdaper.height(20)),
                        child: Text(
                          "${value.title}",
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(color: Colors.black54),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: ScreenAdaper.height(20)),
                        child: Stack(
                          children: <Widget>[
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                 "¥${value.price}",
                                style: TextStyle(color:Colors.red,fontSize: 16),
                              ),
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: Text(
                                "¥${value.oldPrice}",
                                style: TextStyle(
                                  color: Colors.black54,
                                  fontSize: 14,
                                  decoration: TextDecoration.lineThrough
                                )
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                );
            }).toList()
          ),
        );
  }
}