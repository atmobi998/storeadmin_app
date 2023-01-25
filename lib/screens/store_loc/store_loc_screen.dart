import 'dart:async';
import 'package:flutter/material.dart';
// import 'package:google_maps_flutter_platform_interface/google_maps_flutter_platform_interface.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shopadmin_app/screens/store_edit/store_edit_screen.dart';
import 'package:shopadmin_app/screens/store_loc/components/bottom_nav_bar_store_loc.dart';
import 'package:shopadmin_app/enums.dart';
import 'package:shopadmin_app/strconsts.dart';
import 'package:shopadmin_app/app_globals.dart';


class StoreLocationScreen extends StatefulWidget {

  static String routeName = "/store_loc";
  @override
  State<StoreLocationScreen> createState() => StoreLocationScreenState();

}

class StoreLocationScreenState extends State<StoreLocationScreen> {

  Completer<GoogleMapController> _controller = Completer();

  @override
  Widget build(BuildContext context) {
    gtextTranslate(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(txtStoreLocTitle),
        automaticallyImplyLeading: false,
      ),
      body: GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: storecamerapos,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
          _getLocation();
        },
        myLocationEnabled: true,
        compassEnabled: true,
        myLocationButtonEnabled: true,
        zoomGesturesEnabled: true,
        markers: _markers.values.toSet(),
        onTap: (taplatlong){
            setState(() {
              curlatlng = taplatlong;
              newlatlng = taplatlong;
            });
            _getLocation();
            movetoNew(newlatlng);
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _useNewPosition,
        tooltip: txtGetLoc,
        child: Icon(Icons.flag),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      bottomNavigationBar: BottomNavBarStoreLocation(selectedMenu: StoreMenuState.none),
    );
  }

  final Map<String, Marker> _markers = {};

  void _useNewPosition() {
    setState(() {
      curlatlng = LatLng(_markers[txtStoreLocName]!.position.latitude,_markers[txtStoreLocName]!.position.longitude);
      storecamerapos = CameraPosition(target: newlatlng ,zoom: 14,);
    });
    Navigator.pushNamed(context, StoreEditScreen.routeName);
  }

  movetoNew(destination) {
    setState(() {
      newlatlng  = destination;
    });
    Future.delayed(Duration(seconds: 2), () async {
      GoogleMapController controller = await _controller.future;
      controller.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: destination,
            zoom: 15.0,
          ),
        ),
      );
    });
  }

  void _getLocation() async {
    var tmpmkrlatlng = (curlatlng.toString() != 'LatLng(0.0, 0.0)')? LatLng(curlatlng.latitude, curlatlng.longitude) : curusrpos ;
      setState(() {
        _markers.clear();
        final marker = Marker(
            onTap: () {
              
            },
            draggable: true,
            markerId: MarkerId("curr_loc"),
            position: tmpmkrlatlng,
            infoWindow: InfoWindow(title: txtStoreLoc),
            onDragEnd: ((newPosition) {
              movetoNew(newPosition);
            })
        );
        _markers[txtStoreLocName] = marker;
      });

      Future.delayed(Duration(seconds: 2), () async {
        GoogleMapController controller = await _controller.future;
        controller.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              target: tmpmkrlatlng,
              zoom: 15.0,
            ),
          ),
        );
      });
      
  }

}
