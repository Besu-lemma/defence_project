import 'package:flutter/material.dart';
import 'package:restart_app/restart_app.dart';


class CustomNavBar extends StatelessWidget {
  final VoidCallback onLock;

  const CustomNavBar({super.key, required this.onLock});

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: Colors.green,
      shape: const CircularNotchedRectangle(),
      notchMargin: 8,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Hamburger Menu - Opens Settings Modal
            IconButton(
              icon: const Icon(Icons.menu, color: Colors.white, size: 30),
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  builder: (context) => _buildSettingsMenu(context),
                );
              },
            ),

            // Language Dropdown
            _buildLanguageDropdown(),

            // Restart Button - Refreshes the App
            IconButton(
              icon: const Icon(Icons.refresh, color: Colors.white, size: 30),
              onPressed: () async {
               Restart.restartApp();

              },
            ),

            // Lock Button - Calls onLock function
            IconButton(
              icon: const Icon(Icons.lock, color: Colors.white, size: 30),
              onPressed: onLock,
            ),
          ],
        ),
      ),
    );
  }

  // Language Selection Dropdown
  Widget _buildLanguageDropdown() {
    return DropdownButton<String>(
      dropdownColor: Colors.white,
      icon: const Icon(Icons.language, color: Colors.white, size: 28),
      underline: const SizedBox(),
      items: ['Amharic', 'Afaan Oromo', 'English']
          .map((lang) => DropdownMenuItem(
                value: lang,
                child: Text(lang),
              ))
          .toList(),
      onChanged: (value) {
        // Implement language change logic here
      },
    );
  }

  // Settings Menu (Shown on Hamburger Menu Click)
  Widget _buildSettingsMenu(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildSettingsOption(Icons.notifications, "Notification"),
          _buildSettingsOption(Icons.history, "History"),
          _buildSettingsOption(Icons.lock, "PIN"),
          _buildSettingsOption(Icons.feedback, "Send Feedback"),
        ],
      ),
    );
  }

  // Settings Option Widget
  Widget _buildSettingsOption(IconData icon, String title) {
    return ListTile(
      leading: Icon(icon, color: Colors.black),
      title: Text(title),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: () {
        // Handle settings navigation
      },
    );
  }
}
