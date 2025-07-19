// ignore_for_file: unused_local_variable

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fl_chart/fl_chart.dart';

class AdminDashboardContent extends StatefulWidget {
  const AdminDashboardContent({super.key});

  @override
  State<AdminDashboardContent> createState() => _AdminDashboardContentState();
}

class _AdminDashboardContentState extends State<AdminDashboardContent> {
  String selectedMaterialType = 'Books';
  String selectedYear = '2022';

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth > 700;
        final isMobile = constraints.maxWidth < 500;
        final horizontalBarCount = 5; // Number of bars in horizontal chart
        final verticalBarCount = 5;   // Number of groups in vertical chart (unused)
        final horizontalBarWidth = (constraints.maxWidth / (isMobile ? 2.5 : 6)) / horizontalBarCount;
        final verticalBarWidth = (constraints.maxWidth / (isMobile ? 16 : 28));
        return Padding(
          padding: EdgeInsets.all(isMobile ? 8 : 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.all(16),
                child: Row(
                  children: [
                    Icon(Icons.analytics, color: Colors.red, size: 28),
                    SizedBox(width: 12),
                    Text(
                      'Admin Dashboard',
                      style: GoogleFonts.poppins(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade800,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: isMobile ? 10 : 20),
              // Dashboard Content
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(isMobile ? 8 : 24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        spreadRadius: 1,
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'DASHBOARD',
                        style: GoogleFonts.poppins(
                          fontSize: isMobile ? 14 : (isWide ? 24 : 18),
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF2C2C2C),
                        ),
                      ),
                      SizedBox(height: isMobile ? 10 : 30),
                      // Summary Boxes
                      Row(
                        children: [
                          Expanded(
                            child: _buildSummaryBox('TOTAL BORROWED BOOKS', '234', const Color(0xFFD32F2F), isMobile),
                          ),
                          const SizedBox(width: 20),
                          Expanded(
                            child: _buildSummaryBox('TOTAL RETURNED BOOKS', '196', const Color(0xFFB71C1C), isMobile),
                          ),
                        ],
                      ),
                      SizedBox(height: isMobile ? 15 : 40),
                      // Charts Section
                      Expanded(
                        child: isMobile
                          ? ListView(
                              children: [
                                SizedBox(height: 10),
                                _buildHorizontalBarChart(isMobile, horizontalBarWidth),
                                SizedBox(height: 20),
                                _buildVerticalBarChart(isMobile, verticalBarWidth),
                              ],
                            )
                          : Row(
                              children: [
                                Expanded(child: _buildHorizontalBarChart(isMobile, horizontalBarWidth)),
                                const SizedBox(width: 20),
                                Expanded(child: _buildVerticalBarChart(isMobile, verticalBarWidth)),
                              ],
                            ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
//CARDS
  Widget _buildSummaryBox(String title, String value, Color color, bool isMobile) {
    return Container(
      padding: EdgeInsets.all(isMobile ? 12 : 24),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: isMobile ? 10 : 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: isMobile ? 4 : 8),
          Text(
            value,
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: isMobile ? 18 : 32,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
//LEFT GRAPH
  Widget _buildHorizontalBarChart(bool isMobile, double barWidth) {
    final List<String> materialTypes = [
      'Books', 'Electronic Books', 'Kits', 'Thesis', 'Artifacts'
    ];
    return Container(
      height: isMobile ? 200 : null,
      padding: EdgeInsets.all(isMobile ? 8 : 16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Selectable filter buttons for material types
          Wrap(
            spacing: 8,
            children: materialTypes.map((type) => OutlinedButton(
              onPressed: () {
                setState(() {
                  selectedMaterialType = type;
                });
              },
              style: OutlinedButton.styleFrom(
                backgroundColor: selectedMaterialType == type ? Colors.red[100] : null,
                side: BorderSide(
                  color: selectedMaterialType == type ? Colors.red : Colors.grey,
                ),
              ),
              child: Text(
                type,
                style: GoogleFonts.poppins(
                  fontSize: isMobile ? 8 : 12,
                  color: selectedMaterialType == type ? Colors.red[900] : Colors.black,
                  fontWeight: selectedMaterialType == type ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            )).toList(),
          ),
          SizedBox(height: 12),
          Row(
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: const BoxDecoration(
                  color: Color(0xFFD32F2F),
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'Borrowed Books per Material Type',
                style: GoogleFonts.poppins(
                  fontSize: isMobile ? 10 : 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Expanded(
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: 15,
                barTouchData: BarTouchData(enabled: false),
                titlesData: FlTitlesData(
                  show: true,
                  rightTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        const titles = ['0', '5', '10', '15', '19'];
                        if (value.toInt() < titles.length) {
                          return Text(
                            titles[value.toInt()],
                            style: GoogleFonts.poppins(fontSize: isMobile ? 8 : 12),
                          );
                        }
                        return const Text('');
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: isMobile ? 50 : 80,
                      getTitlesWidget: (value, meta) {
                        const titles = [
                          'Books',
                          'Electronic Books',
                          'Kits',
                          'Thesis',
                          'Artifacts'
                        ];
                        if (value.toInt() < titles.length) {
                          return Text(
                            titles[value.toInt()],
                            style: GoogleFonts.poppins(fontSize: isMobile ? 7 : 10),
                          );
                        }
                        return const Text('');
                      },
                    ),
                  ),
                ),
                borderData: FlBorderData(show: false),
                barGroups: [
                  BarChartGroupData(x: 0, barRods: [BarChartRodData(toY: 9, color: const Color(0xFFD32F2F), width: barWidth, borderRadius: BorderRadius.circular(4))]),
                  BarChartGroupData(x: 1, barRods: [BarChartRodData(toY: 6, color: const Color(0xFFD32F2F), width: barWidth, borderRadius: BorderRadius.circular(4))]),
                  BarChartGroupData(x: 2, barRods: [BarChartRodData(toY: 5, color: const Color(0xFFD32F2F), width: barWidth, borderRadius: BorderRadius.circular(4))]),
                  BarChartGroupData(x: 3, barRods: [BarChartRodData(toY: 14, color: const Color(0xFFD32F2F), width: barWidth, borderRadius: BorderRadius.circular(4))]),
                  BarChartGroupData(x: 4, barRods: [BarChartRodData(toY: 9, color: const Color(0xFFD32F2F), width: barWidth, borderRadius: BorderRadius.circular(4))]),
                ],
                gridData: FlGridData(show: false),
              ),
            ),
          ),
        ],
      ),
    );
  }
//RIGHT GRAPH
  Widget _buildVerticalBarChart(bool isMobile, double barWidth) {
    final List<String> years = ['2022', '2023', '2024', '2025'];
    return Container(
      height: isMobile ? 200 : null,
      padding: EdgeInsets.all(isMobile ? 8 : 16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Selectable filter buttons for years
          Wrap(
            spacing: 8,
            children: years.map((year) => OutlinedButton(
              onPressed: () {
                setState(() {
                  selectedYear = year;
                });
              },
              style: OutlinedButton.styleFrom(
                backgroundColor: selectedYear == year ? Colors.red[100] : null,
                side: BorderSide(
                  color: selectedYear == year ? Colors.red : Colors.grey,
                ),
              ),
              child: Text(
                year,
                style: GoogleFonts.poppins(
                  fontSize: isMobile ? 8 : 12,
                  color: selectedYear == year ? Colors.red[900] : Colors.black,
                  fontWeight: selectedYear == year ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            )).toList(),
          ),
          SizedBox(height: 12),
          Row(
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: const BoxDecoration(
                  color: Color(0xFFD32F2F),
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'Borrowed Books',
                style: GoogleFonts.poppins(
                  fontSize: isMobile ? 8 : 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(width: 16),
              Container(
                width: 12,
                height: 12,
                decoration: const BoxDecoration(
                  color: Color(0xFFB71C1C),
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'Returned Books',
                style: GoogleFonts.poppins(
                  fontSize: isMobile ? 8 : 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Expanded(
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.center,
                groupsSpace: isMobile ? 16 : 32, // Try increasing for more space
                maxY: 7,
                barTouchData: BarTouchData(enabled: false),
                titlesData: FlTitlesData(
                  show: true,
                  rightTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        const titles = ['Jan', 'Feb', 'Mar', 'Apr', 'May'];
                        if (value.toInt() < titles.length) {
                          return Text(
                            titles[value.toInt()],
                            style: GoogleFonts.poppins(fontSize: isMobile ? 8 : 12),
                          );
                        }
                        return const Text('');
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: isMobile ? 18 : 30,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          value.toInt().toString(),
                          style: GoogleFonts.poppins(fontSize: isMobile ? 7 : 10),
                        );
                      },
                    ),
                  ),
                ),
                borderData: FlBorderData(show: false),
                barGroups: [
                  BarChartGroupData(
                    x: 0,
                    barRods: [
                      BarChartRodData(toY: 3.5, color: const Color(0xFFD32F2F), width: barWidth,borderRadius: BorderRadius.circular(4)),
                      BarChartRodData(toY: 6, color: const Color(0xFFB71C1C), width: barWidth,borderRadius: BorderRadius.circular(4)),
                    ],
                  ),
                  BarChartGroupData(
                    x: 1,
                    barRods: [
                      BarChartRodData(toY: 7, color: const Color(0xFFD32F2F), width: barWidth,borderRadius: BorderRadius.circular(4)),
                      BarChartRodData(toY: 7, color: const Color(0xFFB71C1C), width: barWidth,borderRadius: BorderRadius.circular(4)),
                    ],
                  ),
                  BarChartGroupData(
                    x: 2,
                    barRods: [
                      BarChartRodData(toY: 5, color: const Color(0xFFD32F2F), width: barWidth,borderRadius: BorderRadius.circular(4)),
                      BarChartRodData(toY: 6, color: const Color(0xFFB71C1C), width: barWidth,borderRadius: BorderRadius.circular(4)),
                    ],
                  ),
                  BarChartGroupData(
                    x: 3,
                    barRods: [
                      BarChartRodData(toY: 2, color: const Color(0xFFD32F2F), width: barWidth,borderRadius: BorderRadius.circular(4)),
                      BarChartRodData(toY: 3, color: const Color(0xFFB71C1C), width: barWidth,borderRadius: BorderRadius.circular(4)),
                    ],
                  ),
                  BarChartGroupData(
                    x: 4,
                    barRods: [
                      BarChartRodData(toY: 3, color: const Color(0xFFD32F2F), width: barWidth,borderRadius: BorderRadius.circular(4)),
                      BarChartRodData(toY: 2, color: const Color(0xFFB71C1C), width: barWidth,borderRadius: BorderRadius.circular(4)),
                    ],
                  ),
                ],
                gridData: FlGridData(show: false),
              ),
            ),
          ),
        ],
      ),
    );
  }
} 