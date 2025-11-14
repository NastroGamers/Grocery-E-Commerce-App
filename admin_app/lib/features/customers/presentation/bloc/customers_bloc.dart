import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../data/models/customer_model.dart';
import 'package:dio/dio.dart';

// Events
abstract class CustomersEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadCustomers extends CustomersEvent {
  final int page;
  final String? status;
  final String? searchQuery;
  final String? sortBy;

  LoadCustomers({
    this.page = 1,
    this.status,
    this.searchQuery,
    this.sortBy,
  });

  @override
  List<Object?> get props => [page, status, searchQuery, sortBy];
}

class LoadCustomerDetails extends CustomersEvent {
  final String customerId;

  LoadCustomerDetails(this.customerId);

  @override
  List<Object?> get props => [customerId];
}

class UpdateCustomerStatus extends CustomersEvent {
  final String customerId;
  final String status;

  UpdateCustomerStatus({required this.customerId, required this.status});

  @override
  List<Object?> get props => [customerId, status];
}

class SearchCustomers extends CustomersEvent {
  final String query;

  SearchCustomers(this.query);

  @override
  List<Object?> get props => [query];
}

// States
abstract class CustomersState extends Equatable {
  @override
  List<Object?> get props => [];
}

class CustomersInitial extends CustomersState {}

class CustomersLoading extends CustomersState {}

class CustomersLoaded extends CustomersState {
  final List<CustomerModel> customers;
  final bool hasMore;
  final int currentPage;

  CustomersLoaded({
    required this.customers,
    this.hasMore = true,
    this.currentPage = 1,
  });

  @override
  List<Object?> get props => [customers, hasMore, currentPage];
}

class CustomerDetailsLoaded extends CustomersState {
  final CustomerModel customer;

  CustomerDetailsLoaded(this.customer);

  @override
  List<Object?> get props => [customer];
}

class CustomerStatusUpdated extends CustomersState {
  final String customerId;
  final String status;

  CustomerStatusUpdated({required this.customerId, required this.status});

  @override
  List<Object?> get props => [customerId, status];
}

class CustomersError extends CustomersState {
  final String message;

  CustomersError(this.message);

  @override
  List<Object?> get props => [message];
}

// Bloc
class CustomersBloc extends Bloc<CustomersEvent, CustomersState> {
  final Dio dio;

  CustomersBloc({required this.dio}) : super(CustomersInitial()) {
    on<LoadCustomers>(_onLoadCustomers);
    on<LoadCustomerDetails>(_onLoadCustomerDetails);
    on<UpdateCustomerStatus>(_onUpdateCustomerStatus);
    on<SearchCustomers>(_onSearchCustomers);
  }

  Future<void> _onLoadCustomers(
    LoadCustomers event,
    Emitter<CustomersState> emit,
  ) async {
    emit(CustomersLoading());

    try {
      final response = await dio.get(
        '/admin/customers',
        queryParameters: {
          'page': event.page,
          'limit': 20,
          if (event.status != null) 'status': event.status,
          if (event.searchQuery != null) 'search': event.searchQuery,
          if (event.sortBy != null) 'sortBy': event.sortBy,
        },
      );

      final customers = (response.data['data'] as List)
          .map((json) => CustomerModel.fromJson(json))
          .toList();

      emit(CustomersLoaded(
        customers: customers,
        hasMore: customers.length >= 20,
        currentPage: event.page,
      ));
    } catch (e) {
      emit(CustomersError(e.toString()));
    }
  }

  Future<void> _onLoadCustomerDetails(
    LoadCustomerDetails event,
    Emitter<CustomersState> emit,
  ) async {
    emit(CustomersLoading());

    try {
      final response = await dio.get('/admin/customers/${event.customerId}');
      final customer = CustomerModel.fromJson(response.data['data']);
      emit(CustomerDetailsLoaded(customer));
    } catch (e) {
      emit(CustomersError(e.toString()));
    }
  }

  Future<void> _onUpdateCustomerStatus(
    UpdateCustomerStatus event,
    Emitter<CustomersState> emit,
  ) async {
    try {
      await dio.put(
        '/admin/customers/${event.customerId}/status',
        data: {'status': event.status},
      );

      emit(CustomerStatusUpdated(
        customerId: event.customerId,
        status: event.status,
      ));
    } catch (e) {
      emit(CustomersError(e.toString()));
    }
  }

  Future<void> _onSearchCustomers(
    SearchCustomers event,
    Emitter<CustomersState> emit,
  ) async {
    emit(CustomersLoading());

    try {
      final response = await dio.get(
        '/admin/customers/search',
        queryParameters: {'q': event.query},
      );

      final customers = (response.data['data'] as List)
          .map((json) => CustomerModel.fromJson(json))
          .toList();

      emit(CustomersLoaded(customers: customers, hasMore: false));
    } catch (e) {
      emit(CustomersError(e.toString()));
    }
  }
}
