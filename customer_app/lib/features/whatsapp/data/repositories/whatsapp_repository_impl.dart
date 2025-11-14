import 'package:url_launcher/url_launcher.dart';

import '../../domain/repositories/whatsapp_repository.dart';
import '../datasources/whatsapp_remote_datasource.dart';
import '../models/whatsapp_model.dart';

class WhatsAppRepositoryImpl implements WhatsAppRepository {
  final WhatsAppRemoteDataSource remoteDataSource;
  static const String supportPhoneNumber = '+1234567890'; // Configure this

  WhatsAppRepositoryImpl(this.remoteDataSource);

  @override
  Future<void> openSupportChat() async {
    await openChat(
      supportPhoneNumber,
      message: 'Hi, I need help with my order',
    );
  }

  @override
  Future<void> openChat(String phoneNumber, {String? message}) async {
    try {
      // Remove any non-digit characters from phone number
      final cleanPhone = phoneNumber.replaceAll(RegExp(r'[^\d+]'), '');

      // Construct WhatsApp URL
      String url = 'https://wa.me/$cleanPhone';

      if (message != null && message.isNotEmpty) {
        final encodedMessage = Uri.encodeComponent(message);
        url += '?text=$encodedMessage';
      }

      final uri = Uri.parse(url);

      if (await canLaunchUrl(uri)) {
        await launchUrl(
          uri,
          mode: LaunchMode.externalApplication,
        );
      } else {
        throw Exception('Could not open WhatsApp');
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<WhatsAppMessage> sendMessage(SendWhatsAppRequest request) async {
    try {
      return await remoteDataSource.sendMessage(request);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<WhatsAppSettings> getSettings() async {
    try {
      return await remoteDataSource.getSettings();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<WhatsAppSettings> updateSettings(WhatsAppSettings settings) async {
    try {
      return await remoteDataSource.updateSettings(settings);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<bool> verifyPhoneNumber(String phoneNumber) async {
    try {
      final response = await remoteDataSource.verifyPhoneNumber({
        'phone_number': phoneNumber,
      });
      return response['verified'] == true;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<WhatsAppMessage>> getMessageHistory({
    int page = 1,
    int limit = 20,
  }) async {
    try {
      return await remoteDataSource.getMessageHistory(page, limit);
    } catch (e) {
      rethrow;
    }
  }
}
