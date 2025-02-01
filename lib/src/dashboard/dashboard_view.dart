import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../settings/settings_view.dart';
import '../product/product_list_view.dart';
import '../orders/orders_view.dart';
import '../auth/login_view.dart';
import '../auth/auth_service.dart';

class DashboardView extends StatelessWidget {
  const DashboardView({super.key});

  static const routeName = '/';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Admin Dashboard',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 2,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.black),
            onPressed: () async {
              await context.read<AuthService>().signOut();
              if (context.mounted) {
                Navigator.restorablePushReplacementNamed(
                  context,
                  LoginView.routeName,
                );
              }
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 16.0,
          mainAxisSpacing: 16.0,
          children: [
            _buildDashboardCard(
              context,
              'Total Products',
              '1,234',
              'assets/images/dashboard/products.png',
              Colors.blue[100]!,
              Colors.blue,
              onTap: () => Navigator.restorablePushNamed(
                context,
                ProductListView.routeName,
              ),
            ),
            _buildDashboardCard(
              context,
              'Total Orders',
              '5,678',
              'assets/images/dashboard/orders.png',
              Colors.green[100]!,
              Colors.green,
            ),
            _buildDashboardCard(
              context,
              'Total Revenue',
              '\$45,678',
              'assets/images/dashboard/revenue.png',
              Colors.orange[100]!,
              Colors.orange,
            ),
            _buildDashboardCard(context,
              'Pending Orders',
              '123',
              'assets/images/dashboard/pending.png',
              Colors.red[100]!,
              Colors.red,
              onTap: () => Navigator.restorablePushNamed(
                context,
                OrdersView.routeName,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDashboardCard(
    BuildContext context,
    String title,
    String value,
    String iconPath,
    Color backgroundColor,
    Color? iconColor, {
    VoidCallback? onTap,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap ?? () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('$title card tapped')),
          );
        },
        child: Container(
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                iconPath,
                height: 40,
                width: 40,
                color: iconColor,
              ),
              const SizedBox(height: 8),
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: iconColor,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: iconColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}