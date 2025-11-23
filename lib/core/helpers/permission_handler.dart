import 'dart:developer';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';


class PermissionHandler {

  static Future<bool> requestPermissionBrowseFile(BuildContext context) async {
    if (Platform.isIOS) {
      // iOS: image_picker handles permission automatically
      return true;
    }

    // ANDROID
    Permission permission = await _getAndroidFilePermission();
    PermissionStatus status = await permission.status;
    log("Android Permission Status: $status");

    if (status.isGranted) return true;

    if (status.isDenied || status.isRestricted) {
      final result = await permission.request();
      log("Android Permission Request Result: $result");
      if (result.isGranted) return true;
    }

    if (status.isPermanentlyDenied) {
      final openSettings = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Permission Required'),
          content: const Text(
            'You have permanently denied access. Please enable permission in app settings.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Open Settings'),
            ),
          ],
        ),
      );

      if (openSettings == true) {
        await openAppSettings();
        await Future.delayed(const Duration(seconds: 1));
        status = await permission.status;
        return status.isGranted;
      }
      return false;
    }

    return false;
  }


  static Future<Permission> _getAndroidFilePermission() async {
    if (Platform.isAndroid) {
      // This assumes Android 13+ (API 33)
      return Permission.photos; // or Permission.mediaLibrary if needed
    }
    return Permission.storage;
  }

}