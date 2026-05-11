import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../providers/task_provider.dart';
import '../models/task_model.dart';
import 'create_normal_task_page.dart';
import 'create_urgent_task_page.dart';
import 'task_list_page.dart';
import 'options_page.dart';
import '../utils/date_formatter.dart';

class DashboardPage extends StatelessWidget {
  final String username;
  final int userId;

  const DashboardPage({
    super.key,
    required this.username,
    required this.userId,
  });

  // Calculate tasks done per day for the current week (Mon-Sun)
  List<int> _getWeeklyDoneTasks(List<Task> allTasks) {
    List<int> weeklyData = List.filled(
      7,
      0,
    ); // [Mon, Tue, Wed, Thu, Fri, Sat, Sun]

    final now = DateTime.now();
    // In Dart, weekday is 1=Mon, 7=Sun
    final monday = now.subtract(Duration(days: now.weekday - 1));
    final startOfWeek = DateTime(monday.year, monday.month, monday.day);
    final endOfWeek = startOfWeek.add(
      const Duration(days: 6, hours: 23, minutes: 59, seconds: 59),
    );

    for (var task in allTasks) {
      if (task.status == TaskStatus.done &&
          task.date.isAfter(startOfWeek.subtract(const Duration(seconds: 1))) &&
          task.date.isBefore(endOfWeek.add(const Duration(seconds: 1)))) {
        // Find which day of the week this task belongs to (0=Mon, 6=Sun)
        int dayIndex = task.date.weekday - 1;
        weeklyData[dayIndex]++;
      }
    }
    return weeklyData;
  }

  Widget _buildSummaryCard({
    required String title,
    required int count,
    required IconData icon,
    required Color color,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 12.0),
        child: Column(
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 8),
            Text(
              count.toString(),
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: color.withOpacity(0.8),
              ),
            ),
            Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.blueGrey,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text(
          "Dashboard",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
      ),
      body: Consumer<TaskProvider>(
        builder: (context, provider, child) {
          final weeklyData = _getWeeklyDoneTasks(provider.tasks);
          double maxVal = weeklyData.reduce((a, b) => a > b ? a : b).toDouble();
          if (maxVal == 0)
            maxVal = 5; // default max y-axis to make chart look good when empty

          return CustomScrollView(
            slivers: [
              // Welcome Text
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    children: [
                      Icon(
                        Icons.account_circle,
                        size: 60,
                        color: Colors.blueAccent.shade100,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Welcome, $username!",
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        DateFormatter.formatFullDate(DateTime.now()),
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey.shade600,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Chart Section
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Tasks Completed This Week",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 24),
                          SizedBox(
                            height: 200,
                            child: BarChart(
                              BarChartData(
                                alignment: BarChartAlignment.spaceAround,
                                maxY: maxVal + 1,
                                barTouchData: BarTouchData(enabled: false),
                                titlesData: FlTitlesData(
                                  show: true,
                                  bottomTitles: AxisTitles(
                                    sideTitles: SideTitles(
                                      showTitles: true,
                                      getTitlesWidget: (value, meta) {
                                        const days = [
                                          'Mon',
                                          'Tue',
                                          'Wed',
                                          'Thu',
                                          'Fri',
                                          'Sat',
                                          'Sun',
                                        ];
                                        return Padding(
                                          padding: const EdgeInsets.only(
                                            top: 8.0,
                                          ),
                                          child: Text(
                                            days[value.toInt()],
                                            style: const TextStyle(
                                              color: Colors.grey,
                                              fontSize: 12,
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                  leftTitles: const AxisTitles(
                                    sideTitles: SideTitles(showTitles: false),
                                  ),
                                  topTitles: const AxisTitles(
                                    sideTitles: SideTitles(showTitles: false),
                                  ),
                                  rightTitles: const AxisTitles(
                                    sideTitles: SideTitles(showTitles: false),
                                  ),
                                ),
                                borderData: FlBorderData(show: false),
                                gridData: const FlGridData(show: false),
                                barGroups: List.generate(7, (index) {
                                  return BarChartGroupData(
                                    x: index,
                                    barRods: [
                                      BarChartRodData(
                                        toY: weeklyData[index].toDouble(),
                                        color: Colors.blueAccent,
                                        width: 16,
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                    ],
                                  );
                                }),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              // Task Summary Section
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
                  child: Row(
                    children: [
                      Expanded(
                        child: _buildSummaryCard(
                          title: "Done",
                          count: provider.doneTasksCount,
                          icon: Icons.check_circle_outline,
                          color: Colors.green,
                        ),
                      ),
                      Expanded(
                        child: _buildSummaryCard(
                          title: "Ongoing",
                          count: provider.ongoingTasksCount,
                          icon: Icons.pending_actions,
                          color: Colors.orange,
                        ),
                      ),
                      const SizedBox(width: 16),
                    ],
                  ),
                ),
              ),

              // 2x2 Grid Section
              SliverPadding(
                padding: const EdgeInsets.all(24.0),
                sliver: SliverGrid.count(
                  crossAxisCount: 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  children: [
                    _buildGridButton(
                      context: context,
                      title: "Normal Task",
                      icon: Icons.add_task,
                      color: Colors.lightBlue,
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => CreateNormalTaskPage(userId: userId),
                        ),
                      ),
                    ),
                    _buildGridButton(
                      context: context,
                      title: "Urgent Task",
                      icon: Icons.priority_high,
                      color: Colors.redAccent,
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => CreateUrgentTaskPage(userId: userId),
                        ),
                      ),
                    ),
                    _buildGridButton(
                      context: context,
                      title: "View All Tasks",
                      icon: Icons.list_alt,
                      color: Colors.blueAccent,
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const TaskListPage()),
                      ),
                    ),
                    _buildGridButton(
                      context: context,
                      title: "Options",
                      icon: Icons.settings,
                      color: Colors.blueGrey,
                      isOutline: true,
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const OptionsPage()),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildGridButton({
    required BuildContext context,
    required String title,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
    bool isOutline = false,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: isOutline ? Colors.white : color,
          borderRadius: BorderRadius.circular(16),
          border: isOutline ? Border.all(color: Colors.grey.shade300) : null,
          boxShadow: isOutline
              ? []
              : [
                  BoxShadow(
                    color: color.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: isOutline ? color : Colors.white),
            const SizedBox(height: 12),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: isOutline ? color : Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
