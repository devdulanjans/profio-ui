import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../providers/locale_provider.dart';
import 'home_page.dart';

class UserProfilePage extends StatelessWidget {
  UserProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final locale = Provider.of<LocaleProvider>(context);

    final List<Map<String, dynamic>> dynamicCardData = [
      {
        'business_profile': 'business_profile',
        'connections': '120',
        'imageUrl': 'https://randomuser.me/api/portraits/men/11.jpg',
        'name': 'Robert Fox',
        'designation': 'CEO at Orbix Design Studio',
        'isDirect': true,
      },
      {
        'business_profile': 'business_profile',
        'connections': '98',
        'imageUrl': 'https://randomuser.me/api/portraits/women/22.jpg',
        'name': 'Jane Doe',
        'designation': 'Marketing Manager',
        'isDirect': false,
      },
      {
        'business_profile': 'business_profile',
        'connections': '76',
        'imageUrl': 'https://randomuser.me/api/portraits/men/33.jpg',
        'name': 'John Smith',
        'designation': 'Software Engineer',
        'isDirect': true,
      },
    ];
    final List<Map<String, dynamic>> dynamicCardDataNew = [

    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Text("",style: TextStyle(color: Colors.black),),
          SizedBox(
            height: 400,
            width: MediaQuery.of(context).size.width,
            child: dynamicCardDataNew.isNotEmpty ? CardSwiper(
              cardsCount: dynamicCardData.length,

              cardBuilder: (context, index) {

                final cardData = dynamicCardData[index];
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                      color: Colors.grey.shade300, // Choose your border color
                      width: 1.0, // Choose your border width
                    ),
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10, offset: const Offset(0,5))],
                    borderRadius: BorderRadius.circular(16.0), // Optional: if you want rounded corners for the border
                  ),
                  margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0), // Optional: to add some space around each bordered item
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 🔹 FIX: Full width row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            locale.getText(
                                key: cardData['business_profile']),
                            style: const TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                              color: Colors.black54,
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.share, color: Colors.black54),
                            onPressed: () {
                              final cardDetails = "Name: ${cardData['name']}\nDesignation: ${cardData['designation']}\nConnections: ${cardData['connections']}";
                              SharePlus.instance.share(
                                  ShareParams(
                                    title: cardData['name'],
                                    subject: "CALLME - Digital Business Card",
                                    previewThumbnail: XFile(Uri.parse(cardData['imageUrl']).toString()),
                                    text: cardDetails,
                                  )
                              );
                            },
                          ),
                        ],
                      ),

                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 20),
                                CircleAvatar(
                                  radius: 35,
                                  backgroundImage: NetworkImage(cardData['imageUrl']),
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  cardData['name'],
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black54,
                                  ),
                                ),
                                Text(
                                  cardData['designation'],
                                  style: const TextStyle(
                                    color: Colors.black54,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Column(
                            children: [
                              Text(
                                cardData['connections'],
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  color: Colors.black54,
                                ),
                              ),
                              Text(
                                locale.getText(key: 'connected'),
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.black54,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            locale.getText(key: 'your_links'),
                            style: const TextStyle(
                                fontSize: 14,
                                color: Colors.black54,
                            ),
                          ),
                          Row(
                            children: [
                              Text(
                                locale.getText(key: 'direct'),
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.black54,
                                ),
                              ),
                              Switch(
                                value: cardData['isDirect'],
                                onChanged: (val) {
                                  // TODO: update logic
                                },
                                activeColor: Colors.green,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ):Container(
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                  color: Colors.grey.shade300, // Choose your border color
                  width: 1.0, // Choose your border width
                ),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10, offset: const Offset(0,5))],
                borderRadius: BorderRadius.circular(16.0), // Optional: if you want rounded corners for the border
              ),
              margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0), // Optional: to add some space around each bordered item
              padding: const EdgeInsets.all(16),
              child: Center(
                child: Image.asset('assets/no_cards.jpg',),
              ),
            ),
          ),
          // 🔹 Business Profile Cards
          // SizedBox(
          //   height: 320,
          //   // width: MediaQuery.of(context).size.width,
          //   child: ListView.builder(
          //     shrinkWrap: true,
          //     itemCount: dynamicCardData.length,
          //     itemBuilder: (context, index) {
          //       final cardData = dynamicCardData[index];
          //       return Container(
          //         decoration: BoxDecoration(
          //           border: Border.all(
          //             color: Colors.grey.shade300, // Choose your border color
          //             width: 1.0, // Choose your border width
          //           ),
          //           borderRadius: BorderRadius.circular(8.0), // Optional: if you want rounded corners for the border
          //         ),
          //         margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0), // Optional: to add some space around each bordered item
          //         padding: const EdgeInsets.all(16),
          //         child: Column(
          //           crossAxisAlignment: CrossAxisAlignment.start,
          //           children: [
          //             // 🔹 FIX: Full width row
          //             SizedBox(
          //               child: Row(
          //                 children: [
          //                   Text(
          //                     locale.getText(
          //                         key: cardData['business_profile']),
          //                     style: const TextStyle(
          //                       fontWeight: FontWeight.w500,
          //                       fontSize: 14,
          //                       color: Colors.black54,
          //                     ),
          //                   ),
          //                   const Spacer(),
          //                   Column(
          //                     children: [
          //                       Text(
          //                         cardData['connections'],
          //                         style: const TextStyle(
          //                           fontWeight: FontWeight.bold,
          //                           fontSize: 20,
          //                           color: Colors.black54,
          //                         ),
          //                       ),
          //                       Text(
          //                         locale.getText(key: 'connected'),
          //                         style: const TextStyle(
          //                           fontSize: 12,
          //                           color: Colors.black54,
          //                         ),
          //                       ),
          //                     ],
          //                   ),
          //                 ],
          //               ),
          //             ),
          //
          //             const SizedBox(height: 20),
          //             CircleAvatar(
          //               radius: 35,
          //               backgroundImage: NetworkImage(cardData['imageUrl']),
          //             ),
          //             const SizedBox(height: 12),
          //             Text(
          //               cardData['name'],
          //               style: const TextStyle(
          //                 fontSize: 18,
          //                 fontWeight: FontWeight.bold,
          //                 color: Colors.black54,
          //               ),
          //             ),
          //             Text(
          //               cardData['designation'],
          //               style: const TextStyle(
          //                 color: Colors.black54,
          //                 fontSize: 13,
          //               ),
          //             ),
          //             const SizedBox(height: 20),
          //             Row(
          //               children: [
          //                 Text(
          //                   locale.getText(key: 'your_links'),
          //                   style: const TextStyle(
          //                     fontSize: 14,
          //                     color: Colors.black54,
          //                   ),
          //                 ),
          //                 const Spacer(),
          //                 Row(
          //                   children: [
          //                     Text(
          //                       locale.getText(key: 'direct'),
          //                       style: const TextStyle(
          //                         fontSize: 14,
          //                         color: Colors.black,
          //                       ),
          //                     ),
          //                     Switch(
          //                       value: cardData['isDirect'],
          //                       onChanged: (val) {
          //                         // TODO: update logic
          //                       },
          //                       activeColor: Colors.green,
          //                     ),
          //                   ],
          //                 ),
          //               ],
          //             ),
          //           ],
          //         ),
          //       );
          //     },
          //   ),
          // ),

          const SizedBox(height: 20),
          // 🔹 Add New Section
          GestureDetector(
            onTap: (){
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HomePage(parentPageId: 120)),
              );
            },
            child: Container(
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.circular(25), // Adjust the radius as needed
              ),
              padding: EdgeInsets.only(left: 10,right: 10),
              height: 60,
              child: Row(
                children: [
                  Text(
                    locale.getText(key: 'add_new'),
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                  const Spacer(),
                  CircleAvatar(
                    radius: 22,
                    backgroundColor: Colors.grey[200],
                    child: const Icon(Icons.add, color: Colors.black87),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 5),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              locale.getText(key: 'addNewDesc'),
              style: const TextStyle(
                fontSize: 13,
                color: Colors.black54,
              ),
            ),
          ),

          const SizedBox(height: 20),

          // 🔹 Social Links & Recent Connected
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Active Social
              Expanded(
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(Icons.access_time_filled_rounded,
                                color: Colors.red),
                            SizedBox(width: 8),
                            Icon(Icons.snapchat, color: Colors.yellow),
                            SizedBox(width: 8),
                            Icon(Icons.add_chart_sharp, color: Colors.blue),
                            SizedBox(width: 8),
                            Icon(Icons.access_time,
                                color: Colors.blueAccent),
                          ],
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          "05",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 22,
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          locale.getText(key: 'active_social'),
                          style: const TextStyle(
                            fontSize: 13,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 12),

              // Recent Connected
              Expanded(
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          locale.getText(key: 'recentConnected'),
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 10),
                        _buildRecentItem("Bessie", "Los Angeles, CA"),
                        _buildRecentItem("Julie", "Los Angeles, CA"),
                        _buildRecentItem("Regina", "Los Angeles, CA"),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // 🔹 Upgrade Button
          ElevatedButton.icon(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            icon: const Icon(Icons.upgrade, color: Colors.white),
            label: Text(
              locale.getText(key: 'upgrade'),
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Container> cards = [
    Container(
      alignment: Alignment.center,
      child: const Text('1'),
      color: Colors.blue,
    ),
    Container(
      alignment: Alignment.center,
      child: const Text('2'),
      color: Colors.red,
    ),
    Container(
      alignment: Alignment.center,
      child: const Text('3'),
      color: Colors.purple,
    )
  ];

  Widget _buildRecentItem(String name, String location) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 16,
            backgroundImage: NetworkImage(
              "https://randomuser.me/api/portraits/women/44.jpg",
            ),
          ),
          const SizedBox(width: 5),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
              Text(
                location,
                style: const TextStyle(
                  fontSize: 10,
                  color: Colors.black26,
                ),
              ),
            ],
          ),
          const Spacer(),
          const Icon(Icons.more_vert, size: 12),
        ],
      ),
    );
  }
}
