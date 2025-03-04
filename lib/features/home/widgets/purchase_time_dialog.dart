import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sw/common/components/loading.dart';
import 'package:sw/common/constants/colors.dart';
import 'package:sw/features/rooms/cubit/room_cubit.dart';
// Adjust the import as needed

class PurchaseTimeDialog extends StatelessWidget {
  final int roomId;

  const PurchaseTimeDialog({super.key, required this.roomId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => RoomCubit(),
      child: BlocConsumer<RoomCubit, RoomState>(
        listener: (context, state) {
          if (state is TimePurchaseSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text(
                  "تمت العملية بنجاح!!",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                backgroundColor: AppColors.primaryColor,
              ),
            );
            Navigator.pop(context);
          } else if (state is TimePurchaseError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Error: ${state.error}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                backgroundColor: Colors.redAccent,
              ),
            );
          }
        },
        builder: (context, state) {
          return Stack(
            children: [
              AlertDialog(
                backgroundColor: AppColors.backgroundColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                title: Text(
                  'لقد انتهى وقت اللعب يرجى شراء الوقت للإكمال',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                content: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 20),
                      // FIXME::
                      Row(
                        children: [
                          Expanded(
                              child: _buildTimeCard(context,
                                  minutes: 20, price: 30)),
                          const SizedBox(width: 8),
                          Expanded(
                              child: _buildTimeCard(context,
                                  minutes: 60, price: 50)),
                          const SizedBox(width: 8),
                          Expanded(
                              child: _buildTimeCard(context,
                                  minutes: 120, price: 100)),
                        ],
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
              // Display a loading overlay when in loading state.
              if (state is TimePurchaseLoading)
                Positioned.fill(
                  child: Container(
                      color: Colors.black.withOpacity(0.5), child: Loading()),
                ),
            ],
          );
        },
      ),
    );
  }

  /// Builds a card for a specific time/price option with a fixed size.
  Widget _buildTimeCard(BuildContext context,
      {required int minutes, required int price}) {
    return Card(
      color: AppColors.backgroundColor,
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: AppColors.primaryColor, width: 1.5),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          context.read<RoomCubit>().purchaseTime(
                roomId: roomId,
                minutes: minutes,
                price: price,
              );
        },
        child: SizedBox(
          height: 120,
          child: Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '$minutes',
                  style: TextStyle(
                    color: AppColors.primaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  'دقيقة',
                  style: TextStyle(
                    color: AppColors.primaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Text(
                  '$price نقطة',
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
