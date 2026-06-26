import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "../../../../core/theme/app_theme.dart";
import "../../../auth/presentation/bloc/auth_bloc.dart";
import "../../../auth/presentation/bloc/auth_event.dart";
import "../../../auth/presentation/bloc/auth_state.dart";

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final authState = context.watch<AuthBloc>().state;
    final user = authState is Authenticated ? authState.user : null;

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            backgroundColor: AppTheme.surfaceContainerLow,
            title: const Text("Perfil",
              style: TextStyle(color: AppTheme.onSurface, fontFamily: "Poppins", fontWeight: FontWeight.w600)),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList.list(children: [
              // Profile Header
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppTheme.surfaceContainer,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppTheme.outlineVariant.withValues(alpha: 0.3)),
                ),
                child: Column(children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: AppTheme.primaryContainer,
                    child: Text(
                      (user?.name ?? "U").substring(0, 1).toUpperCase(),
                      style: const TextStyle(color: AppTheme.primary, fontSize: 32, fontWeight: FontWeight.w600),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(user?.name ?? "Usuario",
                    style: const TextStyle(color: AppTheme.onSurface, fontSize: 20, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 4),
                  Text(user?.email ?? "",
                    style: const TextStyle(color: AppTheme.onSurfaceVariant, fontSize: 14)),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppTheme.secondaryContainer.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      user?.userType == "PYME" ? "Mipyme" : "Individual",
                      style: const TextStyle(color: AppTheme.secondary, fontSize: 12, fontWeight: FontWeight.w600),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text("RNC/Cédula: ${user?.rncCedula ?? "—"}",
                    style: const TextStyle(color: AppTheme.onSurfaceVariant, fontSize: 13)),
                ]),
              ),
              const SizedBox(height: 20),

              // Account Config
              _buildSection("Configuración de Cuenta", [
                _buildTile(Icons.business, "Datos del Negocio", () {}),
                _buildTile(Icons.payment, "Métodos de Pago", () {}),
                _buildTile(Icons.group, "Gestión de Equipo", () {}),
              ]),
              const SizedBox(height: 16),

              // Security
              _buildSection("Seguridad y Preferencias", [
                _buildSwitchTile(Icons.fingerprint, "Inicio biométrico", false, (_) {}),
                _buildSwitchTile(Icons.dark_mode, "Modo Oscuro", true, (_) {}),
                _buildTile(Icons.help_outline, "Ayuda y Soporte", () {}),
              ]),
              const SizedBox(height: 16),

              // Premium
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppTheme.surfaceContainer,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppTheme.secondaryContainer.withValues(alpha: 0.3)),
                ),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Row(children: [
                    const Icon(Icons.star, color: AppTheme.secondary, size: 20),
                    const SizedBox(width: 8),
                    const Text("Plan Premium", style: TextStyle(color: AppTheme.onSurface, fontSize: 16, fontWeight: FontWeight.w600)),
                  ]),
                  const SizedBox(height: 12),
                  _buildPremiumFeature("Generación ilimitada de NCF"),
                  _buildPremiumFeature("Acceso prioritario a API"),
                  _buildPremiumFeature("Análisis tributario avanzado"),
                ]),
              ),
              const SizedBox(height: 20),

              // Sign Out
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () => context.read<AuthBloc>().add(LogoutRequested()),
                  icon: const Icon(Icons.logout, color: AppTheme.error),
                  label: const Text("Cerrar Sesión", style: TextStyle(color: AppTheme.error)),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppTheme.error),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
              const SizedBox(height: 32),
            ]),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surfaceContainer,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.outlineVariant.withValues(alpha: 0.3)),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Text(title, style: const TextStyle(color: AppTheme.onSurfaceVariant, fontSize: 12, fontWeight: FontWeight.w600)),
        ),
        ...children,
      ]),
    );
  }

  Widget _buildTile(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: AppTheme.onSurfaceVariant, size: 22),
      title: Text(title, style: const TextStyle(color: AppTheme.onSurface, fontSize: 14)),
      trailing: const Icon(Icons.chevron_right, color: AppTheme.onSurfaceVariant, size: 20),
      onTap: onTap,
    );
  }

  Widget _buildSwitchTile(IconData icon, String title, bool value, ValueChanged<bool> onChanged) {
    return SwitchListTile(
      secondary: Icon(icon, color: AppTheme.onSurfaceVariant, size: 22),
      title: Text(title, style: const TextStyle(color: AppTheme.onSurface, fontSize: 14)),
      value: value,
      onChanged: onChanged,
      activeColor: AppTheme.secondaryContainer,
    );
  }

  Widget _buildPremiumFeature(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(children: [
        const Icon(Icons.check_circle, color: AppTheme.secondary, size: 16),
        const SizedBox(width: 8),
        Expanded(child: Text(text, style: const TextStyle(color: AppTheme.onSurfaceVariant, fontSize: 13))),
      ]),
    );
  }
}
