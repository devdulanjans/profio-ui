import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';


class PermissionHandler {

  static Future<bool> requestPermissionBrowseFile(BuildContext context) async {
    Permission permission;

    if (Platform.isAndroid) {
// Assume Android 13+ for this example, adjust if needed
      permission = await _getAndroidFilePermission();
    }
    else if (Platform.isIOS) {
      permission = Permission.photos; // or just return true if using FilePicker
    } else {
      return true;
    }

    PermissionStatus status = await permission.status;

    if (status.isGranted) {
      return true;
    }

    if (status.isDenied || status.isRestricted) {
      final result = await permission.request();
      return result.isGranted;
    }

    if (status.isPermanentlyDenied) {
// Show dialog to open app settings
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
// Wait and re-check after returning from settings
        await Future.delayed(const Duration(seconds: 1));
        return await permission.status.isGranted;
      } else {
        return false;
      }
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