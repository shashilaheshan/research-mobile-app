final APP_NAME="EFF ADDS";

class AppConsts {

  var locations;


 static getLocations (double lat, double lng) {
    var locations = [
      [lat - 0.00098, lng - 0.00017],
      [lat - 0.0004, lng - 0.00087],
      [lat - 0.0009, lng - 0.00076],
      [lat - 0.0001, lng - 0.000313],
      [lat - 0.00056, lng - 0.00098],
      [lat - 0.00032, lng - 0.000143],
      [lat - 0.00014, lng - 0.000165],
      [lat + 0.00014, lng + 0.000165],
      [lat + 0.00034, lng + 0.00015],
      [lat + 0.00098, lng + 0.00017],
    ];

    return locations;
  }

}