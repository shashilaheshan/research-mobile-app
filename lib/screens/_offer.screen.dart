import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mobile_app/models/_model.offer.dart';

class OfferScreen extends StatefulWidget {
  int ind;
  Offer offer;
  Color color;
  String desc;
  double lat,lng;
  OfferScreen(this.color,this.offer,this.ind,this.desc,this.lat,this.lng);

  @override
  _OfferScreenState createState() => _OfferScreenState();
}

class _OfferScreenState extends State<OfferScreen> {
  Completer<GoogleMapController> _controller = Completer();
  Set<Marker> _marker = Set();
  Set<Marker> markers = Set();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();


    _marker.addAll([
      Marker(

          markerId: MarkerId('value'),
          position:
               LatLng(widget.offer.lat, widget.offer.lng)),
    ]);

    setState(() {
      markers.clear();
      markers = _marker;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor:widget.color,
        elevation: 0,
        centerTitle:true ,
        title: Text(widget.offer.name),

      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration:BoxDecoration(

          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.centerRight,
            colors: <Color>[

            widget.color.withOpacity(0.8),
             widget.color.withOpacity(0.9),
            ],
          ),
        ) ,
        child:Container(

          child: Column(
            children: [
              Image.asset('lib/assets/'+widget.offer.icon+'.png',width: 100,height: 100,),
              Column(
                children: [

                  Container(
                    width: double.infinity,
                    height: 200,
                    child: GoogleMap(
                      myLocationButtonEnabled: true,
                      myLocationEnabled: true,
                      mapType: MapType.terrain,
                      initialCameraPosition: CameraPosition(
                        target: LatLng(widget.lat, widget.lng),
                        zoom: 9.4746,
                      ),
                      onMapCreated: (GoogleMapController controller) {
                        _controller.complete(controller);
                      },
                      markers: markers ,
                    ),
                  ),
                  SizedBox(height: 100,),
                  Text("Offer Details",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white),),
                  Text(widget.offer.validity+ " Day Offer",style: TextStyle(color: Colors.white),),
                  Chip(
                      backgroundColor: Colors.purple,
                      shadowColor: Colors.redAccent,
                      label: Text(
                        widget.desc,
                        style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      )),
                ],
              ),
            ],
          ),
        ),
        ),

    );
  }
}
