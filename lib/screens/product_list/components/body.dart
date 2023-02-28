import 'dart:io';
import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:flutter/services.dart';
import 'package:shopadmin_app/components/custom_surfix_icon.dart';
import 'package:shopadmin_app/app_globals.dart';
import 'package:shopadmin_app/constants.dart';
import 'package:shopadmin_app/strconsts.dart';
import 'package:shopadmin_app/size_config.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:image_picker/image_picker.dart';
import 'package:slugify/slugify.dart';
import 'package:shopadmin_app/components/default_button.dart';
import 'package:shopadmin_app/components/form_error.dart';
import 'package:shopadmin_app/helper/keyboard.dart';
import 'package:barcode_widget/barcode_widget.dart';

class ProductsListBody extends StatefulWidget {
  const ProductsListBody({Key? key}) : super(key: key);


  @override
  _ProductsListBody createState() => _ProductsListBody();

  }

class _ProductsListBody extends State<ProductsListBody>  with AfterLayoutMixin<ProductsListBody> {

  final _formProdKey = GlobalKey<FormState>();
  late ByteData printfont;
  late Uint8List assetLogoATC;
  bool logoPdfLoaded = false;
  Timer? timer;
  Timer? timerCatUpd;
  Timer? timerProdUpd;

    @override
    Widget build(BuildContext context) {
      gtextTranslate(context);
      return SafeArea(
        child: Row(
            children: [
                Form( key: _formProdKey,
                  child: Row(
                    children: [
                      SizedBox(
                        width: getProportionateScreenWidth(defListFormMaxWidth),
                        child: Padding(
                          padding:
                              EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(defFormFieldEdges01)),
                          child: SingleChildScrollView(
                            physics: const ScrollPhysics(),
                            child: Column(
                              children: [
                                SizedBox(height: getProportionateScreenHeight(defFormFieldEdges01)),
                                productsListBody(),
                                SizedBox(height: getProportionateScreenHeight(defFormFieldEdges20)),
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
                            child: productsEditBody(),
                          ),
                        ),
                      ),
                    ]
                  ),
                ),
            ],
          ),
      );
    }

  loadPrintFont() async {
    printfont = await rootBundle.load("assets/fonts/open-sans/OpenSans-Regular.ttf");
  }

  readLogoPdf() async {
    if (logoPdfLoaded == false) {
      final ByteData logoATCbytes = await rootBundle.load('assets/images/BTT-Logo_09.png');
      assetLogoATC = logoATCbytes.buffer.asUint8List();
      logoPdfLoaded = true;
    }
  }

  @override
  void afterFirstLayout(BuildContext context) {
    loadPrintFont();
    readLogoPdf();
    doCatQryAll();
    doProdQryAll();
    refreshProd(admcurprodid);
    setState(() {
      
    });
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

  productsListBody() {
    return SafeArea(
      child: SizedBox(
        width: getProportionateScreenWidth(defCatListFormMaxWidth),
        child: Padding(
          padding:
              EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(defFormFieldEdges05)),
          child: SingleChildScrollView(
            physics: const ScrollPhysics(),
            child: Column(
              children: [
                SizedBox(height: getProportionateScreenHeight(defFormFieldEdges01)),
                Text((admcurcat.isNotEmpty)? admcurcat.first.catname : 'Category products', style: headingStyle, textAlign: TextAlign.center),
                SizedBox(height: getProportionateScreenHeight(defFormFieldEdges01)),
                buildProdSearchFormField(),
                SizedBox(height: getProportionateScreenHeight(defFormFieldEdges01)),
                productListView(),
                SizedBox(height: getProportionateScreenHeight(defFormFieldEdges10)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  productListView() {
    List<Product> data = allstrprods.where((element) => (element.catid == admcurcatid)).toList();
    return Container(
        width: defListFormMaxWidth,
        height: prodListScrlHeight,
        color: Colors.white,
        padding: EdgeInsets.all(defTxtInpEdge),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: defListFormMaxWidth,
          ),
          child: _productsListView(data),
        ),
      );
  }

  ListView _productsListView(data) {
    var tmpstrccy = (admcurstore.isNotEmpty)? admcurstore.first.currency : "";
    return ListView.builder(
          shrinkWrap: false,
          itemCount: data.length,
          itemBuilder: (context, index) {
            // String tmpproddesc = '['+data[index].prodcode + '] ' + data[index].proddesc;
            String tmpproddesc = '['+data[index].prodcode + ']';
            // tmpproddesc = (tmpproddesc.length > 26)? tmpproddesc.substring(0,24)+'..' : tmpproddesc;
            final String activetext = (data[index].prodactive >= 1)? 'stocks: ' + data[index].stockunits.toString() + '\nActive' : 
                                                                    'stocks: ' + data[index].stockunits.toString() + '\nIn-active'  ;
            return _prodtile(data[index].id, data[index].prodname, tmpproddesc + '\n'+ tmpstrccy +': ' + data[index].prodpricesell.toString() , 
              activetext , Icons.card_giftcard, data[index].prodactive , data[index].prodico, data[index].prodimga, data[index].stockunits);
          },
        );
  }
  
  ListTile _prodtile(int productid, String title, String subtitle, String catslug, IconData icon, prodactive, prodico, prodimga, stockunits) => ListTile(
        title: Text(title, style: TextStyle(fontWeight: FontWeight.w500,fontSize: defUIsize16, color: (productid == admcurprodid)? kPrimaryColor : inActiveIconColor)),
        subtitle: Text(subtitle, style: TextStyle( fontWeight: FontWeight.w500, fontSize: defUIsize14, color: (productid == admcurprodid)? kPrimaryColor : inActiveIconColor)),
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
      setStatus('');
      errors = [];
      admcurprodid = productid;
      admcurprod = allstrprods.where((element) => (element.id == productid)).toList();
      id = (admcurprod.isNotEmpty)? admcurprod.first.id : 0;
      storeid = (admcurstore.isNotEmpty)? admcurstore.first.id : 0;
      storename = (admcurstore.isNotEmpty)? admcurstore.first.storename : "";
      catid = (admcurcat.isNotEmpty)? admcurcat.first.id : 0;
      catname = (admcurcat.isNotEmpty)? admcurcat.first.catname : "";
      prodname = (admcurprod.isNotEmpty)? admcurprod.first.prodname : "";
      prodslug = (admcurprod.isNotEmpty)? admcurprod.first.prodslug : "";
      proddesc = (admcurprod.isNotEmpty)? admcurprod.first.proddesc : "";
      prodimga = (admcurprod.isNotEmpty)? admcurprod.first.prodimga : "";
      prodimgb = (admcurprod.isNotEmpty)? admcurprod.first.prodimgb : "";
      prodimgc = (admcurprod.isNotEmpty)? admcurprod.first.prodimgc : "";
      prodsort = (admcurprod.isNotEmpty)? "${admcurprod.first.prodsort}" : "0";
      prodtaxrate = (admcurprod.isNotEmpty)? "${admcurprod.first.prodtaxrate}" : "7.5";
      prodpricesell = (admcurprod.isNotEmpty)? "${admcurprod.first.prodpricesell}" : "0";
      prodpricebuy = (admcurprod.isNotEmpty)? "${admcurprod.first.prodpricebuy}" : "0";
      prodactive = (admcurprod.isNotEmpty && admcurprod.first.prodactive > 0)? '1':'0';
      prodcode = (admcurprod.isNotEmpty)? admcurprod.first.prodcode : "";
      prodcodetype = (admcurprod.isNotEmpty)? admcurprod.first.prodcotype : "";
      prodref = (admcurprod.isNotEmpty)? admcurprod.first.prodref : "";
      prodsku = (admcurprod.isNotEmpty)? admcurprod.first.prodsku : "";
      prodstockunits = (admcurprod.isNotEmpty)? "${admcurprod.first.stockunits}" : "999";
      prodminstock = (admcurprod.isNotEmpty)? "${admcurprod.first.minstock}" : "99";
      prodcodeCtler.text = prodcode;
      prodcodetypeCtler.text = prodcodetype;
      prodrefCtler.text = prodref;
      prodskuCtler.text = prodsku;
      prodstocksCtler.text = prodstockunits;
      prodminstocksCtler.text = prodminstock;
      prodnameCtler.text = prodname;
      proddescCtler.text = proddesc;
      prodsortCtler.text = prodsort;
      prodtaxCtler.text = prodtaxrate;
      prodbuyCtler.text = prodpricebuy;
      prodsellCtler.text = prodpricesell;
    });
  }

  setProdSearch(String newValue) {
    setState(() {admcurprodsearch = newValue;});
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
          decoration: InputDecoration(counterText: ' ', counterStyle: const TextStyle(fontSize: 0), helperStyle: const TextStyle(fontSize: 0), errorStyle: const TextStyle(fontSize: 0),
            labelText: lblSearch,
            hintText: hintSearch,
            floatingLabelBehavior: FloatingLabelBehavior.always,
            suffixIcon: const CustomSurffixIcon(svgIcon: "assets/icons/Search Icon.svg"),
          ),
          initialValue: admcurprodsearch,
        ),
      ),
    );
  }

  productsEditBody() {
    return SafeArea(
          child: SizedBox(
            width: double.infinity,
            child: Padding(
              padding:
                  EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: getProportionateScreenHeight(defFormFieldEdges10)),
                    Text(txtFillProdDet,textAlign: TextAlign.center,),
                    SizedBox(height: getProportionateScreenHeight(defFormFieldEdges10)),
                    (admcurprod.isNotEmpty)? productEditForm() : Container(),
                    SizedBox(height: getProportionateScreenHeight(defFormFieldEdges10)),
                  ],
                ),
              ),
            ),
          ),
        );
  }

  int id = (admcurprod.isNotEmpty)? admcurprod.first.id : 0;
  int storeid = (admcurstore.isNotEmpty)? admcurstore.first.id : 0;
  String storename = (admcurstore.isNotEmpty)? admcurstore.first.storename : "";
  int catid = (admcurcat.isNotEmpty)? admcurcat.first.id : 0;
  String catname = (admcurcat.isNotEmpty)? admcurcat.first.catname : "";
  String prodname = (admcurprod.isNotEmpty)? admcurprod.first.prodname : "";
  String prodslug = (admcurprod.isNotEmpty)? admcurprod.first.prodslug : "";
  String proddesc = (admcurprod.isNotEmpty)? admcurprod.first.proddesc : "";
  String prodimga = (admcurprod.isNotEmpty)? admcurprod.first.prodimga : "";
  String prodimgb = (admcurprod.isNotEmpty)? admcurprod.first.prodimgb : "";
  String prodimgc = (admcurprod.isNotEmpty)? admcurprod.first.prodimgc : "";
  String prodsort = (admcurprod.isNotEmpty)? "${admcurprod.first.prodsort}" : "0";
  String prodtaxrate = (admcurprod.isNotEmpty)? "${admcurprod.first.prodtaxrate}" : "7.5";
  String prodpricesell = (admcurprod.isNotEmpty)? "${admcurprod.first.prodpricesell}" : "0";
  String prodpricebuy = (admcurprod.isNotEmpty)? "${admcurprod.first.prodpricebuy}" : "0";
  String prodactive = (admcurprod.isNotEmpty && admcurprod.first.prodactive > 0)? '1':'0';
  String prodcode = (admcurprod.isNotEmpty)? admcurprod.first.prodcode : "";
  String prodcodetype = (admcurprod.isNotEmpty)? admcurprod.first.prodcotype : "";
  String prodref = (admcurprod.isNotEmpty)? admcurprod.first.prodref : "";
  String prodsku = (admcurprod.isNotEmpty)? admcurprod.first.prodsku : "";
  String prodstockunits = (admcurprod.isNotEmpty)? "${admcurprod.first.stockunits}" : "999";
  String prodminstock = (admcurprod.isNotEmpty)? "${admcurprod.first.minstock}" : "99";
  var prodcodeCtler = TextEditingController();
  var prodcodetypeCtler = TextEditingController();
  var prodrefCtler = TextEditingController();
  var prodskuCtler = TextEditingController();
  var prodstocksCtler = TextEditingController();
  var prodminstocksCtler = TextEditingController();
  var prodnameCtler = TextEditingController();
  var proddescCtler = TextEditingController();
  var prodsortCtler = TextEditingController();
  var prodtaxCtler = TextEditingController();
  var prodbuyCtler = TextEditingController();
  var prodsellCtler = TextEditingController();
  final FocusNode _prodcodefocus = FocusNode();
  pw.Document doc = pw.Document();

  @override
  void initState() {
    super.initState();
    _prodcodefocus.addListener(_onFocusChange);
    prodcodeCtler.text = prodcode;
  }

  void _onFocusChange(){
    if (_prodcodefocus.hasFocus) {
      // scanProdBarcode();
    }
  }

  String poststatus = '';
  List<String> errors = [];

  Future<XFile?>? imgafile;
  String? base64ImgaImage;
  XFile? tmpimgaFile;
  bool pickimga=false;

  Future<XFile?>? imgbfile;
  String? base64ImgbImage;
  XFile? tmpimgbFile;
  bool pickimgb=false;

  Future<XFile?>? imgcfile;
  String? base64ImgcImage;
  XFile? tmpimgcFile;
  bool pickimgc=false;
  final ImagePicker _pickera = ImagePicker();
  final ImagePicker _pickerb = ImagePicker();
  final ImagePicker _pickerc = ImagePicker();


  void addError({required String error}) {
    if (!errors.contains(error)) {
      setState(() {
        errors.add(error);
      });
    }
  }

  void removeError({required String error}) {
    if (errors.contains(error)) {
      setState(() {
        errors.remove(error);
      });
    }
  }

  btnScanProdCode() {
    prodcodeCtler.text = '';
    _prodcodefocus.requestFocus();
    scanProdBarcodeBtn();
  }

  Future<void> scanProdBarcodeBtn() async {
    String barcodeScanRes;
      try {
        barcodeScanRes = await FlutterBarcodeScanner.scanBarcode("#ff6666", txtBcodeCancel, true, ScanMode.DEFAULT);
      } on PlatformException {
        barcodeScanRes = txtBcodeScanErr;
      }
      if (!mounted) return;
      setBcodePcodevalueBtn(barcodeScanRes);
  }

  setBcodePcodevalueBtn(String barcode) {
      setState(() {
        prodcode = barcode.trim();
        prodcodeCtler.text = prodcode;
      });
  }

  productEditForm() {
    return Container(
      width: defInpFormWidth,
      color: Colors.white,
      padding: EdgeInsets.all(defTxtInpEdge),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: defInpFormMaxWidth,
        ),
        child: Column(
          children: [
            buildProdCodeDraw(),
            SizedBox(height: getProportionateScreenHeight(defFormFieldEdges01)),
            GreyButton(
              text: txtPrintProdCode,
              press: () {
                  btnPrintProdCode();
              },
            ),
            SizedBox(height: getProportionateScreenHeight(defFormFieldEdges20)),
            buildProdCodeFormField(),
            SizedBox(height: getProportionateScreenHeight(defFormFieldEdges01)),
            GreyButton(
              text: txtScanProdCode,
              press: () {
                  btnScanProdCode();
              },
            ),
            SizedBox(height: getProportionateScreenHeight(defFormFieldEdges30)),
            buildProdRefFormField(),
            SizedBox(height: getProportionateScreenHeight(defFormFieldEdges01)),
            buildProdSkuFormField(),
            SizedBox(height: getProportionateScreenHeight(defFormFieldEdges01)),
            buildProdStockunitsFormField(),
            SizedBox(height: getProportionateScreenHeight(defFormFieldEdges01)),
            buildProdMinstocksFormField(),
            SizedBox(height: getProportionateScreenHeight(defFormFieldEdges01)),
            buildProdNameFormField(),
            SizedBox(height: getProportionateScreenHeight(defFormFieldEdges01)),
            buildProdDescFormField(),
            SizedBox(height: getProportionateScreenHeight(defFormFieldEdges01)),
            buildProdSlugFormField(),
            SizedBox(height: getProportionateScreenHeight(defFormFieldEdges01)),
            buildProdSortFormField(),
            SizedBox(height: getProportionateScreenHeight(defFormFieldEdges01)),
            buildProdTaxrateFormField(),
            SizedBox(height: getProportionateScreenHeight(defFormFieldEdges01)),
            buildProdPricesellFormField(),
            SizedBox(height: getProportionateScreenHeight(defFormFieldEdges01)),
            buildProdPricebuyFormField(),
            SizedBox(height: getProportionateScreenHeight(defFormFieldEdges01)),
            buildActiveFormField(),
            SizedBox(height: getProportionateScreenHeight(defFormFieldEdges01)),
            GreyButton(
              text: txtProdPhotoPick1,
              press: () {
                  chooseImageImga();
              },
            ),
            SizedBox(
              height: getProportionateScreenHeight(200),
              child: Column(crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        SizedBox(height: getProportionateScreenHeight(defFormFieldEdges10)),
                        showImgaImage(),
                        SizedBox(height: getProportionateScreenHeight(defFormFieldEdges10)),
                      ],
                    ),
            ),
            SizedBox(height: getProportionateScreenHeight(defFormFieldEdges01)),
            GreyButton( 
              text: txtProdPhotoPick2,
              press: () {
                  chooseImageImgb();
              },
            ),
            SizedBox(
              height: getProportionateScreenHeight(200),
              child: Column(crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        SizedBox(height: getProportionateScreenHeight(defFormFieldEdges10)),
                        showImgbImage(),
                        SizedBox(height: getProportionateScreenHeight(defFormFieldEdges10)),
                      ],
                    ),
            ),
            SizedBox(height: getProportionateScreenHeight(defFormFieldEdges01)),
            GreyButton(
              text: txtProdPhotoPick3,
              press: () {
                  chooseImageImgc();
              },
            ),
            SizedBox(
              height: getProportionateScreenHeight(200),
              child: Column(crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        SizedBox(height: getProportionateScreenHeight(defFormFieldEdges10)),
                        showImgcImage(),
                        SizedBox(height: getProportionateScreenHeight(defFormFieldEdges10)),
                      ],
                    ),
            ),
            SizedBox(height: getProportionateScreenHeight(defFormFieldEdges10)),
            Text(poststatus, textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 15.0)),
            SizedBox(height: getProportionateScreenHeight(defFormFieldEdges10)),
            FormError(errors: errors),
            SizedBox(height: getProportionateScreenHeight(defFormFieldEdges10)),
            DefaultButton(
              text: lblSaveItem,
              press: () {
                if (_formProdKey.currentState!.validate()) {
                  productSaveChanges();
                }
              },
            ),
            SizedBox(height: getProportionateScreenHeight(defFormFieldEdges30)),
          ],
        ),
      ),
    );
    
  }

  chooseImageImga() {
    setState(() {
      imgafile = _pickera.pickImage(source: ImageSource.gallery);
    });
    setStatus('');
  }

  chooseImageImgb() {
    setState(() {
      imgbfile = _pickerb.pickImage(source: ImageSource.gallery);
    });
    setStatus('');
  }

  chooseImageImgc() {
    setState(() {
      imgcfile = _pickerc.pickImage(source: ImageSource.gallery);
    });
    setStatus('');
  }

  Widget showImgcImage() {
    return FutureBuilder<XFile?>(
      future: imgcfile,
      builder: (BuildContext context, AsyncSnapshot<XFile?> snapshot) {
        if (snapshot.connectionState == ConnectionState.done && null != snapshot.data) {
          tmpimgcFile = snapshot.data!;
          base64ImgcImage = base64Encode(File(snapshot.data!.path).readAsBytesSync());
          pickimgc=true;
          return Flexible(
            child: Image.file(File(snapshot.data!.path),fit: BoxFit.scaleDown, height: getProportionateScreenHeight(280),),
          );
        } else if (prodimgc != '') {
          return Flexible(
            child: Image.network(imagehost+prodimgc, fit: BoxFit.scaleDown, height: getProportionateScreenHeight(280),),
          );
        } else if (null != snapshot.error) {
          return Text(
            txtPhotoPickErr3,
            textAlign: TextAlign.center,
          );
        } else {
          return Text(
            txtNoImgSel,
            textAlign: TextAlign.center,
          );
        }
      },
    );
  }

  Widget showImgbImage() {
    return FutureBuilder<XFile?>(
      future: imgbfile,
      builder: (BuildContext context, AsyncSnapshot<XFile?> snapshot) {
        if (snapshot.connectionState == ConnectionState.done && null != snapshot.data) {
          tmpimgbFile = snapshot.data!;
          base64ImgbImage = base64Encode(File(snapshot.data!.path).readAsBytesSync());
          pickimgb=true;
          return Flexible(
            child: Image.file(File(snapshot.data!.path),fit: BoxFit.scaleDown, height: getProportionateScreenHeight(280),),
          );
        } else if (prodimgb != '') {
          return Flexible(
            child: Image.network(imagehost+prodimgb, fit: BoxFit.scaleDown, height: getProportionateScreenHeight(280),),
          );
        } else if (null != snapshot.error) {
          return Text(
            txtPhotoPickErr2,
            textAlign: TextAlign.center,
          );
        } else {
          return Text(
            txtNoImgSel,
            textAlign: TextAlign.center,
          );
        }
      },
    );
  }

  Widget showImgaImage() {
    return FutureBuilder<XFile?>(
      future: imgafile,
      builder: (BuildContext context, AsyncSnapshot<XFile?> snapshot) {
        if (snapshot.connectionState == ConnectionState.done && null != snapshot.data) {
          tmpimgaFile = snapshot.data!;
          base64ImgaImage = base64Encode(File(snapshot.data!.path).readAsBytesSync());
          pickimga=true;
          return Flexible(
            child: Image.file(File(snapshot.data!.path),fit: BoxFit.scaleDown, height: getProportionateScreenHeight(280),),
          );
        } else if (prodimga != '') {
          return Flexible(
            child: Image.network(imagehost+prodimga, fit: BoxFit.scaleDown, height: getProportionateScreenHeight(280),),
          );
        } else if (null != snapshot.error) {
          return Text(
            txtPhotoPickErr1,
            textAlign: TextAlign.center,
          );
        } else {
          return Text(
            txtNoImgSel,
            textAlign: TextAlign.center,
          );
        }
      },
    );
  }



  setStatusA(bool newvalue) {
    setState(() {
      curprodactive=newvalue;
    });
  }

  Container buildActiveFormField() {
    return Container(
      height: defTxtInpHeight,
      width: defTxtInpWidth,
      color: Colors.white,
      padding: EdgeInsets.all(defTxtInpEdge),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: defTxtInpMaxHeight,
          maxWidth: defTxtInpMaxWidth,
        ),
        child: CheckboxListTile(
            activeColor: Theme.of(context).colorScheme.secondary,
            title: Text(txtTitleActProd),
            value: curprodactive,
            onChanged: (value) => setStatusA(value!),
            subtitle: !curprodactive
              ? Padding(
                  padding: const EdgeInsets.fromLTRB(12.0, 0, 0, 0), 
                  child: Text(txtChkActive, style: const TextStyle(color: Color(0xFFe53935), fontSize: 12),),)
              : null,
          ),
      ),
    );
  }

  setStatus(String message) {
    setState(() {
      poststatus = message;
    });
  }

  productSaveChanges() {
    setStatus(txtSavingItem);
    String? imgafileName;
    String? newimga;
    if (pickimga) {
      newimga = '1';
      imgafileName = tmpimgaFile!.path.split('/').last;
    } else {
      newimga = '0';
      imgafileName='';
      base64ImgaImage='';
    }

    String? imgbfileName;
    String? newimgb;
    if (pickimgb) {
      newimgb = '1';
      imgbfileName = tmpimgbFile!.path.split('/').last;
    } else {
      newimgb = '0';
      imgbfileName='';
      base64ImgbImage='';
    }

    String? imgcfileName;
    String? newimgc;
    if (pickimgc) {
      newimgc = '1';
      imgcfileName = tmpimgcFile!.path.split('/').last;
    } else {
      newimgc = '0';
      imgcfileName='';
      base64ImgcImage='';
    }

    var postdata = {
        "id": "$admcurprodid",
        "store_id" : (admcurstore.isNotEmpty)? "${admcurstore.first.id}" : "0",
        "store_name" : (admcurstore.isNotEmpty)? admcurstore.first.storename : "",
        "cat_id" : (admcurcatid>0) ? '$admcurcatid' : '', 
        "cat_name" : (admcurcat.isNotEmpty) ? admcurcat.first.catname : '', 
        "name" : (prodname.isNotEmpty) ? prodname : '',
        "prod_sku" : (prodsku.isNotEmpty) ? prodsku : '',
        "prod_ref" : (prodref.isNotEmpty) ? prodref : '',
        "prod_code" : (prodcode.isNotEmpty) ? prodcode : '',
        "prod_cotype" : (prodcodetype.isNotEmpty) ? prodcodetype : '',
        "stockunits" : (prodstockunits.isNotEmpty) ? prodstockunits : '',
        "slug" : (prodslug.isNotEmpty) ? prodslug : '', 
        "description" : (proddesc.isNotEmpty) ? proddesc : '', 
        "sort" : (prodsort.isNotEmpty) ? prodsort : '', 
        "active" : (curprodactive)? '1' : '0', 
        "taxrate" : (prodtaxrate.isNotEmpty) ? prodtaxrate : '', 
        "pricesell" : (prodpricesell.isNotEmpty) ? prodpricesell : '', 
        "pricebuy" : (prodpricebuy.isNotEmpty) ? prodpricebuy : '', 
        "newimga" : newimga,
        "imgafile": imgafileName,
        "imga_img64" : base64ImgaImage,
        "newimgb" : newimgb,
        "imgbfile": imgbfileName,
        "imgb_img64" : base64ImgbImage,
        "newimgc" : newimgc,
        "imgcfile": imgcfileName,
        "imgc_img64" : base64ImgcImage,
      };
    var posthdr = {
        'Accept': 'application/json',
        'Authorization' : 'Bearer $logintoken'
      };
    http.post(producteditEndPoint, body: postdata, headers: posthdr ).then((result) {
        if (result.statusCode == 200) {
          var resary = jsonDecode(result.body);
          if (resary['status'] > 0) {
              setState(() {
                var tmpprod = Product.fromJsonDet(resary['data']);
                if (allstrprods.where((prodelem) => (prodelem.id == tmpprod.id)).isNotEmpty) {
                  syncProdList(tmpprod,allstrprods.indexWhere((prodelem) => (prodelem.id == tmpprod.id)));
                } else {
                  allstrprods.add(tmpprod);
                }
                admcurprod=[];
                admcurprod.add(tmpprod);
                admcurprodid=tmpprod.id;
                curprodactive=(tmpprod.prodactive>0);
              });
              setStatus(txtStatSaved);
              KeyboardUtil.hideKeyboard(context);
          } else if (resary['status'] == -1) {
             setStatus(kProdSaveErr);
          } else {
            setStatus(kProdSaveErr);
          }
        } else {
          throw Exception(kProdSaveErr);
        }
    }).catchError((error) {
      setStatus(kProdSaveErr);
    });
  }

  startBarcodeScanStream() async {
    FlutterBarcodeScanner.getBarcodeStreamReceiver(
            "#ff6666", txtBcodeCancel, true, ScanMode.BARCODE)!
        .listen((barcode) => print(barcode));
  }

  Future<void> scanProdCodeQR() async {
    String barcodeScanRes;
    if(prodcode.isEmpty || prodcode == '') {
      try {
        barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
            "#ff6666", txtBcodeCancel, true, ScanMode.QR);
      } on PlatformException {
        barcodeScanRes = txtBcodeScanErr;
      }
      if (!mounted) return;
      setBcodePcodevalue(barcodeScanRes);
    }
  }

  Future<void> scanProdBarcode() async {
    String barcodeScanRes;
    if(prodcode.isEmpty || prodcode == '') {
      try {
        barcodeScanRes = await FlutterBarcodeScanner.scanBarcode("#ff6666", txtBcodeCancel, true, ScanMode.DEFAULT);
      } on PlatformException {
        barcodeScanRes = txtBcodeScanErr;
      }
      if (!mounted) return;
      setBcodePcodevalue(barcodeScanRes);
    }
  }

  setBcodePcodevalue(String barcode) {
    setState(() {
      if(prodcode.isEmpty || prodcode == '') {
        prodcode = barcode.trim();
        prodcodeCtler.text = prodcode;
      }
    });
  }

  btnPrintProdCode() {
    final printttf = pw.Font.ttf(printfont);
    doc = pw.Document();
    var bcsvg = buildBarcode(Barcode.code128(escapes: true),prodcode);
    var tmpstrccy = (admcurstore.isNotEmpty)? admcurstore.first.currency : "";
    doc.addPage(pw.Page(
          pageFormat: PdfPageFormat.roll80,
          build: (pw.Context pcontext) {
            return pw.Center(
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.center,
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: 
                  <pw.Widget>[
                      pw.Center(child: pw.Text(prodname, style: pw.TextStyle(font: printttf, fontSize: 12))),
                      pw.Center(child: pw.Text('(' + posCcy.format(double.parse(prodpricesell)) + '' + tmpstrccy + ')', style: pw.TextStyle(font: printttf, fontSize: 10))),
                      pw.ClipRect(child: pw.Container(width: defBarcodeMaxWidth,height: defBarcodeMaxHeight,child: pw.SvgImage(svg: bcsvg))),
                    ]
                ),
              );
          }));
    Printing.layoutPdf(onLayout: (PdfPageFormat format) => doc.save());
  }

  buildBarcode(Barcode bc,String data, {double? width,double? height,double? fontHeight}) {
    return bc.toSvg(data,width: width ?? defBarcodeMaxWidth,height: height ?? defBarcodeMaxHeight,fontHeight: fontHeight);
  }
 
  Container buildProdCodeDraw() {
    return Container(
      height: defBarcodeMaxHeight,
      width: defBarcodeMaxWidth,
      color: Colors.white,
      padding: EdgeInsets.all(defTxtInpEdge),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: defBarcodeMaxHeight,
          maxWidth: defBarcodeMaxWidth,
        ),
        child: BarcodeWidget(
          barcode:  Barcode.code128(escapes: true),
          data: (prodcode.isNotEmpty)? prodcode : "0000000",
          width: defBarcodeWidth,
          height: defBarcodeHeight,
        ),
      ),
    );
  }

  Container buildProdCodeFormField() {
    return Container(
      height: defTxtInpHeight,
      width: defTxtInpWidth,
      color: Colors.white,
      padding: EdgeInsets.all(defTxtInpEdge),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: defTxtInpMaxHeight,
          maxWidth: defTxtInpMaxWidth,
        ),
        child: TextFormField(
            controller: prodcodeCtler,
            onSaved: (newValue) => prodcode = newValue!,
            onChanged: (value) {
              prodcode = value;
              return;
            },
            validator: (value) {
              return null;
            },
            decoration: InputDecoration(counterText: ' ', counterStyle: const TextStyle(fontSize: 0), helperStyle: const TextStyle(fontSize: 0), errorStyle: const TextStyle(fontSize: 0),
              labelText: lblProdBarcode,
              hintText: hintProdBarcode,
              floatingLabelBehavior: FloatingLabelBehavior.always,
              suffixIcon: const CustomSurffixIcon(svgIcon: "assets/icons/barcode.svg"),
            ),
            focusNode: _prodcodefocus,
          ),
      ),
    );
  }


  Container buildProdCodetypeFormField() {
    return Container(
      height: defTxtInpHeight,
      width: defTxtInpWidth,
      color: Colors.white,
      padding: EdgeInsets.all(defTxtInpEdge),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: defTxtInpMaxHeight,
          maxWidth: defTxtInpMaxWidth,
        ),
        child: TextFormField(
            onSaved: (newValue) => prodcodetype = newValue!,
            onChanged: (value) {
              prodcodetype = value;
              return;
            },
            validator: (value) {
              return null;
            },
            decoration: InputDecoration(counterText: ' ', counterStyle: const TextStyle(fontSize: 0), helperStyle: const TextStyle(fontSize: 0), errorStyle: const TextStyle(fontSize: 0),
              labelText: lblProdBcodeType,
              hintText: hintProdBcodeType,
              floatingLabelBehavior: FloatingLabelBehavior.always,
              suffixIcon: const CustomSurffixIcon(svgIcon: "assets/icons/Parcel.svg"),
            ),
            initialValue: prodcodetype,
          ),
      ),
    );
  }

  Container buildProdSkuFormField() {
    return Container(
      height: defTxtInpHeight,
      width: defTxtInpWidth,
      color: Colors.white,
      padding: EdgeInsets.all(defTxtInpEdge),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: defTxtInpMaxHeight,
          maxWidth: defTxtInpMaxWidth,
        ),
        child: TextFormField(
            controller: prodskuCtler,
            onSaved: (newValue) => prodsku = newValue!,
            onChanged: (value) {
              prodsku = value;
              return;
            },
            validator: (value) {
              return null;
            },
            decoration: InputDecoration(counterText: ' ', counterStyle: const TextStyle(fontSize: 0), helperStyle: const TextStyle(fontSize: 0), errorStyle: const TextStyle(fontSize: 0),
              labelText: lblProdSKU,
              hintText: hintProdSKU,
              floatingLabelBehavior: FloatingLabelBehavior.always,
              suffixIcon: const CustomSurffixIcon(svgIcon: "assets/icons/qrcode.svg"),
            ),
          ),
      ),
    );
  }

  Container buildProdStockunitsFormField() {
    return Container(
      height: defTxtInpHeight,
      width: defTxtInpWidth,
      color: Colors.white,
      padding: EdgeInsets.all(defTxtInpEdge),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: defTxtInpMaxHeight,
          maxWidth: defTxtInpMaxWidth,
        ),
        child: TextFormField(
            controller: prodstocksCtler,
            keyboardType: TextInputType.number,
            onSaved: (newValue) => prodstockunits = newValue!,
            onChanged: (value) {
              if (value.isNotEmpty) {
                removeError(error: kProdStksNullErr);
                prodstockunits = value;
              }
              return;
            },
            validator: (value) {
              if (value!.isEmpty) {
                addError(error: kProdStksNullErr);
                return "";
              }
              return null;
            },
            decoration: InputDecoration(counterText: ' ', counterStyle: const TextStyle(fontSize: 0), helperStyle: const TextStyle(fontSize: 0), errorStyle: const TextStyle(fontSize: 0),
              labelText: lblProdStock,
              hintText: hintProdStock,
              floatingLabelBehavior: FloatingLabelBehavior.always,
              suffixIcon: const CustomSurffixIcon(svgIcon: "assets/icons/cart-plus.svg"),
            ),
          ),
      ),
    );
  }

  Container buildProdMinstocksFormField() {
    return Container(
      height: defTxtInpHeight,
      width: defTxtInpWidth,
      color: Colors.white,
      padding: EdgeInsets.all(defTxtInpEdge),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: defTxtInpMaxHeight,
          maxWidth: defTxtInpMaxWidth,
        ),
        child: TextFormField(
            controller: prodminstocksCtler,
            keyboardType: TextInputType.number,
            onSaved: (newValue) => prodminstock = newValue!,
            onChanged: (value) {
              if (value.isNotEmpty) {
                removeError(error: kProdMinStksNullErr);
                prodminstock = value;
              }
              return;
            },
            validator: (value) {
              if (value!.isEmpty) {
                addError(error: kProdMinStksNullErr);
                return "";
              }
              return null;
            },
            decoration: InputDecoration(counterText: ' ', counterStyle: const TextStyle(fontSize: 0), helperStyle: const TextStyle(fontSize: 0), errorStyle: const TextStyle(fontSize: 0),
              labelText: lblProdMinStock,
              hintText: hintProdMinStock,
              floatingLabelBehavior: FloatingLabelBehavior.always,
              suffixIcon: const CustomSurffixIcon(svgIcon: "assets/icons/cart-plus.svg"),
            ),
          ),
      ),
    );
  }

  Container buildProdRefFormField() {
    return Container(
      height: defTxtInpHeight,
      width: defTxtInpWidth,
      color: Colors.white,
      padding: EdgeInsets.all(defTxtInpEdge),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: defTxtInpMaxHeight,
          maxWidth: defTxtInpMaxWidth,
        ),
        child: TextFormField(
            controller: prodrefCtler,
            onSaved: (newValue) => prodref = newValue!,
            onChanged: (value) {
              prodref = value;
              return;
            },
            validator: (value) {
              return null;
            },
            decoration: InputDecoration(counterText: ' ', counterStyle: const TextStyle(fontSize: 0), helperStyle: const TextStyle(fontSize: 0), errorStyle: const TextStyle(fontSize: 0),
              labelText: lblProdRef,
              hintText: hintProdRef,
              floatingLabelBehavior: FloatingLabelBehavior.always,
              suffixIcon: const CustomSurffixIcon(svgIcon: "assets/icons/TextIcon.svg"),
            ),
          ),
      ),
    );
  }

  saveProdName(String newValue) {
    setState(() {
      prodname = newValue;
      prodslug = slugify(prodname);
    });
    prodSlugTxtCtrl.text = slugify(prodslug);
  }

  Container buildProdNameFormField() {
    return Container(
      height: defTxtInpHeight,
      width: defTxtInpWidth,
      color: Colors.white,
      padding: EdgeInsets.all(defTxtInpEdge),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: defTxtInpMaxHeight,
          maxWidth: defTxtInpMaxWidth,
        ),
        child: TextFormField(
            controller: prodnameCtler,
            onSaved: (newValue) => saveProdName(newValue!),
            onChanged: (value) {
              if (value.isNotEmpty) {
                removeError(error: kProdNameNullErr);
                saveProdName(value);
              }
              return;
            },
            validator: (value) {
              if (value!.isEmpty) {
                addError(error: kProdNameNullErr);
                return "";
              }
              return null;
            },
            decoration: InputDecoration(counterText: ' ', counterStyle: const TextStyle(fontSize: 0), helperStyle: const TextStyle(fontSize: 0), errorStyle: const TextStyle(fontSize: 0),
              labelText: lblProdName,
              hintText: hintProdName,
              floatingLabelBehavior: FloatingLabelBehavior.always,
              suffixIcon: const CustomSurffixIcon(svgIcon: "assets/icons/TextIcon.svg"),
            ),
          ),
      ),
    );
  }

  Container buildProdDescFormField() {
    return Container(
      height: defTxtBoxHeight,
      width: defTxtBoxWidth,
      color: Colors.white,
      padding: EdgeInsets.all(defTxtInpEdge),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: defTxtBoxMaxHeight,
          maxWidth: defTxtBoxMaxWidth,
        ),
        child: TextFormField(
          controller: proddescCtler,
          maxLines: defTxtBoxLines03,
          onSaved: (newValue) => proddesc = newValue!,
          onChanged: (value) {
            if (value.isNotEmpty) {
              removeError(error: kProdDescNullErr);
              proddesc = value;
            }
            return;
          },
          validator: (value) {
            if (value!.isEmpty) {
              addError(error: kProdDescNullErr);
              return "";
            }
            return null;
          },
          decoration: InputDecoration(counterText: ' ', counterStyle: const TextStyle(fontSize: 0), helperStyle: const TextStyle(fontSize: 0), errorStyle: const TextStyle(fontSize: 0),
            labelText: lblProdDesc,
            hintText: hintProdDesc,
            floatingLabelBehavior: FloatingLabelBehavior.always,
            suffixIcon: const CustomSurffixIcon(svgIcon: "assets/icons/TextIcon.svg"),
          ),
        ),
      ),
    );
  }

  var prodSlugTxtCtrl =  TextEditingController();
  Container buildProdSlugFormField() {
    prodSlugTxtCtrl.text = slugify(prodname);
    return Container(
      height: defTxtInpHeight,
      width: defTxtInpWidth,
      color: Colors.white,
      padding: EdgeInsets.all(defTxtInpEdge),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: defTxtInpMaxHeight,
          maxWidth: defTxtInpMaxWidth,
        ),
        child: TextFormField(
            controller: prodSlugTxtCtrl,
            onSaved: (newValue) => prodslug = newValue!,
            onChanged: (value) {
              if (value.isNotEmpty) {
                removeError(error: kProdSlugNullErr);
                prodslug = value;
              }
              return;
            },
            validator: (value) {
              if (value!.isEmpty) {
                addError(error: kProdSlugNullErr);
                return "";
              }
              return null;
            },
            decoration: InputDecoration(counterText: ' ', counterStyle: const TextStyle(fontSize: 0), helperStyle: const TextStyle(fontSize: 0), errorStyle: const TextStyle(fontSize: 0),
              labelText: lblProdSlug,
              hintText: hintProdSlug,
              floatingLabelBehavior: FloatingLabelBehavior.always,
              suffixIcon: const CustomSurffixIcon(svgIcon: "assets/icons/TextIcon.svg"),
            ),
          ),
      ),
    );
  }


  Container buildProdSortFormField() {
    return Container(
      height: defTxtInpHeight,
      width: defTxtInpWidth,
      color: Colors.white,
      padding: EdgeInsets.all(defTxtInpEdge),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: defTxtInpMaxHeight,
          maxWidth: defTxtInpMaxWidth,
        ),
        child: TextFormField(
              controller: prodsortCtler,
              keyboardType: TextInputType.number,
              onSaved: (newValue) => prodsort = newValue!,
              onChanged: (value) {
                if (value.isNotEmpty) {
                  removeError(error: kProdSortNullErr);
                  prodsort = value;
                }
                return;
              },
              validator: (value) {
                if (value!.isEmpty) {
                  addError(error: kProdSortNullErr);
                  return "";
                }
                return null;
              },
              decoration: InputDecoration(counterText: ' ', counterStyle: const TextStyle(fontSize: 0), helperStyle: const TextStyle(fontSize: 0), errorStyle: const TextStyle(fontSize: 0),
                labelText: lblProdSort,
                hintText: hintProdSort,
                floatingLabelBehavior: FloatingLabelBehavior.always,
                suffixIcon: const CustomSurffixIcon(svgIcon: "assets/icons/sort-numeric-down.svg"),
              ),
            ),
      ),
    );
  }

  Container buildProdTaxrateFormField() {
    return Container(
      height: defTxtInpHeight,
      width: defTxtInpWidth,
      color: Colors.white,
      padding: EdgeInsets.all(defTxtInpEdge),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: defTxtInpMaxHeight,
          maxWidth: defTxtInpMaxWidth,
        ),
        child: TextFormField(
            controller: prodtaxCtler,
            keyboardType: TextInputType.number,
            onSaved: (newValue) => prodtaxrate = newValue!,
            onChanged: (value) {
              if (value.isNotEmpty) {
                removeError(error: kProdTaxNullErr);
                prodtaxrate = value;
              }
              return;
            },
            validator: (value) {
              if (value!.isEmpty) {
                addError(error: kProdTaxNullErr);
                return "";
              }
              return null;
            },
            decoration: InputDecoration(counterText: ' ', counterStyle: const TextStyle(fontSize: 0), helperStyle: const TextStyle(fontSize: 0), errorStyle: const TextStyle(fontSize: 0),
              labelText: lblTaxrate,
              hintText: hintTaxrate,
              floatingLabelBehavior: FloatingLabelBehavior.always,
              suffixIcon: const CustomSurffixIcon(svgIcon: "assets/icons/Cash.svg"),
            ),
          ),
      ),
    );
  }

  Container buildProdPricesellFormField() {
    return Container(
      height: defTxtInpHeight,
      width: defTxtInpWidth,
      color: Colors.white,
      padding: EdgeInsets.all(defTxtInpEdge),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: defTxtInpMaxHeight,
          maxWidth: defTxtInpMaxWidth,
        ),
        child: TextFormField(
            controller: prodsellCtler,
            keyboardType: TextInputType.number,
            onSaved: (newValue) => prodpricesell = newValue!,
            onChanged: (value) {
              if (value.isNotEmpty) {
                removeError(error: kProdSellNullErr);
                prodpricesell = value;
              }
              return;
            },
            validator: (value) {
              if (value!.isEmpty) {
                addError(error: kProdSellNullErr);
                return "";
              }
              return null;
            },
            decoration: InputDecoration(counterText: ' ', counterStyle: const TextStyle(fontSize: 0), helperStyle: const TextStyle(fontSize: 0), errorStyle: const TextStyle(fontSize: 0),
              labelText: lblPrice,
              hintText: hintPrice,
              floatingLabelBehavior: FloatingLabelBehavior.always,
              suffixIcon: const CustomSurffixIcon(svgIcon: "assets/icons/Cash.svg"),
            ),
          ),
      ),
    );
  }


  Container buildProdPricebuyFormField() {
    return Container(
      height: defTxtInpHeight,
      width: defTxtInpWidth,
      color: Colors.white,
      padding: EdgeInsets.all(defTxtInpEdge),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: defTxtInpMaxHeight,
          maxWidth: defTxtInpMaxWidth,
        ),
        child: TextFormField(
            controller: prodbuyCtler,
            keyboardType: TextInputType.number,
            onSaved: (newValue) => prodpricebuy = newValue!,
            onChanged: (value) {
              if (value.isNotEmpty) {
                removeError(error: kProdBuyNullErr);
                prodpricebuy = value;
              }
              return;
            },
            validator: (value) {
              if (value!.isEmpty) {
                addError(error: kProdBuyNullErr);
                return "";
              }
              return null;
            },
            decoration: InputDecoration(counterText: ' ', counterStyle: const TextStyle(fontSize: 0), helperStyle: const TextStyle(fontSize: 0), errorStyle: const TextStyle(fontSize: 0),
              labelText: lblBuyPrice,
              hintText: hintBuyPrice,
              floatingLabelBehavior: FloatingLabelBehavior.always,
              suffixIcon: const CustomSurffixIcon(svgIcon: "assets/icons/Cash.svg"),
            ),
          ),
      ),
    );
  }










}

