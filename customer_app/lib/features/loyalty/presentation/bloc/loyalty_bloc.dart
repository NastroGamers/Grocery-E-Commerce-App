import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../data/models/loyalty_model.dart';
import '../../domain/usecases/get_loyalty_info_usecase.dart';
import '../../domain/usecases/redeem_reward_usecase.dart';
import '../../domain/repositories/loyalty_repository.dart';

part 'loyalty_event.dart';
part 'loyalty_state.dart';

class LoyaltyBloc extends Bloc<LoyaltyEvent, LoyaltyState> {
  final GetLoyaltyInfoUseCase getLoyaltyInfoUseCase;
  final RedeemRewardUseCase redeemRewardUseCase;
  final LoyaltyRepository repository;

  LoyaltyBloc({
    required this.getLoyaltyInfoUseCase,
    required this.redeemRewardUseCase,
    required this.repository,
  }) : super(LoyaltyInitial()) {
    on<LoadLoyaltyInfoEvent>(_onLoadLoyaltyInfo);
    on<LoadTransactionHistoryEvent>(_onLoadTransactionHistory);
    on<LoadAvailableRewardsEvent>(_onLoadAvailableRewards);
    on<RedeemRewardEvent>(_onRedeemReward);
  }

  Future<void> _onLoadLoyaltyInfo(
    LoadLoyaltyInfoEvent event,
    Emitter<LoyaltyState> emit,
  ) async {
    emit(LoyaltyLoading());

    try {
      final loyalty = await getLoyaltyInfoUseCase();
      emit(LoyaltyLoaded(loyalty: loyalty));
    } catch (e) {
      emit(LoyaltyError(e.toString()));
    }
  }

  Future<void> _onLoadTransactionHistory(
    LoadTransactionHistoryEvent event,
    Emitter<LoyaltyState> emit,
  ) async {
    try {
      final currentState = state;
      if (currentState is! LoyaltyLoaded) return;

      emit(currentState.copyWith(isLoadingTransactions: true));

      final transactions = await repository.getTransactionHistory(
        page: event.page,
        limit: event.limit,
      );

      emit(currentState.copyWith(
        transactions: transactions,
        isLoadingTransactions: false,
      ));
    } catch (e) {
      final currentState = state;
      if (currentState is LoyaltyLoaded) {
        emit(currentState.copyWith(isLoadingTransactions: false));
      }
    }
  }

  Future<void> _onLoadAvailableRewards(
    LoadAvailableRewardsEvent event,
    Emitter<LoyaltyState> emit,
  ) async {
    try {
      final currentState = state;
      if (currentState is! LoyaltyLoaded) return;

      emit(currentState.copyWith(isLoadingRewards: true));

      final rewards = await repository.getAvailableRewards();

      emit(currentState.copyWith(
        rewards: rewards,
        isLoadingRewards: false,
      ));
    } catch (e) {
      final currentState = state;
      if (currentState is LoyaltyLoaded) {
        emit(currentState.copyWith(isLoadingRewards: false));
      }
    }
  }

  Future<void> _onRedeemReward(
    RedeemRewardEvent event,
    Emitter<LoyaltyState> emit,
  ) async {
    try {
      final currentState = state;
      if (currentState is! LoyaltyLoaded) return;

      emit(currentState.copyWith(isRedeeming: true));

      final response = await redeemRewardUseCase(event.request);

      // Reload loyalty info to get updated points
      final updatedLoyalty = await getLoyaltyInfoUseCase();

      emit(LoyaltyLoaded(
        loyalty: updatedLoyalty,
        redeemResponse: response,
      ));
    } catch (e) {
      final currentState = state;
      if (currentState is LoyaltyLoaded) {
        emit(currentState.copyWith(
          isRedeeming: false,
          error: e.toString(),
        ));
      }
    }
  }
}
