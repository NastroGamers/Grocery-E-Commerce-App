import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import '../models/whatsapp_model.dart';

part 'whatsapp_remote_datasource.g.dart';

@RestApi()
abstract class WhatsAppRemoteDataSource {
  factory WhatsAppRemoteDataSource(Dio dio, {String baseUrl}) =
      _WhatsAppRemoteDataSource;

  @POST('/whatsapp/send')
  Future<WhatsAppMessage> sendMessage(
    @Body() SendWhatsAppRequest request,
  );

  @GET('/whatsapp/settings')
  Future<WhatsAppSettings> getSettings();

  @PUT('/whatsapp/settings')
  Future<WhatsAppSettings> updateSettings(
    @Body() WhatsAppSettings settings,
  );

  @POST('/whatsapp/verify')
  Future<Map<String, dynamic>> verifyPhoneNumber(
    @Body() Map<String, String> data,
  );

  @GET('/whatsapp/messages')
  Future<List<WhatsAppMessage>> getMessageHistory(
    @Query('page') int page,
    @Query('limit') int limit,
  );
}
