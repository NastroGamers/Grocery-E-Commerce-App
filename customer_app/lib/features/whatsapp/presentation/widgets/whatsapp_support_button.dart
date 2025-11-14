import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/whatsapp_bloc.dart';

class WhatsAppSupportButton extends StatelessWidget {
  final String? phoneNumber;
  final String? message;
  final String? label;
  final IconData icon;
  final Color? backgroundColor;
  final Color? textColor;

  const WhatsAppSupportButton({
    Key? key,
    this.phoneNumber,
    this.message,
    this.label,
    this.icon = Icons.message,
    this.backgroundColor,
    this.textColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<WhatsAppBloc, WhatsAppState>(
      listener: (context, state) {
        if (state is WhatsAppError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      child: ElevatedButton.icon(
        onPressed: () {
          context.read<WhatsAppBloc>().add(
                OpenWhatsAppChatEvent(
                  phoneNumber: phoneNumber,
                  message: message,
                ),
              );
        },
        icon: Icon(icon, color: textColor ?? Colors.white),
        label: Text(
          label ?? 'Contact Support',
          style: TextStyle(color: textColor ?? Colors.white),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor ?? const Color(0xFF25D366),
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 12,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
      ),
    );
  }
}

class WhatsAppFloatingButton extends StatelessWidget {
  final String? phoneNumber;
  final String? message;

  const WhatsAppFloatingButton({
    Key? key,
    this.phoneNumber,
    this.message,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<WhatsAppBloc, WhatsAppState>(
      listener: (context, state) {
        if (state is WhatsAppError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      child: FloatingActionButton(
        onPressed: () {
          context.read<WhatsAppBloc>().add(
                OpenWhatsAppChatEvent(
                  phoneNumber: phoneNumber,
                  message: message,
                ),
              );
        },
        backgroundColor: const Color(0xFF25D366),
        child: const Icon(Icons.whatsapp, color: Colors.white),
      ),
    );
  }
}
