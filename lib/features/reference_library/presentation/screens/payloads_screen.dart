import 'package:flutter/material.dart';

import 'package:ethixlabs/core/theme/app_colors.dart';
import '../../data/payloads_content.dart';
import '../widgets/payload_category_section.dart';

/// Lab-aligned payloads reference: the exact strings students type across
/// the 25 EthixLabs missions, grouped by OWASP category with a
/// copy-to-clipboard button on every payload.
class PayloadsScreen extends StatelessWidget {
  const PayloadsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      appBar: AppBar(
        title: const Text(
          'Payloads',
          style: TextStyle(
            color: Color(0xFFFFD1D1),
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: AppColors.bgPrimary,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFFE68C8C)),
          onPressed: () => Navigator.pop(context),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            height: 1,
            color: const Color(0xFFE68C8C).withOpacity(0.3),
          ),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(24),
        itemCount: payloadCategories.length + 2,
        itemBuilder: (context, index) {
          if (index == 0) return _buildIntro();
          if (index == payloadCategories.length + 1) return _buildWarning();
          return PayloadCategorySection(
            category: payloadCategories[index - 1],
          );
        },
      ),
    );
  }

  Widget _buildIntro() {
    return const Padding(
      padding: EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Lab-Only Payloads',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFFFFD1D1),
            ),
          ),
          SizedBox(height: 8),
          Text(
            'The exact payloads used in the EthixLabs lab environment, grouped by OWASP category.',
            style: TextStyle(fontSize: 12, color: Colors.white70),
          ),
        ],
      ),
    );
  }

  Widget _buildWarning() {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.red.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.red.withOpacity(0.3)),
      ),
      child: const Row(
        children: [
          Icon(Icons.warning_amber_rounded, color: Colors.orange, size: 20),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              '⚠️ These payloads are for educational purposes only. Only test on systems you own or have written permission to test.',
              style: TextStyle(fontSize: 11, color: Colors.white70),
            ),
          ),
        ],
      ),
    );
  }
}
