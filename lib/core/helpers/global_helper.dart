
import 'package:flutter/material.dart';

class GlobalHelper{


  void progressDialog(BuildContext context, String title, String msg) {
    showDialog(
      context: context,
      barrierDismissible: false, // Prevents dismissing the dialog by tapping outside
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12), // Rounded corners
        ),
        child: Padding(
          padding: const EdgeInsets.all(24.0), // Add padding to the dialog
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Title
              Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent,
                ),
              ),
              SizedBox(height: 16), // Space between title and progress indicator
              // Progress Indicator and message
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    strokeWidth: 4,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.blueAccent),
                  ),
                  SizedBox(width: 20), // Space between the indicator and the message
                  Text(
                    msg,
                    style: TextStyle(fontSize: 16, color: Colors.black87),
                  ),
                ],
              ),
              SizedBox(height: 16), // Space after the message
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
          content: Text('Do you really want to delete this $item?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                onDelete();
                Navigator.of(context).pop();
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

}