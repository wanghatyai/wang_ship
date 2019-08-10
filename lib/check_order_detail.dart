import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;

import 'package:wang_ship/image_detail.dart';

class CheckOrderDetailPage extends StatefulWidget {

  var billOrderShipVal;
  CheckOrderDetailPage({Key key, this.billOrderShipVal}) : super(key: key);

  @override
  _CheckOrderDetailPageState createState() => _CheckOrderDetailPageState();
}

class _CheckOrderDetailPageState extends State<CheckOrderDetailPage> {

  File imageFile1;
  File imageFile2;
  File imageFile3;

  int typeCustomerGet;

  _openCamera(camPosition) async {
    var picture = await ImagePicker.pickImage(source: ImageSource.camera);
    this.setState((){
      if(camPosition == 1){
        imageFile1 = picture;
      }else if(camPosition == 2){
        imageFile2 = picture;
      }else{
        imageFile3 = picture;
      }
    });
    //Navigator.of(context).pop();
  }

  _decideImageView(camPosition){

    File imageFileC;

    if(camPosition == 1){
      imageFileC = imageFile1;
    }else if(camPosition == 2){
      imageFileC = imageFile2;
    }else{
      imageFileC = imageFile3;
    }

    if(imageFileC == null){
      return Image (
        image: AssetImage ( "assets/photo_default_2.png" ), width: 100, height: 100,
      );
    }else{
      return GestureDetector(
        onTap: () {
          print("open img.");
          Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ImageDetailPage(imageFile: imageFileC)));
        },
        child: Image.file(imageFileC, width: 100, height: 100),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepOrange,
        title: Text("รายละเอียดรายการ"),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Text('ร้าน: ${widget.billOrderShipVal.shipBillCusName}'),
            Text('รหัสรายการCom'),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text('${widget.billOrderShipVal.shipBillCodeCom1}'),
                Text('${widget.billOrderShipVal.shipBillCodeCom2}'),
                Text('${widget.billOrderShipVal.shipBillCodeCom3}'),
              ],
            ),
            Text('รหัสรายการPart'),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text('${widget.billOrderShipVal.shipBillCode1}'),
                Text('${widget.billOrderShipVal.shipBillCode2}'),
                Text('${widget.billOrderShipVal.shipBillCode3}'),
              ],
            ),
            Text('พิมพ์สติ๊กเกอร์ : ${widget.billOrderShipVal.shipBillDateCreate}'),
            Row(
              children: <Widget>[
                Expanded(
                  flex: 2,
                  child: Column(
                    children: <Widget>[
                      Text("รูปสินค้า", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      _decideImageView(1),
                      IconButton(
                          padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                          icon: Icon(Icons.camera_alt, size: 50,),
                          onPressed: (){
                            _openCamera(1);
                            //Navigator.push(context, MaterialPageRoute(builder: (context) => OrderPage()));
                          }
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Column(
                    children: <Widget>[
                      Text("รูปร้าน", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      _decideImageView(2),
                      IconButton(
                          padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                          icon: Icon(Icons.camera_alt, size: 50,),
                          onPressed: (){
                            _openCamera(2);
                            //Navigator.push(context, MaterialPageRoute(builder: (context) => OrderPage()));
                          }
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Column(
                    children: <Widget>[
                      Text("รูปผู้รับสินค้า", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      _decideImageView(3),
                      IconButton(
                          padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                          icon: Icon(Icons.camera_alt, size: 50,),
                          onPressed: (){
                            _openCamera(3);
                            //Navigator.push(context, MaterialPageRoute(builder: (context) => OrderPage()));
                          }
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Text('ผู้รับสินค้า'),
            Row(
              children: <Widget>[
                Text('เจ้าของร้าน'),
                Radio(
                  onChanged:(e){},
                  activeColor: Colors.deepOrange,
                  value: 1,
                  groupValue: typeCustomerGet,
                ),
                Text('เภสัชกร'),
                Radio(
                  onChanged:(e){},
                  activeColor: Colors.deepOrange,
                  value: 2,
                  groupValue: typeCustomerGet,
                )
              ],
            ),
            Row(
              children: <Widget>[
                Text('ผู้จัดการ'),
                Radio(
                  onChanged:(e){},
                  activeColor: Colors.deepOrange,
                  value: 3,
                  groupValue: typeCustomerGet,
                ),
                Text('ฝากข้างร้าน'),
                Radio(
                  onChanged:(e){},
                  activeColor: Colors.deepOrange,
                  value: 4,
                  groupValue: typeCustomerGet,
                ),
              ],
            ),
            RaisedButton (
              color: Colors.green,
              onPressed: (){

              },
              child: Text (
                'ลายเช็น',
                style: TextStyle (
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

