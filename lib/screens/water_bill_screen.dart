import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class WaterBillScreen extends StatelessWidget {
  const WaterBillScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF030317), // Deep dark background
      body: Stack(
        children: [
          // Background Elements
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: MediaQuery.of(context).size.height * 0.45,
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFF0D47A1), // Brighter blue at top
                    Color(0xFF030317), // Fading into deep background
                  ],
                ),
              ),
            ),
          ),
          
          // Wavy background shapes and Water drop (Using custom painter or simple circles for the glow effect)
          Positioned(
            top: 80,
            left: MediaQuery.of(context).size.width / 2 - 100,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    const Color(0xFF2196F3).withOpacity(0.4),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          
          // Center water drop icon
          Positioned(
            top: 100,
            left: MediaQuery.of(context).size.width / 2 - 45,
            child: Icon(
              Icons.water_drop,
              size: 90,
              color: const Color(0xFF42A5F5).withOpacity(0.9),
            ),
          ),

          // Glassmorphic Card
          Align(
            alignment: Alignment.bottomCenter,
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(40),
                topRight: Radius.circular(40),
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.65,
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0B1036).withOpacity(0.7),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40),
                    ),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.05),
                      width: 1.5,
                    ),
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header "Water" and "Paid"
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Water',
                              style: GoogleFonts.inter(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'Paid',
                              style: GoogleFonts.inter(
                                color: const Color(0xFF42A5F5),
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        
                        // Dropdown simulation
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Lorem Water',
                              style: GoogleFonts.inter(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const Icon(Icons.keyboard_arrow_down, color: Color(0xFF42A5F5)),
                          ],
                        ),
                        const SizedBox(height: 24),
                        
                        // Form fields
                        _buildFormField('Account'),
                        const SizedBox(height: 12),
                        _buildFormField('Mobile Number'),
                        const SizedBox(height: 12),
                        _buildFormField('E-mail'),
                        const SizedBox(height: 12),
                        _buildFormField('Bill Number'),
                        
                        const SizedBox(height: 24),
                        Divider(color: Colors.white.withOpacity(0.1), thickness: 1),
                        const SizedBox(height: 24),
                        
                        // Last Transactions Header
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: const Color(0xFF1976D2),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(Icons.water_drop, color: Colors.white, size: 20),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              'Last Transactions',
                              style: GoogleFonts.inter(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Spacer(),
                            const Icon(Icons.menu, color: Color(0xFF42A5F5)),
                          ],
                        ),
                        const SizedBox(height: 24),
                        
                        // Transactions List
                        _buildTransactionRow('July Bill', 'Water', '\$513', '20.07.06'),
                        const SizedBox(height: 16),
                        _buildTransactionRow('June Bill', 'Water', '\$530', '20.06.20'),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormField(String label) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Text(
            label,
            style: GoogleFonts.inter(
              color: const Color(0xFF42A5F5).withOpacity(0.8),
              fontSize: 14,
            ),
          ),
        ),
        Expanded(
          flex: 3,
          child: Container(
            height: 36,
            decoration: BoxDecoration(
              color: const Color(0xFF1A237E).withOpacity(0.4),
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTransactionRow(String title, String subtitle, String amount, String date) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: GoogleFonts.inter(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: GoogleFonts.inter(
                color: const Color(0xFF42A5F5),
                fontSize: 12,
              ),
            ),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              amount,
              style: GoogleFonts.inter(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              date,
              style: GoogleFonts.inter(
                color: const Color(0xFF42A5F5),
                fontSize: 12,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
