import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../data/models/reports_model.dart';
import 'package:dio/dio.dart';

// Events
abstract class ReportsEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadSalesReport extends ReportsEvent {
  final DateTime startDate;
  final DateTime endDate;
  final String granularity; // 'day', 'week', 'month'

  LoadSalesReport({
    required this.startDate,
    required this.endDate,
    this.granularity = 'day',
  });

  @override
  List<Object?> get props => [startDate, endDate, granularity];
}

class LoadCustomerReport extends ReportsEvent {
  final DateTime startDate;
  final DateTime endDate;

  LoadCustomerReport({required this.startDate, required this.endDate});

  @override
  List<Object?> get props => [startDate, endDate];
}

class LoadProductReport extends ReportsEvent {
  final DateTime startDate;
  final DateTime endDate;
  final String sortBy;

  LoadProductReport({
    required this.startDate,
    required this.endDate,
    this.sortBy = 'revenue',
  });

  @override
  List<Object?> get props => [startDate, endDate, sortBy];
}

class ExportReport extends ReportsEvent {
  final String reportType;
  final String format; // 'pdf', 'csv', 'excel'
  final DateTime startDate;
  final DateTime endDate;

  ExportReport({
    required this.reportType,
    required this.format,
    required this.startDate,
    required this.endDate,
  });

  @override
  List<Object?> get props => [reportType, format, startDate, endDate];
}

// States
abstract class ReportsState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ReportsInitial extends ReportsState {}

class ReportsLoading extends ReportsState {}

class SalesReportLoaded extends ReportsState {
  final SalesReportModel report;

  SalesReportLoaded(this.report);

  @override
  List<Object?> get props => [report];
}

class CustomerReportLoaded extends ReportsState {
  final CustomerReportModel report;

  CustomerReportLoaded(this.report);

  @override
  List<Object?> get props => [report];
}

class ProductReportLoaded extends ReportsState {
  final List<TopProductReportModel> products;

  ProductReportLoaded(this.products);

  @override
  List<Object?> get props => [products];
}

class ReportExported extends ReportsState {
  final String downloadUrl;

  ReportExported(this.downloadUrl);

  @override
  List<Object?> get props => [downloadUrl];
}

class ReportsError extends ReportsState {
  final String message;

  ReportsError(this.message);

  @override
  List<Object?> get props => [message];
}

// Bloc
class ReportsBloc extends Bloc<ReportsEvent, ReportsState> {
  final Dio dio;

  ReportsBloc({required this.dio}) : super(ReportsInitial()) {
    on<LoadSalesReport>(_onLoadSalesReport);
    on<LoadCustomerReport>(_onLoadCustomerReport);
    on<LoadProductReport>(_onLoadProductReport);
    on<ExportReport>(_onExportReport);
  }

  Future<void> _onLoadSalesReport(
    LoadSalesReport event,
    Emitter<ReportsState> emit,
  ) async {
    emit(ReportsLoading());

    try {
      final response = await dio.get(
        '/admin/reports/sales',
        queryParameters: {
          'startDate': event.startDate.toIso8601String(),
          'endDate': event.endDate.toIso8601String(),
          'granularity': event.granularity,
        },
      );

      final report = SalesReportModel.fromJson(response.data['data']);
      emit(SalesReportLoaded(report));
    } catch (e) {
      emit(ReportsError(e.toString()));
    }
  }

  Future<void> _onLoadCustomerReport(
    LoadCustomerReport event,
    Emitter<ReportsState> emit,
  ) async {
    emit(ReportsLoading());

    try {
      final response = await dio.get(
        '/admin/reports/customers',
        queryParameters: {
          'startDate': event.startDate.toIso8601String(),
          'endDate': event.endDate.toIso8601String(),
        },
      );

      final report = CustomerReportModel.fromJson(response.data['data']);
      emit(CustomerReportLoaded(report));
    } catch (e) {
      emit(ReportsError(e.toString()));
    }
  }

  Future<void> _onLoadProductReport(
    LoadProductReport event,
    Emitter<ReportsState> emit,
  ) async {
    emit(ReportsLoading());

    try {
      final response = await dio.get(
        '/admin/reports/products',
        queryParameters: {
          'startDate': event.startDate.toIso8601String(),
          'endDate': event.endDate.toIso8601String(),
          'sortBy': event.sortBy,
        },
      );

      final products = (response.data['data'] as List)
          .map((json) => TopProductReportModel.fromJson(json))
          .toList();

      emit(ProductReportLoaded(products));
    } catch (e) {
      emit(ReportsError(e.toString()));
    }
  }

  Future<void> _onExportReport(
    ExportReport event,
    Emitter<ReportsState> emit,
  ) async {
    try {
      final response = await dio.post(
        '/admin/reports/export',
        data: {
          'reportType': event.reportType,
          'format': event.format,
          'startDate': event.startDate.toIso8601String(),
          'endDate': event.endDate.toIso8601String(),
        },
      );

      emit(ReportExported(response.data['downloadUrl']));
    } catch (e) {
      emit(ReportsError(e.toString()));
    }
  }
}
