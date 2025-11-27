
import 'package:flutter/material.dart';

class GlobalHelper{


  void progressDialog(BuildContext context, String title, String msg) {
    showDialog(
      context: context,
      barrierDismissible: false, // Prevent dismissing by tapping outside
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12), // Rounded corners
        ),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Title
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),

              // Progress Indicator
              const CircularProgressIndicator(
                strokeWidth: 4,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.blueAccent),
              ),
              const SizedBox(height: 24),

              // Message below progress indicator
              Text(
                msg,
                style: const TextStyle(fontSize: 16, color: Colors.black87),
                textAlign: TextAlign.center,
                maxLines: 4,
                overflow: TextOverflow.ellipsis, // Or TextOverflow.fade
              ),
            ],
          ),
        ),
      ),
    );
  }

  void showDeleteConfirmationDialog(BuildContext context,String item, VoidCallback onDelete) {
    showDialog(
      context: context,
      barrierDismissible: false, // Prevent dismissing by tapping outside
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Are you sure?'),
          content: Text('Do you really want to delete this $item?',style: TextStyle(color: Colors.black),),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                onDelete();
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }


  void showConfirmationDialog(BuildContext context,String title,String subTitle,String btn1,String btn2, VoidCallback onDelete) {
    showDialog(
      context: context,
      barrierDismissible: false, // Prevent dismissing by tapping outside
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(subTitle,style: TextStyle(color: Colors.black),),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child:  Text(btn1),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                onDelete();
              },
              child: Text(btn2),
            ),
          ],
        );
      },
    );
  }

}