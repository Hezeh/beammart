import 'package:json_annotation/json_annotation.dart';

part 'device_profile.g.dart';

@JsonSerializable()
class DeviceProfile {
  // All
  final String? deviceId;
  // Android Device Info
  final String? securityPatchVersion;
  final String? sdkIntVersion;
  final String? releaseVersion;
  final String? previewSdkIntVersion;
  final String? incrementalVersion;
  final String? codenameVersion;
  final String? baseOSVersion;
  final String? board;
  final String? bootloader;
  final String? brand;
  final String? device;
  final String? display;
  final String? fingerprint;
  final String? hardware;
  final String? host;
  final String? id;
  final String? manufacturer;
  final String? model;
  final String? product;
  final String? supported32BitAbis;
  final String? supported64BitAbis;
  final String? supportedAbis;
  final String? tags;
  final String? type;
  final String? isPhysicalDevice;
  final String? androidId;
  final String? systemFeatures;
  // iOS Device Info;
  final String? name;
  final String? systemName;
  final String? systemVersion;
  final String? iOSModel;
  final String? localizedModel;
  final String? identifierForVendor;
  final String? iOSiSPhysicalDevice;
  final String? utsNameSysName;
  final String? utsNameRelease;
  final String? utsNameVersion;
  final String? utsNameMachine;

  DeviceProfile({
    this.deviceId,
    this.name,
    this.systemName,
    this.systemVersion,
    this.iOSModel,
    this.localizedModel,
    this.identifierForVendor,
    this.iOSiSPhysicalDevice,
    this.utsNameSysName,
    this.utsNameRelease,
    this.utsNameVersion,
    this.utsNameMachine,
    this.securityPatchVersion,
    this.sdkIntVersion,
    this.releaseVersion,
    this.previewSdkIntVersion,
    this.incrementalVersion,
    this.codenameVersion,
    this.baseOSVersion,
    this.board,
    this.bootloader,
    this.brand,
    this.device,
    this.display,
    this.fingerprint,
    this.hardware,
    this.host,
    this.id,
    this.manufacturer,
    this.model,
    this.product,
    this.supported32BitAbis,
    this.supported64BitAbis,
    this.supportedAbis,
    this.tags,
    this.type,
    this.isPhysicalDevice,
    this.androidId,
    this.systemFeatures,
  });

  factory DeviceProfile.fromJson(Map<String, dynamic> json) =>
      _$DeviceProfileFromJson(json);

  Map<String, dynamic> toJson() => _$DeviceProfileToJson(this);
}
