// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'device_profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DeviceProfile _$DeviceProfileFromJson(Map<String, dynamic> json) {
  return DeviceProfile(
    name: json['name'] as String?,
    systemName: json['systemName'] as String?,
    systemVersion: json['systemVersion'] as String?,
    iOSModel: json['iOSModel'] as String?,
    localizedModel: json['localizedModel'] as String?,
    identifierForVendor: json['identifierForVendor'] as String?,
    iOSiSPhysicalDevice: json['iOSiSPhysicalDevice'] as String?,
    utsNameSysName: json['utsNameSysName'] as String?,
    utsNameRelease: json['utsNameRelease'] as String?,
    utsNameVersion: json['utsNameVersion'] as String?,
    utsNameMachine: json['utsNameMachine'] as String?,
    securityPatchVersion: json['securityPatchVersion'] as String?,
    sdkIntVersion: json['sdkIntVersion'] as String?,
    releaseVersion: json['releaseVersion'] as String?,
    previewSdkIntVersion: json['previewSdkIntVersion'] as String?,
    incrementalVersion: json['incrementalVersion'] as String?,
    codenameVersion: json['codenameVersion'] as String?,
    baseOSVersion: json['baseOSVersion'] as String?,
    board: json['board'] as String?,
    bootloader: json['bootloader'] as String?,
    brand: json['brand'] as String?,
    device: json['device'] as String?,
    display: json['display'] as String?,
    fingerprint: json['fingerprint'] as String?,
    hardware: json['hardware'] as String?,
    host: json['host'] as String?,
    id: json['id'] as String?,
    manufacturer: json['manufacturer'] as String?,
    model: json['model'] as String?,
    product: json['product'] as String?,
    supported32BitAbis: json['supported32BitAbis'] as String?,
    supported64BitAbis: json['supported64BitAbis'] as String?,
    supportedAbis: json['supportedAbis'] as String?,
    tags: json['tags'] as String?,
    type: json['type'] as String?,
    isPhysicalDevice: json['isPhysicalDevice'] as String?,
    androidId: json['androidId'] as String?,
    systemFeatures: json['systemFeatures'] as String?,
  );
}

Map<String, dynamic> _$DeviceProfileToJson(DeviceProfile instance) =>
    <String, dynamic>{
      'securityPatchVersion': instance.securityPatchVersion,
      'sdkIntVersion': instance.sdkIntVersion,
      'releaseVersion': instance.releaseVersion,
      'previewSdkIntVersion': instance.previewSdkIntVersion,
      'incrementalVersion': instance.incrementalVersion,
      'codenameVersion': instance.codenameVersion,
      'baseOSVersion': instance.baseOSVersion,
      'board': instance.board,
      'bootloader': instance.bootloader,
      'brand': instance.brand,
      'device': instance.device,
      'display': instance.display,
      'fingerprint': instance.fingerprint,
      'hardware': instance.hardware,
      'host': instance.host,
      'id': instance.id,
      'manufacturer': instance.manufacturer,
      'model': instance.model,
      'product': instance.product,
      'supported32BitAbis': instance.supported32BitAbis,
      'supported64BitAbis': instance.supported64BitAbis,
      'supportedAbis': instance.supportedAbis,
      'tags': instance.tags,
      'type': instance.type,
      'isPhysicalDevice': instance.isPhysicalDevice,
      'androidId': instance.androidId,
      'systemFeatures': instance.systemFeatures,
      'name': instance.name,
      'systemName': instance.systemName,
      'systemVersion': instance.systemVersion,
      'iOSModel': instance.iOSModel,
      'localizedModel': instance.localizedModel,
      'identifierForVendor': instance.identifierForVendor,
      'iOSiSPhysicalDevice': instance.iOSiSPhysicalDevice,
      'utsNameSysName': instance.utsNameSysName,
      'utsNameRelease': instance.utsNameRelease,
      'utsNameVersion': instance.utsNameVersion,
      'utsNameMachine': instance.utsNameMachine,
    };
