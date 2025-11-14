import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/whatsapp_model.dart';
import '../bloc/whatsapp_bloc.dart';

class WhatsAppSettingsPage extends StatefulWidget {
  const WhatsAppSettingsPage({Key? key}) : super(key: key);

  @override
  State<WhatsAppSettingsPage> createState() => _WhatsAppSettingsPageState();
}

class _WhatsAppSettingsPageState extends State<WhatsAppSettingsPage> {
  @override
  void initState() {
    super.initState();
    context.read<WhatsAppBloc>().add(LoadWhatsAppSettingsEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('WhatsApp Notifications'),
      ),
      body: BlocConsumer<WhatsAppBloc, WhatsAppState>(
        listener: (context, state) {
          if (state is WhatsAppSettingsLoaded && state.message != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message!),
                backgroundColor: Colors.green,
              ),
            );
          } else if (state is WhatsAppError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is WhatsAppLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is WhatsAppSettingsLoaded) {
            return _buildSettingsForm(context, state.settings);
          } else if (state is WhatsAppError) {
            return Center(child: Text(state.message));
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildSettingsForm(BuildContext context, WhatsAppSettings settings) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Info Card
          Card(
            color: const Color(0xFF25D366).withOpacity(0.1),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Icon(
                    Icons.whatsapp,
                    size: 48,
                    color: const Color(0xFF25D366),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'WhatsApp Notifications',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Get important updates directly on WhatsApp',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 8),
                        if (settings.isVerified)
                          Row(
                            children: const [
                              Icon(
                                Icons.verified,
                                size: 16,
                                color: Colors.green,
                              ),
                              SizedBox(width: 4),
                              Text(
                                'Phone Verified',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.green,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          )
                        else
                          TextButton(
                            onPressed: () {
                              // Implement phone verification
                            },
                            child: const Text('Verify Phone Number'),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Settings Toggles
          const Text(
            'Notification Preferences',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),

          _buildSettingTile(
            context,
            title: 'Order Updates',
            subtitle: 'Receive updates about your orders',
            icon: Icons.shopping_bag,
            value: settings.orderUpdatesEnabled,
            onChanged: (value) {
              _updateSettings(
                context,
                settings.copyWith(orderUpdatesEnabled: value),
              );
            },
          ),

          _buildSettingTile(
            context,
            title: 'Support Messages',
            subtitle: 'Receive responses from customer support',
            icon: Icons.support_agent,
            value: settings.supportMessagesEnabled,
            onChanged: (value) {
              _updateSettings(
                context,
                settings.copyWith(supportMessagesEnabled: value),
              );
            },
          ),

          _buildSettingTile(
            context,
            title: 'Promotional Messages',
            subtitle: 'Receive offers and promotional updates',
            icon: Icons.local_offer,
            value: settings.promotionalMessagesEnabled,
            onChanged: (value) {
              _updateSettings(
                context,
                settings.copyWith(promotionalMessagesEnabled: value),
              );
            },
          ),

          const SizedBox(height: 24),

          // Contact Support Button
          Card(
            child: ListTile(
              leading: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: const Color(0xFF25D366).withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.chat,
                  color: Color(0xFF25D366),
                ),
              ),
              title: const Text('Chat with Support'),
              subtitle: const Text('Get help via WhatsApp'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                context.read<WhatsAppBloc>().add(
                      const OpenWhatsAppChatEvent(
                        message: 'Hi, I need help',
                      ),
                    );
              },
            ),
          ),

          const SizedBox(height: 16),

          // Information
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.info_outline, color: Colors.blue, size: 20),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Important Information',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        '• Standard messaging rates may apply\n'
                        '• You can opt out anytime by disabling notifications\n'
                        '• We respect your privacy and will never share your number',
                        style: TextStyle(fontSize: 12, color: Colors.black87),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingTile(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required bool value,
    required Function(bool) onChanged,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: SwitchListTile(
        secondary: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: Theme.of(context).primaryColor),
        ),
        title: Text(title),
        subtitle: Text(subtitle),
        value: value,
        onChanged: onChanged,
      ),
    );
  }

  void _updateSettings(BuildContext context, WhatsAppSettings settings) {
    context.read<WhatsAppBloc>().add(
          UpdateWhatsAppSettingsEvent(settings),
        );
  }
}
