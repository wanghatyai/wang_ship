import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';

import 'package:wang_ship/check_order.dart';
import 'package:wang_ship/report.dart';

import 'package:wang_ship/report_all.dart';
import 'package:wang_ship/report_border_all.dart';

import 'package:shared_preferences/shared_preferences.dart';



class Home extends StatefulWidget {

  //var usernameVal;
  //Home({Key key, this.usernameVal}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  String usernameVal;
  var username;

  var orderSum;
  var orderSumFinish;

  var orderBorderSum;
  var orderBorderSumFinish;
  
  final formatDateTime = DateFormat('dd/MM/yyyy');

  int currentIndex = 0;
  List pages = [CheckOrderPage(), ReportPage(), ReportAllPage(), ReportBorderAllPage()];

  getCodeEmpShip() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      username = prefs.getString("empCodeShipping");
    });
    return username;
  }

  getOrderSum() async{

    final res = await http.get('https://wangpharma.com/API/shippingProduct.php?act=GetShipAllSum');

    if(res.statusCode == 200){

      setState(() {

        var jsonData = json.decode(res.body);

        jsonData.forEach((orderSumDB) {
          orderSum = orderSumDB['orderSum'];
        });

        print(orderSum);
        return orderSum;

      });

    }else{
      throw Exception('Failed load Json');
    }
  }

  getOrderSumFinish() async{

    final res = await http.get('https://wangpharma.com/API/shippingProduct.php?act=GetShipAllSumFinish');

    if(res.statusCode == 200){

      setState(() {

        var jsonData = json.decode(res.body);

        jsonData.forEach((orderSumDB) {
          orderSumFinish = orderSumDB['orderSumFinish'];
        });

        print(orderSumFinish);
        return orderSumFinish;

      });

    }else{
      throw Exception('Failed load Json');
    }
  }

  getOrderBorderSum() async{

    final res = await http.get('https://wangpharma.com/API/shippingProduct.php?act=GetShipBorderAllSum');

    if(res.statusCode == 200){

      setState(() {

        var jsonData = json.decode(res.body);

        jsonData.forEach((orderSumDB) {
          orderBorderSum = orderSumDB['orderBorderSum'];
        });

        print(orderBorderSum);
        return orderBorderSum;

      });

    }else{
      throw Exception('Failed load Json');
    }
  }

  getOrderBorderSumFinish() async{

    final res = await http.get('https://wangpharma.com/API/shippingProduct.php?act=GetShipBorderAllSumFinish');

    if(res.statusCode == 200){

      setState(() {

        var jsonData = json.decode(res.body);

        jsonData.forEach((orderSumDB) {
          orderBorderSumFinish = orderSumDB['orderBorderSumFinish'];
        });

        print(orderBorderSumFinish);
        return orderBorderSumFinish;

      });

    }else{
      throw Exception('Failed load Json');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCodeEmpShip();

    getOrderSum();
    getOrderSumFinish();

    getOrderBorderSum();
    getOrderBorderSumFinish();
  }


  @override
  Widget build(BuildContext context) {

    Widget bottomNavBar = BottomNavigationBar(
        backgroundColor: Colors.white,
        fixedColor: Colors.deepOrange,
        unselectedItemColor: Colors.blueGrey,
        type: BottomNavigationBarType.fixed,
        currentIndex: currentIndex,
        onTap: (int index){
          setState(() {
            currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.add_to_photos),
              title: Text('ส่งสินค้า', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold))
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.account_box),
              title: Text('ส่วนตัว', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold))
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.view_list),
              title: Text('หาดใหญ่', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold))
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.map),
              title: Text('ต่างจังหวัด', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold))
          ),
        ]
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepOrange,
        title: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text("รหัสพนักงาน ${username}"),
                Text("HY ส่งแล้ว $orderSumFinish/$orderSum บิล", style: TextStyle(fontSize: 17),),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text("${formatDateTime.format(DateTime.now())}"),
                Text("ต่างจังหวัด ส่งแล้ว $orderBorderSumFinish/$orderBorderSum บิล", style: TextStyle(fontSize: 17)),
              ],
            ),

          ],
        ),
        actions: <Widget>[

        ],
      ),
      body: pages[currentIndex],
      bottomNavigationBar: bottomNavBar,
    );
  }
}
