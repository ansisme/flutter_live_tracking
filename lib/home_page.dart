import 'dart:convert';
import 'package:gps/gps.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_form_builder/flutter_form_builder.dart';
// import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:snippet_coder_utils/FormHelper.dart';

// import 'package:flutter_form_builder/form_builder_validators.dart.';
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late IO.Socket socket;
  double? latitude;
  double? longitude;
  static final GlobalKey<FormState> globalKey = GlobalKey<FormState>();
  // final globalKey = GlobalKey<FormState>();

  // get FormBuilderValidators => null;
  @override
  void initState() {
    super.initState();
    initSocket();
  }

  Future<void> initSocket() async {
    try {
      socket = IO.io("http://10.12.23.127:3700", <String, dynamic>{
        'transports': ['websocket'],
        'autoConnect': true,
      });
      socket.connect();
      socket.onConnect((data) => {print('Connect :${socket.id}')});
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    // var FormHelper; //could cause error
    return SafeArea(
        child: Scaffold(
            body: Form(
                key: globalKey,
                child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        // FormHelper.inputFieldWidget(
                        //   context,
                        //   "Latitude",
                        //   "Latitude",
                        //   (onvalidate) {
                        //     if (onvalidate.isEmpty) {
                        //       return '* Required';
                        //     }
                        //     return null;
                        //   },
                        //   (onSaved) {
                        //     latitude = double.parse(onSaved!);
                        //   },
                        //   borderRadius: 10,
                        // ),
                        // const SizedBox(
                        //   height: 10,
                        // ),
                        // FormHelper.inputFieldWidget(
                        //   context,
                        //   "Longitude",
                        //   "Longitude",
                        //   (onvalidate) {
                        //     if (onvalidate.isEmpty) {
                        //       return '* Required';
                        //     }
                        //     return null;
                        //   },
                        //   (onSaved) {
                        //     longitude = double.parse(onSaved!);
                        //   },
                        //   borderRadius: 10,
                        // ),
                        const SizedBox(
                          height: 10,
                        ),
                        FormHelper.submitButton("Send Location", () async {
                          var latlng = await Gps.currentGps();
                          print(latlng.lat);
                          print(latlng.lng);
                          latitude = double.parse(latlng.lat);
                          longitude = double.parse(latlng.lng);
                      
                          if (validateAndSave()) {
                            var coords = {"lat": latitude, "lng": longitude};
                            socket.emit("position-change", jsonEncode(coords));
                          }
                        }),
                      ],
                    )))));
  }

  void disconnect() {
    super.dispose();
  }

  bool validateAndSave() {
    final form = globalKey.currentState;
    if (form!.validate()) {
      form.save();
      return true;
    } else {
      return false;
    }
  }
}
