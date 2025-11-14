import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import '../models/qr_payment_model.dart';

part 'qr_payment_remote_datasource.g.dart';

@RestApi()
abstract class QRPaymentRemoteDataSource {
  factory QRPaymentRemoteDataSource(Dio dio, {String baseUrl}) =
      _QRPaymentRemoteDataSource;

  @POST('/payments/qr/generate')
  Future<QRPaymentResponse> generateQRCode(
    @Body() GenerateQRRequest request,
  );

  @POST('/payments/qr/verify')
  Future<QRPaymentModel> verifyPayment(
    @Body() VerifyQRPaymentRequest request,
  );

  @GET('/payments/qr/{paymentId}/status')
  Future<QRPaymentModel> getPaymentStatus(
    @Path('paymentId') String paymentId,
  );
}
