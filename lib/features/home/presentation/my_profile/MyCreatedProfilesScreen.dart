import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

class MyCreatedProfilesScreen extends StatelessWidget {

  final List<Map<String, dynamic>> dataSet = [
    {
      'icons':Icon(Icons.phone,color: Colors.white),
      'mainText':"Phone",
      'subText':"0774256461",
    },
    {
      'icons':Icon(Icons.message,color: Colors.white),
      'mainText':"WhatsApp",
      'subText':"0774256461",
    },
    {
      'icons':Icon(Icons.email,color: Colors.white),
      'mainText':"Emal",
      'subText':"dulanjansej@gmail.com",
    },
    {
      'icons':Icon(Icons.contact_mail,color: Colors.white),
      'mainText':"Office",
      'subText':"01125678789",
    }
  ];

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

  final List<Map<String,dynamic>> socialLinks = [
    {
      'icon':Icon(Icons.facebook),
      'link':"www.facebook.com"
    },
    {
      'icon':Icon(Icons.account_circle),
      'link':"www.facebook.com"
    },
    {
      'icon':Icon(Icons.access_time),
      'link':"www.facebook.com"
    },
    {
      'icon':Icon(Icons.add_chart),
      'link':"www.facebook.com"
    },
  ];

  @override
  Widget build(BuildContext context) {
    // return ListView.builder(
    //   itemCount: profiles.length,
    //   itemBuilder: (context, index) {
    //     final profile = profiles[index];
    //     return Card(
    //       margin: const EdgeInsets.all(8.0),
    //       child: ListTile(
    //         leading: CircleAvatar(
    //           backgroundImage: NetworkImage(profile['imageUrl']!),
    //         ),
    //         title: Text(profile['name']!),
    //         subtitle: Text(profile['designation']!),
    //         trailing: IconButton(
    //           icon: const Icon(Icons.share),
    //           onPressed: () {
    //             Share.share(profile['details']!);
    //           },
    //         ),
    //       ),
    //     );
    //   },
    // );
    return ListView.builder(
      itemCount: dynamicCardData.length,
      itemBuilder: (context, index) {
        final plan = dynamicCardData[index];
        return Container(
          margin: const EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: plan['isDirect'] == true
                ? const LinearGradient(
              colors: [Colors.white70, Colors.white70],
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
            )
                : const LinearGradient(
              colors: [ Colors.greenAccent,Colors.green],
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
            ),
            boxShadow: const [
              BoxShadow(color: Colors.black26, blurRadius: 3, offset: Offset(0, 2)),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          color: plan['isDirect'] == false?Colors.black:Colors.green,
                      ),
                      height: 70,
                      width: 70,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.qr_code,color: Colors.white,),
                          SizedBox(height: 5,),
                          Text("QR Scan",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w700),)
                        ],
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          color: plan['isDirect'] == false?Colors.black:Colors.green,
                      ),
                      height: 70,
                      width: 70,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.share,color: Colors.white,),
                          SizedBox(height: 5,),
                          Text("Share",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w700),)
                        ],
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          color: plan['isDirect'] == false?Colors.black:Colors.green,
                      ),
                      height: 70,
                      width: 70,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.wallet_giftcard,color: Colors.white,),
                          SizedBox(height: 5,),
                          Text("Wallet",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w700),)
                        ],
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          color: plan['isDirect'] == false?Colors.black:Colors.green,
                      ),
                      height: 70,
                      width: 70,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.edit_calendar_outlined,color: Colors.white,),
                          SizedBox(height: 5,),
                          Text("Edit",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w700),)
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Center(
                  child: CircleAvatar(
                    minRadius: 40,
                    backgroundImage: AssetImage('assets/log.png'),
                  ),
                ),
                Center(
                  child: Text(
                    plan['name'],
                    style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: plan['isDirect'] == true ? Colors.black : Colors.white
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                // ElevatedButton(
                //   onPressed: () {
                //     // Handle plan selection logic
                //     ScaffoldMessenger.of(context).showSnackBar(
                //       SnackBar(content: Text('${plan['designation']} plan selected!')),
                //     );
                //   },
                //   style: ElevatedButton.styleFrom(
                //     minimumSize: const Size(double.infinity, 45),
                //     shape: RoundedRectangleBorder(
                //       borderRadius: BorderRadius.circular(10),
                //     ),
                //   ),
                //   child: Text('Choose ${plan['name']} Plan'),
                // ),
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: dataSet.length,
                  itemBuilder: (context, featureIndex) {
                    return Container(
                      margin: EdgeInsets.only(bottom: 5),
                      decoration: BoxDecoration(
                        color: plan['isDirect'] == false?Colors.black:Colors.green, // background color
                        borderRadius: BorderRadius.circular(10), // optional rounded corners
                      ),
                      child: ListTile(
                        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 4), // reduce padding
                        visualDensity: VisualDensity(horizontal: 0, vertical: -4), // reduce height
                        leading: dataSet[featureIndex]['icons'],
                        title: Text(
                          dataSet[featureIndex]['mainText'],
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                        subtitle: Text(
                          dataSet[featureIndex]['subText'],
                          style: TextStyle(color: Colors.white70, fontSize: 12),
                        ),
                        trailing: Icon(
                          Icons.arrow_forward_ios_rounded,
                          color: Colors.white,
                          size: 16,
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 20),
                Container(
                  // width: MediaQuery.of(context).size.width,
                  height: 70,
                  child: ListView.builder(
                    itemCount: socialLinks.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder:(context, index){
                      return Container(
                        height: 60,
                        width: 60,
                        margin: EdgeInsets.only(right: 40),
                        child: CircleAvatar(
                          child: socialLinks[index]['icon'],
                        ),
                      );
                    }
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}