import 'dart:async';

import 'package:beammart/enums/connectivity_status.dart';
import 'package:beammart/providers/auth_provider.dart';
import 'package:beammart/providers/device_info_provider.dart';
import 'package:beammart/providers/device_profile_provider.dart';
import 'package:beammart/providers/location_provider.dart';
import 'package:beammart/screens/home.dart';
import 'package:beammart/services/connectivity_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runZonedGuarded(() {
    runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<DeviceInfoProvider>(
            create: (_) => DeviceInfoProvider(),
          ),
          ChangeNotifierProxyProvider<DeviceInfoProvider,
              DeviceProfileProvider>(
            create: (context) => DeviceProfileProvider(
              Provider.of<DeviceInfoProvider>(context, listen: false)
                  .deviceInfo,
            ),
            update: (context, deviceInfo, deviceProfile) =>
                DeviceProfileProvider(
              Provider.of<DeviceInfoProvider>(context, listen: false)
                  .deviceInfo,
            ),
          ),
          // ChangeNotifierProvider<LocationProvider>(
          //   create: (_) => LocationProvider(),
          // ),
          StreamProvider<LatLng?>(
            create: (_) => LocationProvider().currentLocation,
            initialData: LatLng(1.2921, 36.8219),
          ),
          StreamProvider<ConnectivityStatus?>(
            initialData: ConnectivityStatus.Mobile,
            create: (_) =>
                ConnectivityService().connectivityStatusController.stream,
          ),
          ChangeNotifierProvider<AuthenticationProvider>(
            create: (_) => AuthenticationProvider(FirebaseAuth.instance),
          ),
          StreamProvider<User?>(
            initialData: null,
            create: (context) =>
                context.read<AuthenticationProvider>().authState,
          ),
        ],
        child: App(),
      ),
    );
  }, (dynamic error, dynamic stack) {
    print(error);
    print(stack);
  });
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Home(),
      debugShowCheckedModeBanner: false,
      title: 'Beammart',
      theme: ThemeData(
        primaryColor: Colors.pink,
        accentColor: Colors.purple,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            primary: Colors.pink,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(15),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
