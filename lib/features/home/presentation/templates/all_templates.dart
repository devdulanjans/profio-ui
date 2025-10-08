import 'package:flutter/material.dart';
import 'package:profio/core/helpers/global_helper.dart';
import 'package:profio/features/services/api_service.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/models/template.dart';
import 'package:cached_network_image/cached_network_image.dart';



class AllTemplatesPage extends StatefulWidget {
  const AllTemplatesPage({super.key});

  @override
  State<AllTemplatesPage> createState() => _AllTemplatesPageState();
}

class _AllTemplatesPageState extends State<AllTemplatesPage> {
  late Future<List<Template>> templatesFuture;



  @override
  void initState() {
    super.initState();
    templatesFuture = getTemplates();

  }

  Future<List<Template>> getTemplates() async {
    List<Template> results = [];
    var allTemplates = await getAllTemplates(1);
    if(allTemplates.isNotEmpty){
      var userTemplates = await getAllTemplates(2);
      if(userTemplates.isNotEmpty){
        results = allTemplates.map((allTemplate) {
          // Find a matching user template based on the id
          var matchingUserTemplate = userTemplates.firstWhere(
                (userTemplate) => userTemplate.id == allTemplate.id,
            orElse: () => Template(), // Return null if no match is found
          );

          // If a match is found, set 'selected' to true
          if (matchingUserTemplate.id != "") {
            allTemplate.isAlreadySelected = true;
          }

          // Return the modified or unchanged allTemplate
          return allTemplate;
        }).toList();
      }
    }



    return results;
  }

  void refreshTemplates() {
    setState(() {
      templatesFuture = getTemplates(); // Call the future again
    });
  }


  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: templatesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('❌ Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No templates available.'));
          }

          final allTemplates = snapshot.data ?? [];



          return ListView.builder(
            itemCount: allTemplates.length,
            itemBuilder: (context, index) {
              // Create Template instance from JSON
              Template template = allTemplates[index];

              // return Dismissible(
              //   key: Key(template.id ?? ''),
              //   direction: DismissDirection.endToStart,
              //   onDismissed: (direction) {
              //     // We won't perform the actual delete here. We will wait for confirmation.
              //    GlobalHelper().showDeleteConfirmationDialog(context, "template", (){
              //
              //    });
              //   },
              //   background: Container(
              //     color: Colors.red,
              //     child: const Align(
              //       alignment: Alignment.centerRight,
              //       child: Padding(
              //         padding: EdgeInsets.all(16.0),
              //         child: Icon(Icons.delete, color: Colors.white),
              //       ),
              //     ),
              //   ),
              //   child: Card(
              //     margin: const EdgeInsets.all(8),
              //     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              //     elevation: 5,
              //     child: Stack(
              //       children: [
              //         // Background image as a full card background
              //         Container(
              //           decoration: BoxDecoration(
              //             borderRadius: BorderRadius.circular(12),
              //             image: DecorationImage(
              //               image: NetworkImage(template.previewImage), // Ensure the URL is valid
              //               fit: BoxFit.cover, // Make sure it covers the whole card
              //             ),
              //           ),
              //           width: double.infinity, // Ensure it spans the entire width of the card
              //           height: 105, // Set the height to 100 as per your requirement
              //         ),
              //         // Content inside the card, overlaying on top of the image
              //         Positioned.fill(
              //           child: Container(
              //             decoration: BoxDecoration(
              //               color: Colors.black.withOpacity(0.5), // Dark overlay for visibility
              //               borderRadius: BorderRadius.circular(12),
              //             ),
              //             padding: const EdgeInsets.all(8), // Reduced padding for smaller card
              //             child: Column(
              //               crossAxisAlignment: CrossAxisAlignment.start,
              //               children: [
              //                 // Title and description
              //                 Text(
              //                   template.name ?? "Template Name", // Use a fallback for null name
              //                   style: const TextStyle(
              //                     fontWeight: FontWeight.bold,
              //                     fontSize: 16, // Smaller font size for title
              //                     color: Colors.white,
              //                   ),
              //                   overflow: TextOverflow.ellipsis,
              //                   maxLines: 1,
              //                 ),
              //                 const SizedBox(height: 4), // Reduced space between title and description
              //                 Text(
              //                   template.description ?? "Template Description", // Use a fallback for null description
              //                   style: const TextStyle(
              //                     color: Colors.white,
              //                     fontSize: 12, // Smaller font size for description
              //                     overflow: TextOverflow.ellipsis,
              //                   ),
              //                   maxLines: 2,
              //                 ),
              //                 Spacer(),
              //                 // Row of action icons (Eye and Checked icons inside circular avatars)
              //                 Row(
              //                   mainAxisAlignment: MainAxisAlignment.end,
              //                   children: [
              //                     // Eye icon for preview inside a circular avatar
              //                     GestureDetector(
              //                       onTap: () {
              //                         _showFullImage(context, template.previewImage);
              //                       },
              //                       child: CircleAvatar(
              //                         radius: 16, // Avatar size
              //                         backgroundColor: Colors.black.withOpacity(0.6),
              //                         child: const Icon(
              //                           Icons.visibility,
              //                           color: Colors.white,
              //                           size: 20, // Icon size inside the avatar
              //                         ),
              //                       ),
              //                     ),
              //                     const SizedBox(width: 8),
              //                     // Checked/Add icon inside a circular avatar
              //                     GestureDetector(
              //                       onTap: () {
              //                       },
              //                       child: CircleAvatar(
              //                         radius: 16, // Avatar size
              //                         backgroundColor: (template.isAlreadySelected ?? false)
              //                             ? Colors.green
              //                             : Colors.blueAccent,
              //                         child: Icon(
              //                           (template.isAlreadySelected ?? false)
              //                               ? Icons.check_circle
              //                               : Icons.add_circle_outline,
              //                           color: Colors.white,
              //                           size: 20, // Icon size inside the avatar
              //                         ),
              //                       ),
              //                     ),
              //                   ],
              //                 ),
              //               ],
              //             ),
              //           ),
              //         ),
              //       ],
              //     ),
              //   ),
              // );
              return Card(
                margin: const EdgeInsets.all(8),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(10),
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      template.previewImage ?? "",  // Image loading as before
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                    ),
                  ),
                  title: Text(
                    template.name ?? "",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    template.description ?? "",
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Eye icon for preview
                      IconButton(
                        icon: const Icon(Icons.visibility, color: Colors.blue),
                        onPressed: () {
                          // Call your method to show full image preview
                          _showFullImage(context, template.previewImage ?? "");
                        },
                      ),
                      // Add/Checked icon based on selection
                      IconButton(
                        icon: (template.isAlreadySelected ?? false)
                            ? const Icon(Icons.check_circle, color: Colors.green)
                            : const Icon(Icons.add_circle_outline, color: Colors.grey),
                        onPressed: () {
                          if(!(template.isAlreadySelected ?? false)){
                            selectTemplate(context,template.id ?? "");
                          }
                        },
                      ),
                    ],
                  ),
                  onTap: () {
                    // Handle tap for any other actions
                  },
                ),
              );
            },
          );
        }
    );
  }

  void selectTemplate(BuildContext context,String templateId) async{

    GlobalHelper().progressDialog(context,"selecting a template.", "Please wait while we process your selection and load the template.");

    var result = await createTemplateForUser(appUserId,templateId);
    Navigator.of(context).pop();
    if(result){
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Template selected successfully.$successIcon")),
      );
      refreshTemplates();
    }
    else{
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Template selected failed.$failedIcon")),
      );
    }

  }

  // Function to show the full-size image
  void _showFullImage(BuildContext context, String imageUrl) {
    showDialog(
      context: context,
      builder: (context) =>
          Dialog(
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).pop(); // Close the dialog when tapped
              },
              child: InteractiveViewer(
                child: Image.network(imageUrl),
              ),
            ),
          ),
    );
  }
}



