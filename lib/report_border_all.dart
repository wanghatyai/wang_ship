import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:wang_ship/bill_model.dart';
import 'package:wang_ship/route_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:wang_ship/report_detail.dart';
import 'package:wang_ship/route_model.dart' as prefix0;

class ReportBorderAllPage extends StatefulWidget {
  @override
  _ReportBorderAllPageState createState() => _ReportBorderAllPageState();
}

class _ReportBorderAllPageState extends State<ReportBorderAllPage> {

  ScrollController _scrollController = new ScrollController();
  //Product product;
  List <Bill>orderBillBorderAll = [];
  bool isLoading = true;
  int perPage = 30;
  String act = "GetShipBorderAll";
  String username;

  List <RouteShip> routeShipAll = [];
  String _currentRoute;

  List shipType = ['_','บริการส่ง','ฝากรถ','รับเองที่คลัง','รับเองที่หจก','พร้อมรถ'];

  getShipBill() async{

    SharedPreferences prefs = await SharedPreferences.getInstance();
    username = prefs.getString("empCodeShipping");

    final res = await http.get('https://wangpharma.com/API/shippingProduct.php?PerPage=$perPage&act=$act');

    if(res.statusCode == 200){

      setState(() {
        isLoading = false;

        var jsonData = json.decode(res.body);

        jsonData.forEach((orderBill) => orderBillBorderAll.add(Bill.fromJson(orderBill)));
        perPage = perPage + 30;

        print(orderBillBorderAll);
        print(perPage);

        return orderBillBorderAll;

      });


    }else{
      throw Exception('Failed load Json');
    }
  }

  getRouteShip() async{

    final res = await http.get('https://wangpharma.com/API/routeShipping.php?act=Route');

    if(res.statusCode == 200){

      setState(() {
        //isLoading = false;

        var jsonData = json.decode(res.body);

        jsonData.forEach((routeShip) => routeShipAll.add(RouteShip.fromJson(routeShip)));

        print(routeShipAll);
        return routeShipAll;

      });


    }else{
      throw Exception('Failed load Json');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getShipBill();

    _scrollController.addListener((){
      //print(_scrollController.position.pixels);
      if(_scrollController.position.pixels == _scrollController.position.maxScrollExtent){
        getShipBill();
      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading ? CircularProgressIndicator()
          :ListView.builder(
        controller: _scrollController,
        itemBuilder: (context, int index){
          return ListTile(
            contentPadding: EdgeInsets.fromLTRB(10, 1, 10, 1),
            onTap: (){
              Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ReportDetailPage(billOrderShipVal: orderBillBorderAll[index])));
            },
            leading: Text('${orderBillBorderAll[index].shipBillQty} ลัง', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
            title: Text('[${orderBillBorderAll[index].shipBillCusCode}] ${orderBillBorderAll[index].shipBillCusName}', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('พิมพ์สติ๊กเกอร์ : ${orderBillBorderAll[index].shipBillDateCreate}', style: TextStyle(color: Colors.pink),),
                Text('ที่อยู่ : ${orderBillBorderAll[index].shipBillCusAddress}', style: TextStyle(color: Colors.teal), overflow: TextOverflow.ellipsis),
                Text('รูปแบบการส่ง : ${shipType[int.parse(orderBillBorderAll[index].shipBillShipType)]}', style: TextStyle(color: Colors.purple)),
              ],
            ),
            trailing: IconButton(
                icon: Icon(Icons.local_shipping, size: 40, color: Colors.red,),
                onPressed: (){
                  //addToOrderFast(productAll[index]);
                }
            ),
          );
        },
        itemCount: orderBillBorderAll != null ? orderBillBorderAll.length : 0,
      ),

    );
  }
}
