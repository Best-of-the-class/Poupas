import 'package:flutter/material.dart';

class ProfileActions extends StatelessWidget {
  const ProfileActions({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _ActionItem(
            icon: Icons.edit,
            label: 'Editar Perfil',
            onTap: () {
            },
          ),
          _ActionItem(
            icon: Icons.lock,
            label: 'Alterar Senha',
            onTap: () {
            },
          ),
          _ActionItem(
            icon: Icons.logout,
            label: 'Sair',
            isLogout: true,
            onTap: () {
            },
          ),
        ],
      ),
    );
  }
}

class _ActionItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool isLogout;

  const _ActionItem({
    required this.icon,
    required this.label,
    required this.onTap,
    this.isLogout = false,
  });

  @override
  Widget build(BuildContext context) {
  return Container(
    margin: const EdgeInsets.only(bottom: 12),
    decoration: BoxDecoration(
      color: isLogout ? const Color(0xFFFFC5C0) : Colors.transparent,
      border: Border.all(
        color: isLogout ? const Color(0xFFE52727) : const Color(0xFF363636),
        width: 1,
      ),
      borderRadius: BorderRadius.circular(14),
    ),
    child: ListTile(
      leading: Icon(
        icon,
        color: isLogout
            ? const Color(0xFFE52727)
            : const Color(0xFF363636),
      ),
      title: Text(
        label,
        style: TextStyle(
          fontWeight: FontWeight.w500,
          color: isLogout
              ? const Color(0xFFE52727)
              : const Color(0xFF363636),
        ),
      ),
      trailing: Icon(
        Icons.arrow_forward_ios,
        size: 16,
        color: isLogout
            ? const Color(0xFFE52727)
            : const Color(0xFF363636),
      ),
      onTap: onTap,
    ),
  );
  }
}