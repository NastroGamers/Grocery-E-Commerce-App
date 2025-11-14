part of 'loyalty_bloc.dart';

abstract class LoyaltyEvent extends Equatable {
  const LoyaltyEvent();

  @override
  List<Object?> get props => [];
}

class LoadLoyaltyInfoEvent extends LoyaltyEvent {}

class LoadTransactionHistoryEvent extends LoyaltyEvent {
  final int page;
  final int limit;

  const LoadTransactionHistoryEvent({
    this.page = 1,
    this.limit = 20,
  });

  @override
  List<Object?> get props => [page, limit];
}

class LoadAvailableRewardsEvent extends LoyaltyEvent {}

class RedeemRewardEvent extends LoyaltyEvent {
  final RedeemRewardRequest request;

  const RedeemRewardEvent(this.request);

  @override
  List<Object?> get props => [request];
}
