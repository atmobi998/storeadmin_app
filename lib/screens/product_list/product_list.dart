// import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shopadmin_app/app_globals.dart';
import 'package:shopadmin_app/constants.dart';
import 'package:shopadmin_app/strconsts.dart';

class Product {

  final int id;
  final int storeid;
  final String storename;
  final int catid;
  final String catname;
  final String prodname;
  final String prodslug;
  final String proddesc;
  final int prodsort;
  final String prodico;
  final String prodimga;
  final String prodimgb;
  final String prodimgc;
  final double prodpricesell;
  final double prodpricebuy;
  final double prodtaxrate;
  final int prodactive;
  final int stockunits;

  Product({required this.id, required this.storeid, required this.storename, required this.catid, required this.catname, required this.prodname, 
      required this.prodslug, required this.proddesc, required this.prodsort, required this.prodico, required this.prodimga, required this.prodimgb, required this.prodimgc, 
      required this.prodactive, required this.prodpricesell, required this.prodpricebuy, required this.prodtaxrate, required this.stockunits});

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      storeid: json['store_id'],
      storename: json['store_name'],
      catid: json['cat_id'],
      catname: json['cat_name'],
      prodname: json['name'],
      prodslug: json['slug'],
      proddesc: json['description'],
      prodsort: json['sort'],
      prodico: json['prod_ico'],
      prodimga: json['prod_imga'],
      prodimgb: json['prod_imgb'],
      prodimgc: json['prod_imgc'],
      prodpricesell: json['pricesell'].toDouble(),
      prodpricebuy: json['pricebuy'].toDouble(),
      prodtaxrate: json['taxrate'].toDouble(),
      prodactive: json['active'],
      stockunits: json['stockunits'],
    );
  }
}

class ProductsListView extends StatefulWidget {
  const ProductsListView({Key? key}) : super(key: key);

  
  @override
  _ProductsListView createState() => _ProductsListView();

  }
  

  class _ProductsListView extends State<ProductsListView> {

  @override
  Widget build(BuildContext context) {
    gtextTranslate(context);
    return Container(
      width: defListFormWidth,
      height: prodListScrlHeight,
      color: Colors.white,
      padding: EdgeInsets.all(defTxtInpEdge),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: defListFormMaxWidth,
        ),
        child: FutureBuilder<List<Product>>(
          future: _fetchProducts(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<Product>? data = snapshot.data;
              return _productsListView(data);
            } else if (snapshot.hasError) {
              return Text("${snapshot.error}");
            }
            return doingapialert;
          },
        ),
      ),
    );
  }


    void refresh(int productid) {
        admcurprodid = productid;
        setState(() {});
        productqry();
    }

    void refreshonly() {
        setState(() {});
    }

    productqry() {
      var postdata = {
          "qrymode": 'by_id',
          "id": "$admcurprodid",
          "mobapp" : mobAppVal,
          "cat_id": "$admcurcatid",
          "store_id" : "$admcurstoreid", 
        };
      var posthdr = {
          'Accept': 'application/json',
          'Authorization' : 'Bearer $logintoken'
          };
      // showAlertDialog(context);
      http.post(
          productqryEndPoint, 
          body: postdata,
          headers: posthdr
        ).then((result) {
            // hideAlertDialog(context);
            if (result.statusCode == 200) {
              var resary = jsonDecode(result.body);
              setState(() {
                admcurprod = resary['data'];
                admcurprodid = resary['data']['id'];
                curprodactive = (resary['data']['active'] > 0)? true:false;
              });
            } else {
              throw Exception(kstoreqryErr);
            }
        }).catchError((error) {});
    }

    Future<List<Product>> _fetchProducts() async {
      var postdata = {
          "qrymode": 'allbycat',
          "mobapp" : mobAppVal,
          "cat_id": "$admcurcatid",
          "store_id" : "$admcurstoreid",
          // ignore: unnecessary_string_interpolations
          "filter" : "$admcurprodsearch",
        };
      var posthdr = {
          'Accept': 'application/json',
          'Authorization' : 'Bearer $logintoken'
          };
      final productListAPIUrl = productqryEndPoint;
      final response = await http.post(productListAPIUrl, body: postdata, headers: posthdr );
      if (response.statusCode == 200) {
        Map<String, dynamic> alljsonResponse = json.decode(response.body);
        List jsonResponse = alljsonResponse['data'];
        // ignore: unnecessary_new
        return jsonResponse.map((product) => new Product.fromJson(product)).toList();
      } else {
        throw Exception(kProdAPIErr);
      }
    }

    ListView _productsListView(data) {
      var tmpstrccy = (admcurstore.isNotEmpty)? admcurstore.first.currency : "";
      return ListView.builder(
            shrinkWrap: false,
            itemCount: data.length,
            itemBuilder: (context, index) {
              String tmpproddesc = data[index].proddesc;
              tmpproddesc = (tmpproddesc.length > 26)? tmpproddesc.substring(0,24)+'..' : tmpproddesc;
              final String activetext = (data[index].prodactive >= 1)? 'stocks: ' + data[index].stockunits.toString() + '\nActive' : 
                                                                      'stocks: ' + data[index].stockunits.toString() + '\nIn-active'  ;
              return _tile(data[index].id, data[index].prodname, tmpproddesc + '\n'+ tmpstrccy +': ' + data[index].prodpricesell.toString() , 
                activetext , Icons.card_giftcard, data[index].prodactive , data[index].prodico, data[index].prodimga, data[index].stockunits);
            },
          );
    }
   
    ListTile _tile(int productid, String title, String subtitle, String catslug, IconData icon, prodactive, prodico, prodimga, stockunits) => ListTile(
          title: Text(title, style: TextStyle(fontWeight: FontWeight.w500,fontSize: defUIsize14, color: (productid == admcurprodid)? kPrimaryColor : inActiveIconColor)),
          subtitle: Text(subtitle, style: TextStyle( fontWeight: FontWeight.w500, fontSize: defUIsize12, color: (productid == admcurprodid)? kPrimaryColor : inActiveIconColor)),
          leading: (null != prodico)? Image.network(imagehost+prodico, fit: BoxFit.cover, height: defUIsize30, width: defUIsize30):
                                      Icon(icon, color: admcurprodid == productid ? kPrimaryColor : inActiveIconColor, size: defUIsize30),
          trailing: Text(catslug,
              style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: defUIsize12,
                color: (stockunits >= 100) ? Colors.green : (stockunits >= 10)? Colors.blue : (stockunits >= 5)? Colors.grey : Colors.red,
              )),
          onTap: () => refresh(productid),
    );




}

