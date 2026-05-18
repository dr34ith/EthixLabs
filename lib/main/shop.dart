import 'package:flutter/material.dart';
import 'package:test_vuln/theme/cyber_theme.dart';
import 'package:test_vuln/widgets/background_stack.dart';
import 'package:test_vuln/missions/mission_01/mission_01.dart';
import 'package:test_vuln/missions/mission_02/mission_02.dart';
import 'package:test_vuln/missions/mission_03/mission_03.dart';
import 'package:test_vuln/missions/mission_04/mission_04.dart';
import 'package:test_vuln/missions/mission_05/mission_05.dart';
import 'package:flutter/services.dart';

class ShopScreen extends StatelessWidget {
  const ShopScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BackgroundStack(
      child: SafeArea(
        child: CustomScrollView(
          slivers: [
            // Header with Cart
            SliverToBoxAdapter(
              child: Container(
                padding: const EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Image.asset(
                                'assets/icons/vulnShop.png',
                                width: 40,
                                height: 40,
                              ),
                              const SizedBox(width: 12),
                              const Text(
                                'VulnShop',
                                style: TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  shadows: [
                                    Shadow(
                                      color: CyberTheme.primaryAccent,
                                      blurRadius: 10,
                                      offset: Offset(0, 0),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Purchase cybersecurity missions & earn rewards!',
                            style: TextStyle(
                              fontSize: 14,
                              color: CyberTheme.textMuted,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Shopping Cart Icon
                    Container(
                      decoration: BoxDecoration(
                        color: CyberTheme.primaryAccent.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: CyberTheme.primaryAccent,
                          width: 2,
                        ),
                      ),
                      child: Stack(
                        children: [
                          IconButton(
                            icon: const Icon(
                              Icons.shopping_cart,
                              color: CyberTheme.primaryAccent,
                              size: 28,
                            ),
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: const Text('Shopping cart coming soon!'),
                                  backgroundColor: CyberTheme.primaryAccent,
                                ),
                              );
                            },
                          ),
                          Positioned(
                            right: 8,
                            top: 8,
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: CyberTheme.primaryAccent,
                                shape: BoxShape.circle,
                              ),
                              child: const Text(
                                '0',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Categories
            SliverToBoxAdapter(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    _buildCategoryChip('All', true),
                    const SizedBox(width: 8),
                    _buildCategoryChip('SQLi', false),
                    const SizedBox(width: 8),
                    _buildCategoryChip('BAC', false),
                    const SizedBox(width: 8),
                    _buildCategoryChip('XSS', false),
                  ],
                ),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 16)),

            // Featured Banner
            SliverToBoxAdapter(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      CyberTheme.primaryAccent.withOpacity(0.3),
                      Colors.black.withOpacity(0.8),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: CyberTheme.primaryAccent,
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: CyberTheme.primaryAccent.withOpacity(0.3),
                      blurRadius: 20,
                      spreadRadius: 0,
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: CyberTheme.primaryAccent,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Text(
                              '🔥 HOT DEAL',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            'Complete 5 Missions',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'Get exclusive rewards & certificates',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(
                      Icons.card_giftcard,
                      color: CyberTheme.primaryAccent,
                      size: 60,
                    ),
                  ],
                ),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 24)),

            // Section Title
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'All Missions',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      '5 Available',
                      style: TextStyle(
                        fontSize: 14,
                        color: CyberTheme.primaryAccent,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 16)),

            // Mission Cards Grid
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.75,
                ),
                delegate: SliverChildListDelegate([
                  // Mission 1 Card
                  _buildShopCard(
                    context: context,
                    missionNumber: '01',
                    title: 'The Unlocked Door',
                    subtitle: 'SQL Injection - Login Bypass',
                    price: 'FREE',
                    originalPrice: null,
                    imageIcon: Icons.lock_open,
                    color: CyberTheme.primaryAccent,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const Mission_01()),
                      );
                    },
                  ),

                  // Mission 2 Card (UNLOCKED - just needs Mission 02 files)
                  _buildShopCard(
                    context: context,
                    missionNumber: '02',
                    title: 'Mission 2 Title',
                    subtitle: 'Mission 2 Subtitle',
                    price: 'FREE',
                    originalPrice: null,
                    imageIcon: Icons.security,
                    color: CyberTheme.primaryAccent,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const Mission_02()), // Make sure Mission_02 exists
                      );
                    },
                  ),

                  // Mission 3 Card
                  _buildShopCard(
                    context: context,
                    missionNumber: '03',
                    title: 'Who Owns This Order?',
                    subtitle: 'BAC - IDOR',
                    price: 'FREE',
                    originalPrice: null,
                    imageIcon: Icons.shopping_bag,
                    color: CyberTheme.primaryAccent,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const Mission_03()),
                      );
                    },
                  ),

                  // Mission 4 Card
                  _buildShopCard(
                    context: context,
                    missionNumber: '04',
                    title: 'The "Urgent Verification" Email',
                    subtitle: 'BAC - Phishing',
                    price: 'FREE',
                    originalPrice: null,
                    imageIcon: Icons.email,
                    color: CyberTheme.primaryAccent,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const Mission_04()),
                      );
                    },
                  ),

                  // Mission 5 Card
                  _buildShopCard(
                    context: context,
                    missionNumber: '05',
                    title: 'The Hidden Admin Panel',
                    subtitle: 'BAC - Forced Browsing',
                    price: 'FREE',
                    originalPrice: null,
                    imageIcon: Icons.admin_panel_settings,
                    color: CyberTheme.primaryAccent,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const Mission_05()),
                      );
                    },
                  ),

                  // Extra cards for future missions
                  _buildShopCard(
                    context: context,
                    missionNumber: '06',
                    title: 'Coming Soon',
                    subtitle: 'New Mission',
                    price: 'LOCKED',
                    originalPrice: null,
                    imageIcon: Icons.rocket_launch,
                    color: Colors.grey,
                    onTap: () {},
                    isLocked: true,
                  ),
                  _buildShopCard(
                    context: context,
                    missionNumber: '07',
                    title: 'Coming Soon',
                    subtitle: 'New Mission',
                    price: 'LOCKED',
                    originalPrice: null,
                    imageIcon: Icons.security,
                    color: Colors.grey,
                    onTap: () {},
                    isLocked: true,
                  ),
                ]),
              ),
            ),
            const SliverToBoxAdapter(
              child: SizedBox(height: 32),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryChip(String label, bool isSelected) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected ? CyberTheme.primaryAccent : Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isSelected ? CyberTheme.primaryAccent : Colors.white.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: isSelected ? Colors.white : Colors.white70,
        ),
      ),
    );

  }

  Widget _buildShopCard({
    required BuildContext context,
    required String missionNumber,
    required String title,
    required String subtitle,
    required String price,
    String? originalPrice,
    required IconData imageIcon,
    required Color color,
    required VoidCallback onTap,
    bool isLocked = false,
  }) {
    return GestureDetector(
      onTap: isLocked ? null : onTap,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              color.withOpacity(0.15),
              Colors.black.withOpacity(0.8),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isLocked ? Colors.grey.withOpacity(0.3) : color.withOpacity(0.5),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Stack(
          children: [
            if (isLocked)
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.black.withOpacity(0.6),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.lock,
                      color: Colors.white38,
                      size: 40,
                    ),
                  ),
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Mission Number Badge
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Text(
                      'MISSION $missionNumber',
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Icon
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: color.withOpacity(0.5)),
                    ),
                    child: Icon(
                      imageIcon,
                      color: color,
                      size: 28,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Title
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),

                  // Subtitle
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 11,
                      color: color.withOpacity(0.8),
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const Spacer(),

                  // Price and Action
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (originalPrice != null)
                              Text(
                                originalPrice,
                                style: const TextStyle(
                                  fontSize: 10,
                                  color: Colors.white38,
                                  decoration: TextDecoration.lineThrough,
                                ),
                              ),
                            Text(
                              price,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: isLocked ? Colors.grey : color,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: isLocked ? Colors.grey : color,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: color.withOpacity(0.3),
                              blurRadius: 8,
                              spreadRadius: 0,
                            ),
                          ],
                        ),
                        child: Icon(
                          isLocked ? Icons.lock : Icons.shopping_bag,
                          color: Colors.white,
                          size: 18,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}