import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../data/models/vendor_dashboard_model.dart';
import 'package:dio/dio.dart';

// Events
abstract class VendorDashboardEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadVendorDashboard extends VendorDashboardEvent {}

class LoadVendorProducts extends VendorDashboardEvent {
  final int page;
  final String? status;

  LoadVendorProducts({this.page = 1, this.status});

  @override
  List<Object?> get props => [page, status];
}

class AddProduct extends VendorDashboardEvent {
  final VendorProductModel product;

  AddProduct(this.product);

  @override
  List<Object?> get props => [product];
}

class UpdateProduct extends VendorDashboardEvent {
  final String productId;
  final VendorProductModel product;

  UpdateProduct({required this.productId, required this.product});

  @override
  List<Object?> get props => [productId, product];
}

class DeleteProduct extends VendorDashboardEvent {
  final String productId;

  DeleteProduct(this.productId);

  @override
  List<Object?> get props => [productId];
}

class UpdateStock extends VendorDashboardEvent {
  final String productId;
  final int stock;

  UpdateStock({required this.productId, required this.stock});

  @override
  List<Object?> get props => [productId, stock];
}

class LoadVendorOrders extends VendorDashboardEvent {
  final int page;
  final String? status;

  LoadVendorOrders({this.page = 1, this.status});

  @override
  List<Object?> get props => [page, status];
}

class UpdateOrderStatus extends VendorDashboardEvent {
  final String orderId;
  final String status;

  UpdateOrderStatus({required this.orderId, required this.status});

  @override
  List<Object?> get props => [orderId, status];
}

// States
abstract class VendorDashboardState extends Equatable {
  @override
  List<Object?> get props => [];
}

class VendorDashboardInitial extends VendorDashboardState {}

class VendorDashboardLoading extends VendorDashboardState {}

class DashboardLoaded extends VendorDashboardState {
  final VendorDashboardModel dashboard;

  DashboardLoaded(this.dashboard);

  @override
  List<Object?> get props => [dashboard];
}

class VendorProductsLoaded extends VendorDashboardState {
  final List<VendorProductModel> products;
  final bool hasMore;

  VendorProductsLoaded({required this.products, this.hasMore = true});

  @override
  List<Object?> get props => [products, hasMore];
}

class ProductAdded extends VendorDashboardState {
  final VendorProductModel product;

  ProductAdded(this.product);

  @override
  List<Object?> get props => [product];
}

class ProductUpdated extends VendorDashboardState {
  final String productId;

  ProductUpdated(this.productId);

  @override
  List<Object?> get props => [productId];
}

class ProductDeleted extends VendorDashboardState {
  final String productId;

  ProductDeleted(this.productId);

  @override
  List<Object?> get props => [productId];
}

class StockUpdated extends VendorDashboardState {
  final String productId;
  final int stock;

  StockUpdated({required this.productId, required this.stock});

  @override
  List<Object?> get props => [productId, stock];
}

class VendorOrdersLoaded extends VendorDashboardState {
  final List<VendorOrderModel> orders;
  final bool hasMore;

  VendorOrdersLoaded({required this.orders, this.hasMore = true});

  @override
  List<Object?> get props => [orders, hasMore];
}

class OrderStatusUpdated extends VendorDashboardState {
  final String orderId;
  final String status;

  OrderStatusUpdated({required this.orderId, required this.status});

  @override
  List<Object?> get props => [orderId, status];
}

class VendorDashboardError extends VendorDashboardState {
  final String message;

  VendorDashboardError(this.message);

  @override
  List<Object?> get props => [message];
}

// Bloc
class VendorDashboardBloc extends Bloc<VendorDashboardEvent, VendorDashboardState> {
  final Dio dio;

  VendorDashboardBloc({required this.dio}) : super(VendorDashboardInitial()) {
    on<LoadVendorDashboard>(_onLoadDashboard);
    on<LoadVendorProducts>(_onLoadProducts);
    on<AddProduct>(_onAddProduct);
    on<UpdateProduct>(_onUpdateProduct);
    on<DeleteProduct>(_onDeleteProduct);
    on<UpdateStock>(_onUpdateStock);
    on<LoadVendorOrders>(_onLoadOrders);
    on<UpdateOrderStatus>(_onUpdateOrderStatus);
  }

  Future<void> _onLoadDashboard(
    LoadVendorDashboard event,
    Emitter<VendorDashboardState> emit,
  ) async {
    emit(VendorDashboardLoading());

    try {
      final response = await dio.get('/vendor/dashboard');
      final dashboard = VendorDashboardModel.fromJson(response.data['data']);
      emit(DashboardLoaded(dashboard));
    } catch (e) {
      emit(VendorDashboardError(e.toString()));
    }
  }

  Future<void> _onLoadProducts(
    LoadVendorProducts event,
    Emitter<VendorDashboardState> emit,
  ) async {
    emit(VendorDashboardLoading());

    try {
      final response = await dio.get(
        '/vendor/products',
        queryParameters: {
          'page': event.page,
          'limit': 20,
          if (event.status != null) 'status': event.status,
        },
      );

      final products = (response.data['data'] as List)
          .map((json) => VendorProductModel.fromJson(json))
          .toList();

      emit(VendorProductsLoaded(products: products, hasMore: products.length >= 20));
    } catch (e) {
      emit(VendorDashboardError(e.toString()));
    }
  }

  Future<void> _onAddProduct(
    AddProduct event,
    Emitter<VendorDashboardState> emit,
  ) async {
    try {
      final response = await dio.post('/vendor/products', data: event.product.toJson());
      final product = VendorProductModel.fromJson(response.data['data']);
      emit(ProductAdded(product));
    } catch (e) {
      emit(VendorDashboardError(e.toString()));
    }
  }

  Future<void> _onUpdateProduct(
    UpdateProduct event,
    Emitter<VendorDashboardState> emit,
  ) async {
    try {
      await dio.put('/vendor/products/${event.productId}', data: event.product.toJson());
      emit(ProductUpdated(event.productId));
    } catch (e) {
      emit(VendorDashboardError(e.toString()));
    }
  }

  Future<void> _onDeleteProduct(
    DeleteProduct event,
    Emitter<VendorDashboardState> emit,
  ) async {
    try {
      await dio.delete('/vendor/products/${event.productId}');
      emit(ProductDeleted(event.productId));
    } catch (e) {
      emit(VendorDashboardError(e.toString()));
    }
  }

  Future<void> _onUpdateStock(
    UpdateStock event,
    Emitter<VendorDashboardState> emit,
  ) async {
    try {
      await dio.put(
        '/vendor/products/${event.productId}/stock',
        data: {'stock': event.stock},
      );
      emit(StockUpdated(productId: event.productId, stock: event.stock));
    } catch (e) {
      emit(VendorDashboardError(e.toString()));
    }
  }

  Future<void> _onLoadOrders(
    LoadVendorOrders event,
    Emitter<VendorDashboardState> emit,
  ) async {
    emit(VendorDashboardLoading());

    try {
      final response = await dio.get(
        '/vendor/orders',
        queryParameters: {
          'page': event.page,
          'limit': 20,
          if (event.status != null) 'status': event.status,
        },
      );

      final orders = (response.data['data'] as List)
          .map((json) => VendorOrderModel.fromJson(json))
          .toList();

      emit(VendorOrdersLoaded(orders: orders, hasMore: orders.length >= 20));
    } catch (e) {
      emit(VendorDashboardError(e.toString()));
    }
  }

  Future<void> _onUpdateOrderStatus(
    UpdateOrderStatus event,
    Emitter<VendorDashboardState> emit,
  ) async {
    try {
      await dio.put(
        '/vendor/orders/${event.orderId}/status',
        data: {'status': event.status},
      );
      emit(OrderStatusUpdated(orderId: event.orderId, status: event.status));
    } catch (e) {
      emit(VendorDashboardError(e.toString()));
    }
  }
}
