import 'package:flutter/material.dart';

class TopBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool isSearching;
  final String searchQuery;
  final VoidCallback onSearchToggle;
  final ValueChanged<String> onQueryChanged;
  final VoidCallback onNotifications;
  final VoidCallback onProfile;

  const TopBar({
    super.key,
    required this.title,
    required this.isSearching,
    required this.searchQuery,
    required this.onSearchToggle,
    required this.onQueryChanged,
    required this.onNotifications,
    required this.onProfile,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 2,
      titleSpacing: 0,
      title: isSearching ? _buildSearchField(context) : _buildTitleRow(context),
      actions: isSearching ? null : _buildActions(),
    );
  }

  Widget _buildTitleRow(BuildContext context) {
    return Row(
      children: [
        Container(
          margin: const EdgeInsets.only(right: 12),
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.06),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(Icons.medical_services, size: 22),
        ),
        Expanded(
          child: Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }

  List<Widget> _buildActions() {
    return [
      IconButton(
        tooltip: 'Tìm kiếm',
        onPressed: onSearchToggle,
        icon: const Icon(Icons.search_sharp),
      ),
      IconButton(
        tooltip: 'Thông báo',
        onPressed: onNotifications,
        icon: const Icon(Icons.notifications_sharp),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: InkWell(
          onTap: onProfile,
          borderRadius: BorderRadius.circular(20),
          child: const CircleAvatar(
            backgroundColor: Color(0xff90caf9),
            child: Text('A'),
          ),
        ),
      )
    ];
  }

  Widget _buildSearchField(BuildContext context) {
    final controller = TextEditingController(text: searchQuery);
    // Keep controller updated when user types by using onChanged -> onQueryChanged
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: controller,
            autofocus: true,
            decoration: InputDecoration(
              hintText: 'Tìm kiếm...',
              isDense: true,
              border: InputBorder.none,
            ),
            onChanged: onQueryChanged,
          ),
        ),
        IconButton(
          tooltip: 'Clear',
          onPressed: () {
            onQueryChanged('');
            // collapse search
            onSearchToggle();
          },
          icon: const Icon(Icons.close_sharp),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
