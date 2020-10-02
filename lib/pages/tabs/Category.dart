import 'package:flutter/material.dart';
import '../../services/ScreenAdaper.dart';
import '../../config/Config.dart';
import 'package:dio/dio.dart';
import '../../model/CateModel.dart';

class CategoryPage extends StatefulWidget {
  CategoryPage({Key key}) : super(key: key);

  @override
  _CategoryPageState createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage>  with AutomaticKeepAliveClientMixin{

  int _selectIndex=0;
  List _leftCateList=[];
  List _rightCateList=[];

  @override
  void initState(){
    super.initState();
    _getLeftCateData();
  }

  
  //左侧分类
  _getLeftCateData() async{
       var api = '${Config.domain}api/pcate';
      var result = await Dio().get(api);
      var leftCateList = new CateModel.fromJson(result.data);
      // print(leftCateList.result);
      setState(() {
        this._leftCateList = leftCateList.result;
      });
      _getRightCateData(leftCateList.result[0].sId);
  }
 //右侧分类
 _getRightCateData(pid) async{
      var api = '${Config.domain}api/pcate?pid=${pid}';
      var result = await Dio().get(api);
      var rightCateList = new CateModel.fromJson(result.data);
      // print(rightCateList.result);
      setState(() {
        this._rightCateList = rightCateList.result;
      });
  }
  //获取左边的数据
  Widget _leftCateWidget(leftWidth){
    if(this._leftCateList.length>0){        
        return Container(
          width: leftWidth,
          height: double.infinity,
          child: ListView.builder(
            itemCount: this._leftCateList.length,
            itemBuilder: (context,index){
              return Column(
                children: <Widget>[
                  InkWell(
                    onTap: (){
                      setState(() {
                        _selectIndex=index;
                        this._getRightCateData(this._leftCateList[index].sId);
                      });
                    },
                    child: Container(
                      width: double.infinity,
                      height: ScreenAdaper.height(56),
                      child: Text("${this._leftCateList[index].title}",textAlign: TextAlign.center),
                      color: _selectIndex==index?Colors.red:Colors.white,
                    ),
                  ),
                  Divider()
                ],
              );
            },
          ),
        );
    }else{
         return Container(         
            width: leftWidth,
            height: double.infinity
         );
    }
  }
  //获取右边的数据
  Widget _rightCateWidget(rightItemWidth,rightItemHeight){
    if(this._rightCateList.length>0){
      return Expanded(
          flex: 1,
          child: Container(
            padding: EdgeInsets.all(10),
            height: double.infinity,
            color: Color.fromRGBO(240, 246, 246, 0.9),
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: rightItemWidth/rightItemHeight,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10
              ), 
              itemCount: this._rightCateList.length,
              itemBuilder: (context,index){
                //处理图片
                String pic=this._rightCateList[index].pic;
                pic=Config.domain+pic.replaceAll('\\', '/');
                return Container(
                  child: Column(
                    children: <Widget>[
                      AspectRatio(
                        aspectRatio: 1/1,
                        child: Image.network("${pic}",fit: BoxFit.cover),
                      ),
                      Container(
                        height: ScreenAdaper.height(38),
                        child: Text("${this._rightCateList[index].title}"),
                      )
                    ],
                  ),
                );
              }
            ),
          )
        );
    }else{
      return Expanded(
            flex: 1,
            child: Container(
                padding: EdgeInsets.all(10),
                height: double.infinity,
                color: Color.fromRGBO(240, 246, 246, 0.9),
                child: Text("加载中..."),
            )
        );
    }
  }

  @override
  Widget build(BuildContext context) {

    ScreenAdaper.init(context);
    // 左侧的宽度
    var leftwidth=ScreenAdaper.getScreenWidth()/4;
    //右侧每一项的宽度
    var rightItemWidth=ScreenAdaper.width((ScreenAdaper.getScreenWidth()-leftwidth-20-20)/3);
    var rightItemHeight=rightItemWidth+ScreenAdaper.height(28);
    
    return Row(
      children: <Widget>[
        _leftCateWidget(leftwidth),
        _rightCateWidget(rightItemWidth,rightItemHeight)
      ],
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
