import 'package:flutter/material.dart';

class GameMenuButton extends StatelessWidget {
  final VoidCallback onMenuOpen;
  
  const GameMenuButton({
    Key? key,
    required this.onMenuOpen,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onMenuOpen();
        _showGameMenu(context);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.7),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Colors.grey.shade700,
            width: 2,
          ),
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.menu,
              color: Colors.white,
              size: 20,
            ),
            SizedBox(width: 5),
            Text(
              'القائمة',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  void _showGameMenu(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          width: 300,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.9),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Colors.grey.shade700,
              width: 2,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Title
              const Text(
                'القائمة الرئيسية',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              
              // Menu items
              _buildMenuItem(
                icon: Icons.person,
                label: 'الشخصية',
                onTap: () {
                  Navigator.of(context).pop();
                  // Show character screen
                },
              ),
              _buildMenuItem(
                icon: Icons.inventory,
                label: 'الحقيبة',
                onTap: () {
                  Navigator.of(context).pop();
                  // Show inventory screen
                },
              ),
              _buildMenuItem(
                icon: Icons.auto_awesome,
                label: 'المهارات',
                onTap: () {
                  Navigator.of(context).pop();
                  // Show skills screen
                },
              ),
              _buildMenuItem(
                icon: Icons.people,
                label: 'النقابة',
                onTap: () {
                  Navigator.of(context).pop();
                  // Show guild screen
                },
              ),
              _buildMenuItem(
                icon: Icons.assignment,
                label: 'المهام',
                onTap: () {
                  Navigator.of(context).pop();
                  // Show quests screen
                },
              ),
              _buildMenuItem(
                icon: Icons.shopping_cart,
                label: 'المتجر',
                onTap: () {
                  Navigator.of(context).pop();
                  // Show shop screen
                },
              ),
              _buildMenuItem(
                icon: Icons.settings,
                label: 'الإعدادات',
                onTap: () {
                  Navigator.of(context).pop();
                  // Show settings screen
                },
              ),
              const SizedBox(height: 20),
              
              // Return to game button
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 40),
                ),
                child: const Text('العودة للعبة'),
              ),
              const SizedBox(height: 10),
              
              // Logout button
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  _showLogoutConfirmation(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 40),
                ),
                child: const Text('تسجيل الخروج'),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildMenuItem({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: Colors.white,
      ),
      title: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
        ),
      ),
      trailing: const Icon(
        Icons.arrow_forward_ios,
        color: Colors.white,
        size: 16,
      ),
      onTap: onTap,
    );
  }
  
  void _showLogoutConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.black.withOpacity(0.9),
        title: const Text(
          'تسجيل الخروج',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        content: const Text(
          'هل أنت متأكد من رغبتك في تسجيل الخروج من اللعبة؟',
          style: TextStyle(
            color: Colors.white,
            fontSize: 14,
          ),
          textAlign: TextAlign.center,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(
              'إلغاء',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              // Logout logic
              Navigator.of(context).pushReplacementNamed('/login');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('تسجيل الخروج'),
          ),
        ],
      ),
    );
  }
}