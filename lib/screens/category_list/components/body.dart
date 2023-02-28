import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shopadmin_app/app_globals.dart';
import 'package:shopadmin_app/components/custom_surfix_icon.dart';
import 'package:shopadmin_app/constants.dart';
import 'package:shopadmin_app/strconsts.dart';
import 'package:shopadmin_app/size_config.dart';
// import 'package:pdf/pdf.dart';
// import 'package:pdf/widgets.dart' as pw;
// import 'package:printing/printing.dart';
// import 'package:audiofileplayer/audiofileplayer.dart';


class CategoriesListBody extends StatefulWidget {
  const CategoriesListBody({Key? key}) : super(key: key);


  @override
  _CategoriesListBody createState() => _CategoriesListBody();
  }

class _CategoriesListBody extends State<CategoriesListBody> with AfterLayoutMixin<CategoriesListBody> {

  final _formCatKey = GlobalKey<FormState>();
  late ByteData printfont;
  late Uint8List assetLogoATC;
  bool logoPdfLoaded = false;
  Timer? timer;
  Timer? timerCatUpd;
  Timer? timerProdUpd;
  List<Category> listsearchcats = [];
  List<Product> listsearchprods = [];

  @override
  Widget build(BuildContext context) {
    gtextTranslate(context);
    return SafeArea(
      child: Row(
          children: [
              Form( key: _formCatKey,
                child: Row(
                  children: [
                    SizedBox(
                      width: getProportionateScreenWidth(defListFormMaxWidth),
                      child: Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(defFormFieldEdges05)),
                        child: SingleChildScrollView(
                          physics: const ScrollPhysics(),
                          child: Column(
                            children: [
                              SizedBox(height: getProportionateScreenHeight(defFormFieldEdges01)),
                              Text((admcurstore.isNotEmpty)? admcurstore.first.storename : txtCats, style: headingStyle, textAlign: TextAlign.center),
                              SizedBox(height: getProportionateScreenHeight(defFormFieldEdges01)),
                              buildCatSearchFormField(),
                              categoryListView(),
                              SizedBox(height: getProportionateScreenHeight(defFormFieldEdges30)),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: getProportionateScreenWidth(defFormFieldEdges20)),
                    SizedBox(
                      width: getProportionateScreenWidth(defListFormMaxWidth),
                      child: Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(defFormFieldEdges05)),
                        child: SingleChildScrollView(
                          physics: const ScrollPhysics(),
                          child: productsListBody(),
                        ),
                      ),
                    ),
                    SizedBox(width: getProportionateScreenWidth(defFormFieldEdges30)),
                  ]
                ),
              ),
          ],
        ),
    );
  }

  @override
  void dispose() {
    timer?.cancel();
    timerProdUpd?.cancel();
    timerCatUpd?.cancel();
    super.dispose();
  }

  @override
  void afterFirstLayout(BuildContext context) {
    loadPrintFont();
    readLogoPdf();
    // doCatQryAll();
    // doProdQryAll();
    setCatSearch('');
    setProdSearch('');
    setState(() {
      
    });
  }

  loadPrintFont() async {
    printfont = await rootBundle.load("assets/fonts/open-sans/OpenSans-Regular.ttf");
  }

  playBeepSound() {
    // Audio.load('assets/sounds/beep-read-02.mp3')..play()..dispose();
  }

  readLogoPdf() async {
    if (logoPdfLoaded == false) {
      final ByteData logoATCbytes = await rootBundle.load('assets/images/BTT-Logo_09.png');
      assetLogoATC = logoATCbytes.buffer.asUint8List();
      logoPdfLoaded = true;
    }
  }

  void logError(error) {
    print(error);
  }

  void logMessage(String message) {
    print(message);
  }

  syncCatsList(Category fromCat, int toCatIdx) {
    allstrcats[toCatIdx].id = fromCat.id;
    allstrcats[toCatIdx].catname = fromCat.catname;
    allstrcats[toCatIdx].catslug = fromCat.catslug;
    allstrcats[toCatIdx].catdesc = fromCat.catdesc;
    allstrcats[toCatIdx].catsort = fromCat.catsort;
    allstrcats[toCatIdx].catactive = fromCat.catactive;
    allstrcats[toCatIdx].created = fromCat.created;
    allstrcats[toCatIdx].prods = fromCat.prods;
  }

  doCatQryAll() {
    List<Category> tmpstrcats = [];
    var postdata = {
        "mobapp" : mobAppVal,
        "qrymode" : "all",
        "store_id" : "$admcurstoreid", 
        "filter" : admcurcatsearch, 
      };
    var posthdr = {
        'Accept': 'application/json',
        'Authorization' : 'Bearer $logintoken'
        };
    http.post(categoryqryEndPoint, body: postdata, headers: posthdr).then((result) {
      if (result.statusCode == 200) {
        var resary = jsonDecode(result.body);
        setState(() {
          resary['data'].asMap().forEach((i, v) {
            tmpstrcats.add(Category.fromJsonDet(v));
          });
          tmpstrcats.asMap().forEach((pk, pv) {
            if (allstrcats.where((prodelem) => (prodelem.id == pv.id)).isNotEmpty) {
              syncCatsList(pv,pk);
            } else {
              allstrcats.add(pv);
            }
          });
          
        });
        // logMessage(rescafprods.toString());
      } else {
        throw Exception(kCatAPIErr);
      }
    }).catchError((error) {
      // logError(error);
    });
  }

syncProdList(Product fromProd, int toProdIdx) {
    allstrprods[toProdIdx].id = fromProd.id;
    allstrprods[toProdIdx].storeid = fromProd.storeid;
    allstrprods[toProdIdx].storename = fromProd.storename;
    allstrprods[toProdIdx].catid = fromProd.catid;
    allstrprods[toProdIdx].catname = fromProd.catname;
    allstrprods[toProdIdx].prodname = fromProd.prodname;
    allstrprods[toProdIdx].prodcode = fromProd.prodcode;
    allstrprods[toProdIdx].prodslug = fromProd.prodslug;
    allstrprods[toProdIdx].proddesc = fromProd.proddesc;
    allstrprods[toProdIdx].prodsort = fromProd.prodsort;
    allstrprods[toProdIdx].prodico = fromProd.prodico;
    allstrprods[toProdIdx].prodimga = fromProd.prodimga;
    allstrprods[toProdIdx].prodimgb = fromProd.prodimgb;
    allstrprods[toProdIdx].prodimgc = fromProd.prodimgc;
    allstrprods[toProdIdx].prodpricesell = fromProd.prodpricesell;
    allstrprods[toProdIdx].prodpricebuy = fromProd.prodpricebuy;
    allstrprods[toProdIdx].prodtaxrate = fromProd.prodtaxrate;
    allstrprods[toProdIdx].prodactive = fromProd.prodactive;
    allstrprods[toProdIdx].stockunits = fromProd.stockunits;
    allstrprods[toProdIdx].minstock = fromProd.minstock;
    allstrprods[toProdIdx].prodcotype = fromProd.prodcotype;
    allstrprods[toProdIdx].prodsku = fromProd.prodsku;
    allstrprods[toProdIdx].prodref = fromProd.prodref;
    allstrprods[toProdIdx].weight = fromProd.weight;
    allstrprods[toProdIdx].weiunit = fromProd.weiunit;
    allstrprods[toProdIdx].sizew = fromProd.sizew;
    allstrprods[toProdIdx].sizeh = fromProd.sizeh;
    allstrprods[toProdIdx].sized = fromProd.sized;
    allstrprods[toProdIdx].sizeunit = fromProd.sizeunit;
    allstrprods[toProdIdx].supplid = fromProd.supplid;
  }

  doProdQryAll() {
    List<Product> tmpstrprods = [];
    var postdata = {
        "qrymode": 'allbystore',
        "mobapp" : mobAppVal,
        "store_id" : "$admcurstoreid",
        "filter" : admcurprodsearch,
      };
    var posthdr = {
        'Accept': 'application/json',
        'Authorization' : 'Bearer $logintoken'
        };
    http.post(productqryEndPoint, body: postdata, headers: posthdr).then((result) {
      if (result.statusCode == 200) {
        var resary = jsonDecode(result.body);
        setState(() {
          resary['data'].asMap().forEach((i, v) {
            tmpstrprods.add(Product.fromJsonDet(v));
          });
          tmpstrprods.asMap().forEach((pk, pv) {
            if (allstrprods.where((prodelem) => (prodelem.id == pv.id)).isNotEmpty) {
              syncProdList(pv,pk);
            } else {
              allstrprods.add(pv);
            }
          });
        });
        // logMessage(rescafprods.toString());
      } else {
        throw Exception(kProdAPIErr);
      }
    }).catchError((error) {
      // logError(error);
    });
  }

  categoryListView() {
    return Container(
        width: defListFormMaxWidth,
        height: catListScrlHeight,
        color: Colors.white,
        padding: EdgeInsets.all(defTxtInpEdge),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: defListFormMaxWidth,
          ),
          child: _categoriesListView(listsearchcats),
        ),
      );
  }

  ListView _categoriesListView(data) {
    return ListView.builder(
          shrinkWrap: true,
          itemCount: data.length,
          itemBuilder: (context, index) {
            String tmpcatdesc = data[index].catdesc;
            String tmpcatdesca = '';
            tmpcatdesca = (tmpcatdesc.length > 50)? tmpcatdesc.substring(0,49) + '..' : tmpcatdesc ;
            final String activetext = (data[index].catactive >= 1)? '\nActive' : '\nIn-active';
            return _cattile(data[index].id, data[index].catname, tmpcatdesca , data[index].catslug + 
            activetext , Icons.category, data[index].catactive);
          },
        );
  }
  
  ListTile _cattile(int categoryid, String title, String subtitle, String catslug, IconData icon, catactive) => ListTile(
        title: Text(title,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: defUIsize16,
            )),
        subtitle: Text(subtitle,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: defUIsize12,
            )),
        leading: Icon(
          icon,
          color: admcurcatid == categoryid ? kPrimaryColor : inActiveIconColor,
          size: defUIsize30,
        ),
        trailing: Text(catslug,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: defUIsize11,
              color: catactive >= 1 ? kPrimaryColor : inActiveIconColor,
            )),
        onTap: () => refreshCat(categoryid),
  );

  void refreshCat(int categoryid) {
      setState(() {
        admcurcatid = categoryid;
        admcurcat = allstrcats.where((element) => (element.id == categoryid)).toList();
        curcatactive = allstrcats.where((element) => (element.id == categoryid)).first.catactive > 0;
        admcurprodid = 0 ;
        admcurprod = [] ;
        setProdSearch(admcurprodsearch);
      });
  }

  productsListBody() {
    return SafeArea(
      child: SizedBox(
        width: getProportionateScreenWidth(defListFormMaxWidth),
        child: Padding(
          padding:
              EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(defFormFieldEdges05)),
          child: SingleChildScrollView(
            physics: const ScrollPhysics(),
            child: Column(
              children: [
                SizedBox(height: getProportionateScreenHeight(defFormFieldEdges01)),
                Text((admcurcat.isNotEmpty)? admcurcat.first.catname : txtCatProds, style: headingStyle, textAlign: TextAlign.center),
                SizedBox(height: getProportionateScreenHeight(defFormFieldEdges01)),
                buildProdSearchFormField(),
                SizedBox(height: getProportionateScreenHeight(defFormFieldEdges01)),
                productListView(),
                SizedBox(height: getProportionateScreenHeight(defFormFieldEdges30)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  productListView() {
    return Container(
        width: defListFormMaxWidth,
        height: prodListScrlHeight,
        color: Colors.white,
        padding: EdgeInsets.all(defTxtInpEdge),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: defListFormMaxWidth,
          ),
          child: _productsListView(listsearchprods),
        ),
      );
  }
 
    ListView _productsListView(data) {
      return ListView.builder(
            shrinkWrap: false,
            itemCount: data.length,
            itemBuilder: (context, index) {
              String tmpproddesc = '['+data[index].prodcode + ']';
              String tmpprodprice = posCcy.format(data[index].prodpricesell) + ' ' + admcurstore.first.currency;
              final String activetext = (data[index].prodactive >= 1)? 'stocks: ' + data[index].stockunits.toString() + '\nActive' : 
                                                                      'stocks: ' + data[index].stockunits.toString() + '\nIn-active'  ;
              return _prodtile(data[index].id, data[index].prodname, tmpproddesc + '\n'+ admcurstore.first.currency +': ' + tmpprodprice , 
                activetext , Icons.card_giftcard, data[index].prodactive , data[index].prodico, data[index].prodimga, data[index].stockunits);
            },
          );
    }
  
    ListTile _prodtile(int productid, String title, String subtitle, String catslug, IconData icon, prodactive, prodico, prodimga, stockunits) => ListTile(
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
          onTap: () => refreshProd(productid),
    );

    void refreshProd(int productid) {
        setState(() {
          admcurprodid = productid;
          admcurprod = allstrprods.where((element) => (element.id == productid)).toList();
          setProdSearch(admcurprodsearch);
        });
    }

    setProdSearch(String newValue) {
      setState(() {
        admcurprodsearch = newValue;
        listsearchprods = allstrprods.where((prodele) => (prodele.catid == admcurcatid && 
                      (prodele.prodname.toLowerCase().contains(admcurprodsearch)||
                      prodele.prodcode.toLowerCase().contains(admcurprodsearch)||
                      prodele.proddesc.toLowerCase().contains(admcurprodsearch)||
                      prodele.prodslug.toLowerCase().contains(admcurprodsearch))
                      )).toList();
      });
    }
    
    Container buildProdSearchFormField() {
    return Container(
      height: defSrearchInpHeight,
      width: defSrearchInpWidth,
      color: Colors.white,
      padding: EdgeInsets.all(defTxtInpEdge),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: defSrearchInpMaxHeight,
          maxWidth: defSrearchInpMaxWidth,
        ),
        child: TextFormField(
          onSaved: (newValue) => admcurprodsearch = newValue!,
          onChanged: (value) {
            admcurprodsearch = value;
            setProdSearch(value);
            return;
          },
          validator: (value) {
            return null;
          },
          decoration: const InputDecoration(counterText: ' ', counterStyle: TextStyle(fontSize: 0), helperStyle: TextStyle(fontSize: 0), errorStyle: TextStyle(fontSize: 0),
            labelText: "Search",
            hintText: "Text to filter",
            floatingLabelBehavior: FloatingLabelBehavior.always,
            suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Search Icon.svg"),
          ),
          initialValue: admcurprodsearch,
        ),
      ),
    );
  }

  setCatSearch(String newValue) {
    setState(() {
      admcurcatsearch = newValue.toLowerCase();
      listsearchcats = allstrcats.where((catele) => (catele.catname.toLowerCase().contains(admcurcatsearch)||
                                                       catele.catdesc.toLowerCase().contains(admcurcatsearch)||
                                                       catele.catslug.toLowerCase().contains(admcurcatsearch)
                                                       )).toList();
    });
  }
    
  Container buildCatSearchFormField() {
  return Container(
    height: defSrearchInpHeight,
    width: defSrearchInpWidth,
    color: Colors.white,
    padding: EdgeInsets.all(defTxtInpEdge),
    child: ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: defSrearchInpMaxHeight,
        maxWidth: defSrearchInpMaxWidth,
      ),
      child: TextFormField(
        onSaved: (newValue) => admcurcatsearch = newValue!,
        onChanged: (value) {
          admcurcatsearch = value;
          setCatSearch(value);
          return;
        },
        validator: (value) {
          return null;
        },
        decoration: const InputDecoration(counterText: ' ', counterStyle: TextStyle(fontSize: 0), helperStyle: TextStyle(fontSize: 0), errorStyle: TextStyle(fontSize: 0),
          labelText: "Search",
          hintText: "Text to filter",
          floatingLabelBehavior: FloatingLabelBehavior.always,
          suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Search Icon.svg"),
        ),
        initialValue: admcurcatsearch,
      ),
    ),
  );
}


}

