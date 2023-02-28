import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
// import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shopadmin_app/screens/product_list/product_list_screen.dart';
import 'package:slugify/slugify.dart';
import 'package:flutter/material.dart';
import 'package:shopadmin_app/components/custom_surfix_icon.dart';
import 'package:shopadmin_app/components/default_button.dart';
import 'package:shopadmin_app/components/form_error.dart';
import 'package:shopadmin_app/helper/keyboard.dart';
import 'package:shopadmin_app/app_globals.dart';
import 'package:shopadmin_app/constants.dart';
import 'package:shopadmin_app/strconsts.dart';
import 'package:shopadmin_app/size_config.dart';

class ProductAddForm extends StatefulWidget {
  const ProductAddForm({Key? key}) : super(key: key);

  @override
  _ProductAddFormState createState() => _ProductAddFormState();
}

class _ProductAddFormState extends State<ProductAddForm> {
  final _formKey = GlobalKey<FormState>();

  // int id = admcurprod['id'];
  int storeid = (admcurstore.isNotEmpty)? admcurstore.first.id : 0 ;
  String storename = (admcurstore.isNotEmpty)? admcurstore.first.storename : "";
  int catid = (admcurcat.isNotEmpty)? admcurcat.first.id : 0;
  String catname = (admcurcat.isNotEmpty)? admcurcat.first.catname : "";
  String prodname = '';
  String prodslug = '';
  String proddesc = '';
  String prodsort = '0';
  String prodtaxrate = '7.5';
  String prodpricesell = '0';
  String prodpricebuy = '0';
  String prodactive = '1';
  String poststatus = '';
  final List<String> errors = [];

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

  @override
  Widget build(BuildContext context) {
    gtextTranslate(context);
    return Container(
      width: defInpFormWidth,
      color: Colors.white,
      padding: EdgeInsets.all(defTxtInpEdge),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: defInpFormMaxWidth,
        ),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
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
              SizedBox(height: getProportionateScreenHeight(defFormFieldEdges01)),
              Text(poststatus, textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 15.0)),
              SizedBox(height: getProportionateScreenHeight(defFormFieldEdges10)),
              FormError(errors: errors),
              SizedBox(height: getProportionateScreenHeight(defFormFieldEdges10)),
              DefaultButton(
                text: lblSaveItem,
                press: () {
                  if (_formKey.currentState!.validate()) {
                    productSaveChanges();
                  }
                },
              ),
              SizedBox(height: getProportionateScreenHeight(defFormFieldEdges30)),
            ],
          ),
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
        "store_id" : (admcurstore.isNotEmpty)? "${admcurstore.first.id}" : "0", 
        "store_name" : (admcurstore.isNotEmpty)? admcurstore.first.storename : '', 
        "cat_id" : (admcurcatid>0) ? '$admcurcatid' : '', 
        "cat_name" : (admcurcat.isNotEmpty) ? admcurcat.first.catname : '', 
        "name" : (prodname.isNotEmpty) ? prodname : '',
        "slug" : (prodslug.isNotEmpty) ? prodslug : '', 
        "description" : (proddesc.isNotEmpty) ? proddesc : '', 
        "sort" : (prodsort.isNotEmpty) ? prodsort : '', 
        "active" : '1', 
        "taxrate" : (prodtaxrate.isNotEmpty) ? prodtaxrate : '', 
        "pricesell" : (prodpricesell.isNotEmpty) ? prodpricesell : '', 
        "pricebuy" : (prodpricebuy.isNotEmpty) ? prodpricebuy : '', 
        "suppl_id" : '0',
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
    http.post(productaddEndPoint, body: postdata, headers: posthdr ).then((result) {
        if (result.statusCode == 200) {
          var resary = jsonDecode(result.body);
          if (resary['status'] > 0) {
              setState(() {
                Product tmpprod = Product.fromJsonDet(resary['data']);
                admcurprod=[];
                admcurprod.add(tmpprod);
                admcurprodid=admcurprod.first.id;
                curprodactive = (admcurprod.first.prodactive > 0);
                allstrprods.add(tmpprod);
                allstrprods.sort((a, b) => a.prodsort.compareTo(b.prodsort));
                Navigator.pushNamed(context, ProductListScreen.routeName);
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
            initialValue: prodname,
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
          initialValue: proddesc,
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
            
            initialValue: prodsort,
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
            
            initialValue: prodtaxrate,
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
            
            initialValue: prodpricesell,
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
            
            initialValue: prodpricebuy,
          ),
      ),
    );
  }




  
}
