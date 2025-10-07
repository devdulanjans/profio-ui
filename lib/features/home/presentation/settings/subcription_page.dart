import 'package:flutter/material.dart';
import 'package:profio/features/services/api_service.dart';

class SubscriptionPlan {
  final String planName;
  final double price;
  final List<String> features;
  final bool isPopular;
  final bool isSelected;

  SubscriptionPlan({
    required this.planName,
    required this.price,
    required this.features,
    required this.isPopular,
    required this.isSelected
  });
}

// final List<SubscriptionPlan> subscriptionPlans = [
//   SubscriptionPlan(
//     planName: 'Silver',
//     price: 4.99,
//     features: [
//       'Access to basic app features',
//       'Limited customer support (email only)',
//       '5GB cloud storage',
//       'Ads displayed in the app',
//       'Access to community forum',
//     ],
//     isPopular: false,
//     isSelected: false
//   ),
//   SubscriptionPlan(
//     planName: 'Bronze',
//     price: 9.99,
//     features: [
//       'Everything in Silver',
//       'Priority customer support (chat + email)',
//       '25GB cloud storage',
//       'Ad-free experience',
//       'Access to premium content and early updates',
//       'Download reports/data in CSV format',
//     ],
//     isSelected: true,
//     isPopular: false
//   ),
//   SubscriptionPlan(
//     planName: 'Gold',
//     price: 19.99,
//     features: [
//       'Everything in Bronze',
//       '100GB cloud storage',
//       'Dedicated account manager',
//       '24/7 customer support',
//       'API access for integrations',
//       'Multi-device sync',
//       'Advanced analytics dashboard',
//       'Custom branding options',
//     ],
//     isPopular: true,
//     isSelected: true
//   ),
// ];


class SubscriptionPage extends StatelessWidget {
  const SubscriptionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getSubscriptionTypes(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('❌ Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No subscription plans available.'));
        }

        final subscriptionPlans = snapshot.data ?? [];
        subscriptionPlans.sort((a, b) {
          return (a.cardTemplateLimit ?? 0).compareTo(b.cardTemplateLimit ?? 0);
        });


        return ListView.builder(
            itemCount: subscriptionPlans.length,
            itemBuilder: (context, index) {
              final plan = subscriptionPlans[index];
              plan.code == "FREE" ? plan.isSelected = true : plan.isSelected = false;
              return Container(
                margin: const EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  gradient: (plan.isSelected ?? false) == false
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
                child: Card(
                  elevation: 0, // Set to 0 to use container's shadow
                  color: Colors.transparent, // Make card transparent to show gradient
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        plan.name ?? "",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: (plan.isSelected ?? false) == false ? Colors.black : Colors.white
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '\$${(plan.amount ?? 0).toStringAsFixed(2)} / month',
                        style: TextStyle(
                          fontSize: 20,
                          color: (plan.isSelected ?? false) == false ? Colors.black:Colors.white,
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'Features:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black
                        ),
                      ),
                      const SizedBox(height: 12),
                      Visibility(
                        visible: !(plan.isSelected ?? false),
                        child: ElevatedButton(
                          onPressed: () {
                            // Handle plan selection logic
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('${plan.name} plan selected!')),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(double.infinity, 45),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Text('Choose ${plan.name} Plan'),
                        ),
                      ),
                      const SizedBox(height: 12),
                      ...(plan.description ?? '').split(',').map(
                            (feature) => Row(
                          children: [
                            const Icon(Icons.check_circle, color: Colors.green, size: 18),
                            const SizedBox(width: 6, height: 30),
                            Expanded(
                              child: Text(
                                feature.trim(),
                                style: const TextStyle(fontSize: 14, color: Colors.black),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // const SizedBox(height: 12),
                      // ElevatedButton(
                      //   onPressed: () {
                      //     // Handle plan selection logic
                      //     ScaffoldMessenger.of(context).showSnackBar(
                      //       SnackBar(content: Text('${plan.planName} plan selected!')),
                      //     );
                      //   },
                      //   style: ElevatedButton.styleFrom(
                      //     minimumSize: const Size(double.infinity, 45),
                      //     shape: RoundedRectangleBorder(
                      //       borderRadius: BorderRadius.circular(10),
                      //     ),
                      //   ),
                      //   child: Text('Choose ${plan.planName} Plan'),
                      // ),
                    ],
                  ),
                  ),
                ),
              );
            },
          );
      }
    );
  }
}
