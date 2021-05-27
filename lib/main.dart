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
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();

  print("Handling a background message: ${message.messageId}");
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
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
          StreamProvider<LatLng?>(
            create: (_) => LocationProvider().currentLocation,
            // initialData: LatLng(-1.3032051, 36.707307),
            initialData: null,
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

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  initState() {
    super.initState();
  }

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
