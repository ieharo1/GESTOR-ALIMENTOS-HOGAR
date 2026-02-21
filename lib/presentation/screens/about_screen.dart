import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              colorScheme.primary.withAlpha(30),
              colorScheme.surface,
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                const SizedBox(height: 20),
                _buildHeader(theme, colorScheme),
                const SizedBox(height: 40),
                _buildDeveloperCard(theme, colorScheme),
                const SizedBox(height: 32),
                _buildSocialLinks(colorScheme),
                const SizedBox(height: 40),
                _buildFooter(theme, colorScheme),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(ThemeData theme, ColorScheme colorScheme) {
    return Column(
      children: [
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                colorScheme.primary,
                colorScheme.secondary,
              ],
            ),
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: colorScheme.primary.withAlpha(80),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: const Icon(
            Icons.info_outline,
            color: Colors.white,
            size: 50,
          ),
        ),
        const SizedBox(height: 24),
        Text(
          'Acerca de',
          style: theme.textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Gestor de Alimentos Hogar',
          style: theme.textTheme.titleMedium?.copyWith(
            color: colorScheme.primary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildDeveloperCard(ThemeData theme, ColorScheme colorScheme) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withAlpha(20),
            blurRadius: 20,
            offset: const Offset(0, 5),
          ),
        ],
        border: Border.all(
          color: colorScheme.primary.withAlpha(30),
        ),
      ),
      child: Column(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.purple.shade400,
                  Colors.pink.shade300,
                ],
              ),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.person,
              color: Colors.white,
              size: 40,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Isaac Esteban Haro Torres',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: colorScheme.primaryContainer.withAlpha(100),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              'Ingeniero en Sistemas · Full Stack · Automatizacion · Data',
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.primary,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSocialLinks(ColorScheme colorScheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Contacto',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: colorScheme.onSurface,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 20),
        _SocialButton(
          label: 'WhatsApp',
          subtitle: '098805517',
          color: const Color(0xFF25D366),
          iconWidget: Container(
            width: 28,
            height: 28,
            decoration: const BoxDecoration(
              color: Color(0xFF25D366),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.chat, color: Colors.white, size: 18),
          ),
          onTap: () => _launchUrl('https://wa.me/59398805517'),
        ),
        const SizedBox(height: 12),
        _SocialButton(
          label: 'GitHub',
          subtitle: 'ieharo1',
          color: Colors.black87,
          iconWidget: Container(
            width: 28,
            height: 28,
            decoration: const BoxDecoration(
              color: Color(0xFF333333),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.code, color: Colors.white, size: 18),
          ),
          onTap: () => _launchUrl('https://github.com/ieharo1'),
        ),
        const SizedBox(height: 12),
        _SocialButton(
          label: 'Email',
          subtitle: 'zackharo1@gmail.com',
          color: Colors.red.shade600,
          iconWidget: Container(
            width: 28,
            height: 28,
            decoration: const BoxDecoration(
              color: Color(0xFFEA4335),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.email, color: Colors.white, size: 18),
          ),
          onTap: () => _launchUrl('mailto:zackharo1@gmail.com'),
        ),
        const SizedBox(height: 12),
        _SocialButton(
          label: 'Portafolio',
          subtitle: 'ieharo1.github.io',
          color: colorScheme.primary,
          iconWidget: Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: colorScheme.primary,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.language, color: Colors.white, size: 18),
          ),
          onTap: () => _launchUrl('https://ieharo1.github.io/portafolio-isaac.haro/'),
        ),
      ],
    );
  }

  Widget _buildFooter(ThemeData theme, ColorScheme colorScheme) {
    return Column(
      children: [
        Divider(color: colorScheme.outline.withAlpha(50)),
        const SizedBox(height: 16),
        Text(
          'Desarrollado por Isaac Esteban Haro Torres',
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.copyright,
              size: 16,
              color: colorScheme.onSurfaceVariant,
            ),
            const SizedBox(width: 4),
            Text(
              '2026 Isaac Esteban Haro Torres',
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          'Todos los derechos reservados.',
          style: theme.textTheme.bodySmall?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

class _SocialButton extends StatelessWidget {
  final String label;
  final String subtitle;
  final Color color;
  final Widget iconWidget;
  final VoidCallback onTap;

  const _SocialButton({
    required this.label,
    required this.subtitle,
    required this.color,
    required this.iconWidget,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: color.withAlpha(50),
            ),
            boxShadow: [
              BoxShadow(
                color: color.withAlpha(20),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: color.withAlpha(20),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: iconWidget,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: color,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
