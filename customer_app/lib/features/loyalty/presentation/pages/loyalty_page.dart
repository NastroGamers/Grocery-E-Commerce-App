import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../data/models/loyalty_model.dart';
import '../bloc/loyalty_bloc.dart';

class LoyaltyPage extends StatefulWidget {
  const LoyaltyPage({Key? key}) : super(key: key);

  @override
  State<LoyaltyPage> createState() => _LoyaltyPageState();
}

class _LoyaltyPageState extends State<LoyaltyPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    context.read<LoyaltyBloc>().add(LoadLoyaltyInfoEvent());
    context.read<LoyaltyBloc>().add(const LoadTransactionHistoryEvent());
    context.read<LoyaltyBloc>().add(LoadAvailableRewardsEvent());
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Loyalty Program'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Overview'),
            Tab(text: 'Rewards'),
          ],
        ),
      ),
      body: BlocConsumer<LoyaltyBloc, LoyaltyState>(
        listener: (context, state) {
          if (state is LoyaltyLoaded && state.redeemResponse != null) {
            _showRedeemSuccessDialog(context, state.redeemResponse!);
          }
        },
        builder: (context, state) {
          if (state is LoyaltyLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is LoyaltyLoaded) {
            return TabBarView(
              controller: _tabController,
              children: [
                _buildOverviewTab(context, state),
                _buildRewardsTab(context, state),
              ],
            );
          } else if (state is LoyaltyError) {
            return Center(child: Text(state.message));
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildOverviewTab(BuildContext context, LoyaltyLoaded state) {
    return RefreshIndicator(
      onRefresh: () async {
        context.read<LoyaltyBloc>().add(LoadLoyaltyInfoEvent());
        context.read<LoyaltyBloc>().add(const LoadTransactionHistoryEvent());
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildLoyaltyCard(context, state.loyalty),
            const SizedBox(height: 24),
            _buildTierProgressCard(context, state.loyalty),
            const SizedBox(height: 24),
            _buildTransactionHistory(context, state),
          ],
        ),
      ),
    );
  }

  Widget _buildLoyaltyCard(BuildContext context, LoyaltyModel loyalty) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: _getTierColors(loyalty.tier),
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Available Points',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    loyalty.availablePoints.toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  loyalty.tier.toUpperCase(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          const Divider(color: Colors.white30),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildStatColumn(
                'Total Earned',
                loyalty.totalPoints.toString(),
              ),
              _buildStatColumn(
                'Redeemed',
                loyalty.redeemedPoints.toString(),
              ),
              _buildStatColumn(
                'Expiring Soon',
                loyalty.expiringPoints.toString(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatColumn(String label, String value) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildTierProgressCard(BuildContext context, LoyaltyModel loyalty) {
    final progress = loyalty.pointsToNextTier != null
        ? (1 - (loyalty.pointsToNextTier! / 1000))
        : 1.0;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Tier Progress',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            if (loyalty.nextTier != null) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Current: ${loyalty.tier.toUpperCase()}'),
                  Text('Next: ${loyalty.nextTier!.toUpperCase()}'),
                ],
              ),
              const SizedBox(height: 8),
              LinearProgressIndicator(
                value: progress,
                backgroundColor: Colors.grey[200],
                minHeight: 8,
              ),
              const SizedBox(height: 8),
              Text(
                '${loyalty.pointsToNextTier} points to ${loyalty.nextTier}',
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ] else
              const Text('You\'ve reached the highest tier!'),
            const SizedBox(height: 16),
            const Text(
              'Your Benefits:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            ...loyalty.tierBenefits.map(
              (benefit) => Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Row(
                  children: [
                    const Icon(Icons.check_circle, size: 16, color: Colors.green),
                    const SizedBox(width: 8),
                    Expanded(child: Text(benefit)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTransactionHistory(BuildContext context, LoyaltyLoaded state) {
    if (state.transactions == null || state.transactions!.isEmpty) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Center(child: Text('No transaction history')),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Recent Transactions',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 12),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: state.transactions!.length,
          itemBuilder: (context, index) {
            final transaction = state.transactions![index];
            return _buildTransactionTile(transaction);
          },
        ),
      ],
    );
  }

  Widget _buildTransactionTile(PointsTransactionModel transaction) {
    final isEarned = transaction.type == 'earned' || transaction.type == 'bonus';
    final color = isEarned ? Colors.green : Colors.red;

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            isEarned ? Icons.add : Icons.remove,
            color: color,
          ),
        ),
        title: Text(transaction.description),
        subtitle: Text(
          DateFormat('MMM dd, yyyy').format(transaction.createdAt),
        ),
        trailing: Text(
          '${isEarned ? '+' : '-'}${transaction.points}',
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  Widget _buildRewardsTab(BuildContext context, LoyaltyLoaded state) {
    if (state.rewards == null || state.rewards!.isEmpty) {
      return const Center(child: Text('No rewards available'));
    }

    return RefreshIndicator(
      onRefresh: () async {
        context.read<LoyaltyBloc>().add(LoadAvailableRewardsEvent());
      },
      child: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.75,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
        ),
        itemCount: state.rewards!.length,
        itemBuilder: (context, index) {
          final reward = state.rewards![index];
          return _buildRewardCard(context, state.loyalty, reward);
        },
      ),
    );
  }

  Widget _buildRewardCard(
    BuildContext context,
    LoyaltyModel loyalty,
    RewardModel reward,
  ) {
    final canRedeem = loyalty.availablePoints >= reward.pointsRequired;

    return Card(
      child: InkWell(
        onTap: canRedeem
            ? () => _showRedeemDialog(context, reward)
            : null,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(12),
                  ),
                ),
                child: Center(
                  child: Icon(
                    _getRewardIcon(reward.rewardType),
                    size: 48,
                    color: Colors.grey[600],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    reward.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    reward.description,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${reward.pointsRequired} pts',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: canRedeem ? Colors.green : Colors.grey,
                        ),
                      ),
                      if (!canRedeem)
                        const Icon(
                          Icons.lock,
                          size: 16,
                          color: Colors.grey,
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showRedeemDialog(BuildContext context, RewardModel reward) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Redeem Reward'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(reward.title),
            const SizedBox(height: 8),
            Text(
              reward.description,
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 16),
            Text(
              'Points Required: ${reward.pointsRequired}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              context.read<LoyaltyBloc>().add(
                    RedeemRewardEvent(
                      RedeemRewardRequest(
                        rewardId: reward.rewardId,
                        points: reward.pointsRequired,
                      ),
                    ),
                  );
            },
            child: const Text('Redeem'),
          ),
        ],
      ),
    );
  }

  void _showRedeemSuccessDialog(
    BuildContext context,
    RedeemRewardResponse response,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Success!'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.check_circle, color: Colors.green, size: 64),
            const SizedBox(height: 16),
            Text(response.message),
            if (response.couponCode != null) ...[
              const SizedBox(height: 16),
              Text(
                'Coupon Code: ${response.couponCode}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  List<Color> _getTierColors(String tier) {
    switch (tier.toLowerCase()) {
      case 'platinum':
        return [const Color(0xFF2C3E50), const Color(0xFF3498DB)];
      case 'gold':
        return [const Color(0xFFF39C12), const Color(0xFFF1C40F)];
      case 'silver':
        return [const Color(0xFF95A5A6), const Color(0xFFBDC3C7)];
      default: // bronze
        return [const Color(0xFFCD7F32), const Color(0xFFD4945F)];
    }
  }

  IconData _getRewardIcon(String type) {
    switch (type) {
      case 'discount':
        return Icons.discount;
      case 'product':
        return Icons.card_giftcard;
      case 'shipping':
        return Icons.local_shipping;
      default:
        return Icons.redeem;
    }
  }
}
