// import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
// import 'package:flutter/services.dart';
import 'package:slugify/slugify.dart';
import 'package:flutter/material.dart';
import 'package:shopadmin_app/components/custom_surfix_icon.dart';
import 'package:shopadmin_app/components/default_button.dart';
import 'package:shopadmin_app/components/form_error.dart';
import 'package:shopadmin_app/helper/keyboard.dart';
import 'package:shopadmin_app/app_globals.dart';
import 'package:shopadmin_app/constants.dart';
import 'package:shopadmin_app/strconsts.dart';
import 'package:shopadmin_app/screens/category_edit/category_edit_screen.dart';
import 'package:shopadmin_app/size_config.dart';

class CategoryAddForm extends StatefulWidget {

  @override
  _CategoryAddFormState createState() => _CategoryAddFormState();

}

class _CategoryAddFormState extends State<CategoryAddForm> {
  
  final _formKey = GlobalKey<FormState>();

  // int catid = admcurcatid;
  String catname = '';
  String catslug = '';
  String catdesc = '';
  String catsort = '';
  String catactive = '1';
  String poststatus = '';
  final List<String> errors = [];

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
              buildCatNameFormField(),
              SizedBox(height: getProportionateScreenHeight(defFormFieldEdges01)),
              buildCatDescFormField(),
              SizedBox(height: getProportionateScreenHeight(defFormFieldEdges01)),
              buildCatSlugFormField(),
              SizedBox(height: getProportionateScreenHeight(defFormFieldEdges01)),
              buildCatSortFormField(),
              SizedBox(height: getProportionateScreenHeight(defFormFieldEdges01)),
              Text(poststatus, textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15.0)),
              SizedBox(height: getProportionateScreenHeight(defFormFieldEdges01)),
              FormError(errors: errors),
              SizedBox(height: getProportionateScreenHeight(defFormFieldEdges10)),
              DefaultButton(
                text: "Save category",
                press: () {
                  if (_formKey.currentState!.validate()) {
                    categorySaveChanges();
                    
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

  setStatusA(bool newvalue) {
    setState(() {
      curcatactive=newvalue;
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
          title: Text('Active'),
          value: curcatactive,
          onChanged: (value) => setStatusA(value!),
          subtitle: !curcatactive
            ? Padding(
                padding: EdgeInsets.fromLTRB(12.0, 0, 0, 0), 
                child: Text('Check to change to active', style: TextStyle(color: Color(0xFFe53935), fontSize: 12),),)
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

  categorySaveChanges() {
    setStatus(txtSavingCat);
    var postdata = {
        "store_id": "$admcurstoreid",
        "name" : (catname.isNotEmpty) ? '$catname' : '',
        "slug" : (catslug.isNotEmpty) ? '$catslug' : '', 
        "description" : (catdesc.isNotEmpty) ? '$catdesc' : '', 
        "sort" : (catsort.isNotEmpty) ? '$catsort' : '0', 
        "active" : '1', 
      };
    var posthdr = {
        'Accept': 'application/json',
        'Authorization' : 'Bearer $logintoken'
        };
    http.post(categoryaddEndPoint, body: postdata, headers: posthdr ).then((result) {
        if (result.statusCode == 200) {
          var resary = jsonDecode(result.body);
          if (resary['status'] > 0) {
              KeyboardUtil.hideKeyboard(context);
              setStatus(txtStatSaved);
              setState(() {
                Category tmpcat = Category.fromJsonDet(resary['data']);
                admcurcat=[];
                admcurcat.add(tmpcat);
                admcurcatid=admcurcat.first.id;
                curcatactive = true;
              });
              Navigator.pushNamed(context, CategoryEditScreen.routeName);
          } else if (resary['status'] == -1) {
             setStatus(kcatSaveErr);
          } else {
            setStatus(kcatSaveErr);
          }
        } else {
          throw Exception(kcatSaveErr);
        }
    }).catchError((error) {
      setStatus(kcatSaveErr);
      // 
    });
  }

  saveCatName(String newValue) {
    setState(() {
      catname = newValue;
      catslug = slugify(catname);
    });
    catSlugTxtCtrl.text = catslug;
  }

  Container buildCatNameFormField() {
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
            onSaved: (newValue) => saveCatName(newValue!),
            onChanged: (value) {
              if (value.isNotEmpty) {
                removeError(error: kCatNameNullErr);
                saveCatName(value);
              }
              return null;
            },
            validator: (value) {
              if (value!.isEmpty) {
                addError(error: kCatNameNullErr);
                return "";
              }
              return null;
            },
            decoration: InputDecoration(counterText: ' ', counterStyle: TextStyle(fontSize: 0), helperStyle: TextStyle(fontSize: 0), errorStyle: TextStyle(fontSize: 0),
              labelText: lblCatName,
              hintText: hintCatName,
              floatingLabelBehavior: FloatingLabelBehavior.always,
              suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/TextIcon.svg"),
            ),
          ),
      ),
    );
  }

  Container buildCatDescFormField() {
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
          onSaved: (newValue) => catdesc = newValue!,
          onChanged: (value) {
            if (value.isNotEmpty) {
              removeError(error: kCatDescNullErr);
              catdesc = value;
            }
            return null;
          },
          validator: (value) {
            if (value!.isEmpty) {
              addError(error: kCatDescNullErr);
              return "";
            }
            return null;
          },
          decoration: InputDecoration(counterText: ' ', counterStyle: TextStyle(fontSize: 0), helperStyle: TextStyle(fontSize: 0), errorStyle: TextStyle(fontSize: 0),
            labelText: lblCatDesc,
            hintText: hintCatDesc,
            floatingLabelBehavior: FloatingLabelBehavior.always,
            suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/TextIcon.svg"),
          ),
          initialValue: catdesc,
        ),
      ),
    );
  }

  var catSlugTxtCtrl =  TextEditingController();
  Container buildCatSlugFormField() {
    catSlugTxtCtrl.text = slugify(catname);
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
            controller: catSlugTxtCtrl,
            onSaved: (newValue) => catslug = newValue!,
            onChanged: (value) {
              if (value.isNotEmpty) {
                removeError(error: kCatSlugNullErr);
                catslug = value;
              }
              return null;
            },
            validator: (value) {
              if (value!.isEmpty) {
                addError(error: kCatSlugNullErr);
                return "";
              }
              return null;
            },
            decoration: InputDecoration(counterText: ' ', counterStyle: TextStyle(fontSize: 0), helperStyle: TextStyle(fontSize: 0), errorStyle: TextStyle(fontSize: 0),
              labelText: lblCatSlug,
              hintText: hintCatSlug,
              floatingLabelBehavior: FloatingLabelBehavior.always,
              suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/TextIcon.svg"),
            ),
          ),
      ),
    );
  }

  Container buildCatSortFormField() {
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
            onSaved: (newValue) => catsort = newValue!,
            onChanged: (value) {
              if (value.isNotEmpty) {
                removeError(error: kCatSortNullErr);
                catsort = value;
              }
              return null;
            },
            validator: (value) {
              if (value!.isEmpty) {
                addError(error: kCatSortNullErr);
                return "";
              }
              return null;
            },
            decoration: InputDecoration(counterText: ' ', counterStyle: TextStyle(fontSize: 0), helperStyle: TextStyle(fontSize: 0), errorStyle: TextStyle(fontSize: 0),
              labelText: lblCatSort,
              hintText: hintCatSort,
              floatingLabelBehavior: FloatingLabelBehavior.always,
              suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/sort-numeric-down.svg"),
            ),
          ),
      ),
    );
  }
  
}
