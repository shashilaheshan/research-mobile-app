import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mobile_app/models/_model.offer.dart';
import 'package:mobile_app/services/_location.service.dart';
import 'package:mobile_app/utils/_app.constants.dart';
import 'package:geolocator/geolocator.dart';

import '_offer.screen.dart';
import 'dart:ui' as ui;
import 'package:flutter/services.dart' show rootBundle;
class MapSample extends StatefulWidget {
  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  Completer<GoogleMapController> _controller = Completer();
  GoogleMapController mapController;
  Set<Marker> markers = Set();
  Position _currentPosition;
  String _currentAddress;
  String lat = '';
  double lati, longi;
  CameraPosition _kLake = null;
  BitmapDescriptor pinLocationIcon;
  String _mapStyle;
  final Geolocator _geolocator = Geolocator()..forceAndroidLocationManager;
  LocationOptions locationOptions =
      LocationOptions(accuracy: LocationAccuracy.high, distanceFilter: 1);
  @override
  void initState() {
    super.initState();
    getCurrentLocation();
    initializeMarkers();
    setCustomMapPin();
    //updateLocation();
    checkPermission();
    rootBundle.loadString('lib/assets/map_style.txt').then((string) {
      _mapStyle = string;
    });
    //_getCurrentLocation();
  }

  void checkPermission() {
    _geolocator.checkGeolocationPermissionStatus().then((status) {
      print('status: $status');
    });
    _geolocator
        .checkGeolocationPermissionStatus(
            locationPermission: GeolocationPermission.locationAlways)
        .then((status) {
      print('always status: $status');
    });
    _geolocator.checkGeolocationPermissionStatus(
        locationPermission: GeolocationPermission.locationWhenInUse)
      ..then((status) {
        print('whenInUse status: $status');
      });
  }

  void getCurrentLocation() async {
    StreamSubscription positionStream = _geolocator
        .getPositionStream(locationOptions)
        .listen((Position position) {
      _currentPosition = position;
      setState(() {
        lat = _currentPosition.latitude.toString();
        lati = _currentPosition.latitude;
        longi = _currentPosition.longitude;
      });

      _kLake = CameraPosition(
          bearing: 192.8334901395799,
          target: LatLng(lati, longi),
          tilt: 59.440717697143555,
          zoom: 17.151926040649414);
      //  sleep(new Duration(seconds: 3));
      _goToTheLake();
      setMarkers(_currentPosition.latitude, _currentPosition.longitude);
      print(_currentPosition);
    });
  }
  void updateLocation() async {
    try {
      Position newPosition = await Geolocator()
          .getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
          .timeout(new Duration(seconds: 5));
      print(newPosition);
      setState(() {
        _currentPosition = newPosition;
      });
    } catch (e) {
      print('Error: ${e.toString()}');
    }
  }

  // _getCurrentLocation() {
  //   _geolocator
  //       .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
  //       .then((Position position) {
  //     setState(() {
  //       _currentPosition = position;
  //     });
  //     _getAddressFromLatLng();
  //   }).catchError((e) {
  //     print(e);
  //   });
  // }

  setCustomMapPin() async {
    var lo = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 2.5),
        'lib/assets/destination_map_marker.png');
    setState(() {
      pinLocationIcon = lo;
    });
  }

  _getAddressFromLatLng() async {
    try {
      List<Placemark> p = await _geolocator.placemarkFromCoordinates(
          _currentPosition.latitude, _currentPosition.longitude);
      Placemark place = p[0];
      setState(() {
        _currentAddress =
            "${place.locality}, ${place.postalCode}, ${place.country}";
      });
      print(_currentAddress);
    } catch (e) {
      print(e);
    }
  }
  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(), targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png)).buffer.asUint8List();
  }


  void initializeMarkers() async {}
  void setMarkers(double lat, double lng) async {
    //var notes = await db.getAllNotes();

    final Uint8List markerIcon = await getBytesFromAsset('lib/assets/shop.png', 100);
    //final Marker marker = Marker(icon:);

    //final bitmapIcon = await BitmapDescriptor.fromAssetImage(ImageConfiguration(size: Size(10,10)), 'lib/assets/shop.png');

    var locations = [
      [lat - 0.00098, lng - 0.00017,"ZigZag",["50% Off","Baby Items Offers","Adult Items Offers"],Colors.orange,'card_one'],
      [lat - 0.0004, lng - 0.00087,"Embark",["50% Off","Baby Items Offers","Adult Items Offers"],Colors.indigo,'card_one'],
      [lat - 0.0009, lng - 0.00076,"ODel",["50% Off","Baby Items Offers","Adult Items Offers"],Colors.deepPurpleAccent,'card_one'],
      [lat - 0.0001, lng - 0.000313,"Life Mobile",["20% Off","iphone 12 Off","Samsung s9 Off"],Colors.yellow,'mobile'],
      [lat - 0.00056, lng - 0.00098,"Kings Mobile",["20% Off","iphone 12 Off","Samsung s9 Off"],Colors.purple,'mobile'],
      [lat - 0.00032, lng - 0.000143,"Narayan",["10% Off","Biriyani offer","Pizza 1 free"],Colors.red,'food'],
      [lat - 0.00014, lng - 0.000165,"Wills",["70% Off","Baby Items Offers","Chrismas offer"],Colors.green,'shop'],
      [lat + 0.00014, lng + 0.000165,"Orayen",["10% Off","Biriyani offer","Pizza 1 free"],Colors.orange,'food'],
      [lat + 0.00034, lng + 0.00015,"Kid Toy",["13% Off on all toys","Baby Items Offers"],Colors.blueGrey,'toy'],
      [lat + 0.00098, lng + 0.00017,"Nebula",["10% Off","Fried Rice offer"],Colors.purpleAccent,'food'],
    ];
    Set<Marker> _marker = Set();

    List<Marker> _markers = locations.map((n) {
      LatLng point = LatLng(n[0], n[1]);
      var offer = Offer(n[2],n[3],20.0,'2020-12-09',n[5],n[0],n[1]);

      return Marker(
          onTap: () {
                _settingModalBottomSheet(offer,context,n[4]);
              },
          icon:  BitmapDescriptor.fromBytes(markerIcon),
          markerId: MarkerId(point.latitude.toString()),
          position: LatLng(point.latitude, point.longitude));
    }).toList();
    _marker.addAll(_markers);
    // _marker.addAll([
    //   Marker(
    //       onTap: () {
    //         _settingModalBottomSheet(context);
    //       },
    //       markerId: MarkerId('value'),
    //       position: _currentPosition != null
    //           ? LatLng(_currentPosition.latitude, _currentPosition.longitude)
    //           : LatLng(lat, lng)),
    //   Marker(
    //       onTap: () {
    //         _settingModalBottomSheet(context);
    //       },
    //       markerId: MarkerId('value'),
    //       position: _currentPosition != null
    //           ? LatLng(_currentPosition.latitude + 0.005,
    //               _currentPosition.longitude + 0.005)
    //           : LatLng(lat + 0.05, lng + 0.05)),
    // ]);

    setState(() {
      markers.clear();
      markers = _marker;
    });
  }

  // static final CameraPosition _kGooglePlex =

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("E F F  A D D S"),
        actions: [IconButton(icon: Icon(Icons.notifications_none))],
      ),
      body: SafeArea(
        child: GoogleMap(
          myLocationButtonEnabled: true,
          myLocationEnabled: true,
          mapType: MapType.terrain,
          initialCameraPosition: CameraPosition(
            target: LatLng(6.4, 79.56),
            zoom: 9.4746,
          ),
          onMapCreated: (GoogleMapController controller) {

            controller.setMapStyle(_mapStyle);
            _controller.complete(controller);
          },
          markers: markers,
        ),
      ),
      // floatingActionButton: FloatingActionButton.extended(
      //   onPressed: () {
      //     //  _goToTheLake();
      //   },
      //   label: Text(lat),
      //   icon: Icon(Icons.directions_boat),
      // ),
    );
  }

  Future<void> _goToTheLake() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
  }
}

void _settingModalBottomSheet(Offer offer , context,Color colors) {
  showModalBottomSheet(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      context: context,
      builder: (BuildContext bc) {
        return Container(
          child: new Wrap(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 15.0),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Center(
                        child: Text(
                          offer.name,
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                      ),
                     RaisedButton(
                       onPressed: (){

                     },child: Text("Subscribe"),),

                    ],
                  ),
                ),
              ),
              Container(
                height: 200,
                width: double.infinity,
                color: Colors.transparent,
                child: ListView.separated(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.all(8),
                  itemCount: offer.desc.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Hero(
                      tag: 'image_1',
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10.0),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Material(
                            color: Colors.transparent,
                            elevation: 10,
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => OfferScreen(colors,offer,index,offer.desc[index],offer.lat,offer.lng)),
                                );
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.centerRight,
                                    colors: <Color>[
                                      colors.withOpacity(0.8),
                                      colors.withOpacity(0.9),
                                    ],
                                  ),
                                ),
                                height: 80.0,
                                width: 250,
                                child: Stack(
                                  children: [
                                    Positioned(
                                      top: 20,
                                      left: -10,
                                      child: Image.asset(
                                        'lib/assets/'+offer.icon+'.png',
                                        width: 120,
                                        height: 120,
                                      ),
                                    ),
                                    Positioned(
                                        top: 90,
                                        right: 15,
                                        child: Column(
                                          children: [
                                            Text(offer.validity+ " Day Offer",style: TextStyle(color: Colors.white),),
                                            Chip(
                                                backgroundColor: Colors.purple,
                                                shadowColor: Colors.redAccent,
                                                label: Text(
                                                 offer.desc[index],
                                                  style: TextStyle(
                                                      fontSize: 13,
                                                      fontWeight: FontWeight.bold,
                                                      color: Colors.white),
                                                )),
                                          ],
                                        ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) =>
                      const Divider(),
                ),
              ),
            ],
          ),
        );
      });
}
