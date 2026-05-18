import 'package:flutter/material.dart';
import 'package:test_vuln/missions/step_layout.dart';
import 'package:test_vuln/missions/mission_05/mission_05_identify.dart';

class Mission05Test extends StatefulWidget {
  const Mission05Test({Key? key}) : super(key: key);

  @override
  State<Mission05Test> createState() => _Mission05TestState();
}

class _Mission05TestState extends State<Mission05Test> {
  final TextEditingController _urlController = TextEditingController();
  String _resultMessage = '';
  bool _hasAccessedAdmin = false;
  bool _showingUserDashboard = true;

  void _accessUrl() {
    final url = _urlController.text.trim().toLowerCase();

    if (url == '/admin/dashboard' || url == 'admin/dashboard' || url == '/admin') {
      setState(() {
        _hasAccessedAdmin = true;
        _showingUserDashboard = false;
        _resultMessage = '✅ ADMIN PANEL ACCESSED!\n\n'
            'You successfully accessed the admin dashboard as a regular user!\n\n'
            'This is a Forced Browsing vulnerability. The server rendered the admin dashboard '
            'purely based on the URL, without checking whether your session actually has admin privileges.\n\n'
            'Security through obscurity (hiding links) is NOT access control.';
      });
    } else if (url == '/dashboard' || url == '/user/dashboard') {
      setState(() {
        _hasAccessedAdmin = false;
        _showingUserDashboard = true;
        _resultMessage = 'ℹ️ This is your user dashboard.\n\n'
            'Try accessing: /admin/dashboard';
      });
    } else {
      setState(() {
        _hasAccessedAdmin = false;
        _showingUserDashboard = true;
        _resultMessage = '❌ Page not found.\n\n'
            'Try accessing: /admin/dashboard';
      });
    }
  }

  void _reset() {
    _urlController.clear();
    setState(() {
      _hasAccessedAdmin = false;
      _showingUserDashboard = true;
      _resultMessage = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return StepLayout(
      stepNumber: 'STEP 2 OF 5',
      stepTitle: 'Test the Vulnerability',
      onNextPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const Mission05Identify()),
        );
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              const Color(0xFFE68C8C).withOpacity(0.15),
              Colors.black.withOpacity(0.6),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: const Color(0xFFE68C8C).withOpacity(0.5),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Browser/URL bar simulation
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.shade900,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFE68C8C).withOpacity(0.3)),
              ),
              child: Column(
                children: [
                  // Browser toolbar
                  Row(
                    children: [
                      Container(
                        width: 12,
                        height: 12,
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        width: 12,
                        height: 12,
                        decoration: const BoxDecoration(
                          color: Colors.orange,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        width: 12,
                        height: 12,
                        decoration: const BoxDecoration(
                          color: Colors.green,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const Spacer(),
                      const Icon(Icons.lock, color: Colors.green, size: 14),
                      const SizedBox(width: 4),
                      const Text(
                        'vulnshop.com',
                        style: TextStyle(color: Colors.white54, fontSize: 10),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  
                  // URL bar
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.6),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey.shade700),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.http, color: Colors.white54, size: 16),
                        const SizedBox(width: 8),
                        const Text(
                          'vulnshop.com',
                          style: TextStyle(color: Colors.white70, fontSize: 12),
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: TextField(
                            controller: _urlController,
                            style: const TextStyle(color: Colors.white, fontSize: 12),
                            decoration: const InputDecoration(
                              hintText: 'path...',
                              hintStyle: TextStyle(color: Colors.grey, fontSize: 12),
                              border: InputBorder.none,
                              isDense: true,
                              contentPadding: EdgeInsets.zero,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  
                  // Go button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _accessUrl,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFE68C8C),
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'GO',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 20),
            
            // Dashboard display
            if (_showingUserDashboard && !_hasAccessedAdmin && _resultMessage.isEmpty)
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.white38.withOpacity(0.3)),
                ),
                child: Column(
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.person, color: Color(0xFFE68C8C), size: 24),
                        SizedBox(width: 12),
                        Text(
                          'User Dashboard',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    _buildDashboardItem(Icons.shopping_cart, 'My Orders', 'View your order history'),
                    const SizedBox(height: 12),
                    _buildDashboardItem(Icons.person_outline, 'Profile Settings', 'Update your information'),
                    const SizedBox(height: 12),
                    _buildDashboardItem(Icons.favorite_border, 'Wishlist', 'Saved items'),
                  ],
                ),
              ),
            
            if (_hasAccessedAdmin)
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.red),
                ),
                child: Column(
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.admin_panel_settings, color: Colors.red, size: 24),
                        SizedBox(width: 12),
                        Text(
                          'ADMIN DASHBOARD (UNAUTHORIZED ACCESS)',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    _buildDashboardItem(Icons.people, 'All Users', 'Manage customer accounts - 1,247 users'),
                    const SizedBox(height: 12),
                    _buildDashboardItem(Icons.payment, 'All Orders', 'View all transactions - \$45,892 total'),
                    const SizedBox(height: 12),
                    _buildDashboardItem(Icons.settings, 'System Settings', 'Change application configuration'),
                    const SizedBox(height: 12),
                    _buildDashboardItem(Icons.security, 'User Roles', 'Promote/demote admin privileges'),
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.warning, color: Colors.red, size: 20),
                          SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'This page should NOT be accessible to regular users! '
                              'The server did not verify admin privileges.',
                              style: TextStyle(color: Colors.red, fontSize: 12),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            
            if (_resultMessage.isNotEmpty && !_hasAccessedAdmin)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.blue),
                ),
                child: Text(
                  _resultMessage,
                  style: const TextStyle(
                    color: Colors.blue,
                    fontSize: 13,
                    height: 1.4,
                  ),
                ),
              ),
            
            if (_hasAccessedAdmin)
              const SizedBox(height: 16),
            
            if (_hasAccessedAdmin)
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: _reset,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Try Different URL'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFFE68C8C),
                    side: const BorderSide(color: Colors.white38),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildDashboardItem(IconData icon, String title, String description) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.3),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade800),
      ),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFFE68C8C), size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
                Text(
                  description,
                  style: const TextStyle(
                    color: Colors.white54,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}