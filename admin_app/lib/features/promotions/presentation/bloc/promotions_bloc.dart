import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../data/models/banner_model.dart';
import 'package:dio/dio.dart';

// Events
abstract class PromotionsEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadBanners extends PromotionsEvent {
  final String? status;

  LoadBanners({this.status});

  @override
  List<Object?> get props => [status];
}

class CreateBanner extends PromotionsEvent {
  final BannerModel banner;

  CreateBanner(this.banner);

  @override
  List<Object?> get props => [banner];
}

class UpdateBanner extends PromotionsEvent {
  final String bannerId;
  final BannerModel banner;

  UpdateBanner({required this.bannerId, required this.banner});

  @override
  List<Object?> get props => [bannerId, banner];
}

class DeleteBanner extends PromotionsEvent {
  final String bannerId;

  DeleteBanner(this.bannerId);

  @override
  List<Object?> get props => [bannerId];
}

class LoadPromotions extends PromotionsEvent {
  final String? status;

  LoadPromotions({this.status});

  @override
  List<Object?> get props => [status];
}

class CreatePromotion extends PromotionsEvent {
  final PromotionModel promotion;

  CreatePromotion(this.promotion);

  @override
  List<Object?> get props => [promotion];
}

class DeactivatePromotion extends PromotionsEvent {
  final String promotionId;

  DeactivatePromotion(this.promotionId);

  @override
  List<Object?> get props => [promotionId];
}

// States
abstract class PromotionsState extends Equatable {
  @override
  List<Object?> get props => [];
}

class PromotionsInitial extends PromotionsState {}

class PromotionsLoading extends PromotionsState {}

class BannersLoaded extends PromotionsState {
  final List<BannerModel> banners;

  BannersLoaded(this.banners);

  @override
  List<Object?> get props => [banners];
}

class BannerCreated extends PromotionsState {
  final BannerModel banner;

  BannerCreated(this.banner);

  @override
  List<Object?> get props => [banner];
}

class BannerUpdated extends PromotionsState {
  final String bannerId;

  BannerUpdated(this.bannerId);

  @override
  List<Object?> get props => [bannerId];
}

class BannerDeleted extends PromotionsState {
  final String bannerId;

  BannerDeleted(this.bannerId);

  @override
  List<Object?> get props => [bannerId];
}

class PromotionsListLoaded extends PromotionsState {
  final List<PromotionModel> promotions;

  PromotionsListLoaded(this.promotions);

  @override
  List<Object?> get props => [promotions];
}

class PromotionCreated extends PromotionsState {
  final PromotionModel promotion;

  PromotionCreated(this.promotion);

  @override
  List<Object?> get props => [promotion];
}

class PromotionDeactivated extends PromotionsState {
  final String promotionId;

  PromotionDeactivated(this.promotionId);

  @override
  List<Object?> get props => [promotionId];
}

class PromotionsError extends PromotionsState {
  final String message;

  PromotionsError(this.message);

  @override
  List<Object?> get props => [message];
}

// Bloc
class PromotionsBloc extends Bloc<PromotionsEvent, PromotionsState> {
  final Dio dio;

  PromotionsBloc({required this.dio}) : super(PromotionsInitial()) {
    on<LoadBanners>(_onLoadBanners);
    on<CreateBanner>(_onCreateBanner);
    on<UpdateBanner>(_onUpdateBanner);
    on<DeleteBanner>(_onDeleteBanner);
    on<LoadPromotions>(_onLoadPromotions);
    on<CreatePromotion>(_onCreatePromotion);
    on<DeactivatePromotion>(_onDeactivatePromotion);
  }

  Future<void> _onLoadBanners(
    LoadBanners event,
    Emitter<PromotionsState> emit,
  ) async {
    emit(PromotionsLoading());

    try {
      final response = await dio.get(
        '/admin/banners',
        queryParameters: {
          if (event.status != null) 'status': event.status,
        },
      );

      final banners = (response.data['data'] as List)
          .map((json) => BannerModel.fromJson(json))
          .toList();

      emit(BannersLoaded(banners));
    } catch (e) {
      emit(PromotionsError(e.toString()));
    }
  }

  Future<void> _onCreateBanner(
    CreateBanner event,
    Emitter<PromotionsState> emit,
  ) async {
    try {
      final response = await dio.post('/admin/banners', data: event.banner.toJson());
      final banner = BannerModel.fromJson(response.data['data']);
      emit(BannerCreated(banner));
    } catch (e) {
      emit(PromotionsError(e.toString()));
    }
  }

  Future<void> _onUpdateBanner(
    UpdateBanner event,
    Emitter<PromotionsState> emit,
  ) async {
    try {
      await dio.put('/admin/banners/${event.bannerId}', data: event.banner.toJson());
      emit(BannerUpdated(event.bannerId));
    } catch (e) {
      emit(PromotionsError(e.toString()));
    }
  }

  Future<void> _onDeleteBanner(
    DeleteBanner event,
    Emitter<PromotionsState> emit,
  ) async {
    try {
      await dio.delete('/admin/banners/${event.bannerId}');
      emit(BannerDeleted(event.bannerId));
    } catch (e) {
      emit(PromotionsError(e.toString()));
    }
  }

  Future<void> _onLoadPromotions(
    LoadPromotions event,
    Emitter<PromotionsState> emit,
  ) async {
    emit(PromotionsLoading());

    try {
      final response = await dio.get(
        '/admin/promotions',
        queryParameters: {
          if (event.status != null) 'status': event.status,
        },
      );

      final promotions = (response.data['data'] as List)
          .map((json) => PromotionModel.fromJson(json))
          .toList();

      emit(PromotionsListLoaded(promotions));
    } catch (e) {
      emit(PromotionsError(e.toString()));
    }
  }

  Future<void> _onCreatePromotion(
    CreatePromotion event,
    Emitter<PromotionsState> emit,
  ) async {
    try {
      final response = await dio.post('/admin/promotions', data: event.promotion.toJson());
      final promotion = PromotionModel.fromJson(response.data['data']);
      emit(PromotionCreated(promotion));
    } catch (e) {
      emit(PromotionsError(e.toString()));
    }
  }

  Future<void> _onDeactivatePromotion(
    DeactivatePromotion event,
    Emitter<PromotionsState> emit,
  ) async {
    try {
      await dio.put('/admin/promotions/${event.promotionId}/deactivate');
      emit(PromotionDeactivated(event.promotionId));
    } catch (e) {
      emit(PromotionsError(e.toString()));
    }
  }
}
