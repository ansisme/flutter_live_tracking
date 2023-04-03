import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
class LocationMap extends StatefulWidget {
  const LocationMap({super.key});

  @override
  State<LocationMap> createState() => _LocationMapState();
}

class _LocationMapState extends State<LocationMap> {
  late IO.Socket socket ;
  late Map<MarkerId, Marker> _markers;
  Completer<GoogleMapController> _controller = Completer();

  static const CameraPosition _cameraPosition = CameraPosition(target: LatLng(37.42796133580664, -122.085749655962),
  zoom:16 ,);
  @override
  void initState(){
    super.initState();
    _markers= <MarkerI, Marker>
    _markers.clear();
    initSocket();
  }

   Future<void> initSocket() async {
    try {
      socket = IO.io("http://127.0.0.1:3700", <String, dynamic>{
        'transports': ['websocket'],
        'autoConnect': true,
      });
      socket.connect();
      socket.on("position-change",(data) => {
        print('Connect :${socket.id}')
        });
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        initialCmaeraPosition: _cameraPosition,
        mapType: MapType.normal,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
        marker:Set<Marker>.of(_markers.values),
      )
    );
  }
}