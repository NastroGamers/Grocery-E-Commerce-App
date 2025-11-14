part of 'loyalty_bloc.dart';

abstract class LoyaltyState extends Equatable {
  const LoyaltyState();

  @override
  List<Object?> get props => [];
}

class LoyaltyInitial extends LoyaltyState {}

class LoyaltyLoading extends LoyaltyState {}

class LoyaltyLoaded extends LoyaltyState {
  final LoyaltyModel loyalty;
  final List<PointsTransactionModel>? transactions;
  final List<RewardModel>? rewards;
  final RedeemRewardResponse? redeemResponse;
  final bool isLoadingTransactions;
  final bool isLoadingRewards;
  final bool isRedeeming;
  final String? error;

  const LoyaltyLoaded({
    required this.loyalty,
    this.transactions,
    this.rewards,
    this.redeemResponse,
    this.isLoadingTransactions = false,
    this.isLoadingRewards = false,
    this.isRedeeming = false,
    this.error,
  });

  LoyaltyLoaded copyWith({
    LoyaltyModel? loyalty,
    List<PointsTransactionModel>? transactions,
    List<RewardModel>? rewards,
    RedeemRewardResponse? redeemResponse,
    bool? isLoadingTransactions,
    bool? isLoadingRewards,
    bool? isRedeeming,
    String? error,
  }) {
    return LoyaltyLoaded(
      loyalty: loyalty ?? this.loyalty,
      transactions: transactions ?? this.transactions,
      rewards: rewards ?? this.rewards,
      redeemResponse: redeemResponse ?? this.redeemResponse,
      isLoadingTransactions: isLoadingTransactions ?? this.isLoadingTransactions,
      isLoadingRewards: isLoadingRewards ?? this.isLoadingRewards,
      isRedeeming: isRedeeming ?? this.isRedeeming,
      error: error,
    );
  }

  @override
  List<Object?> get props => [
        loyalty,
        transactions,
        rewards,
        redeemResponse,
        isLoadingTransactions,
        isLoadingRewards,
        isRedeeming,
        error,
      ];
}

class LoyaltyError extends LoyaltyState {
  final String message;

  const LoyaltyError(this.message);

  @override
  List<Object?> get props => [message];
}
