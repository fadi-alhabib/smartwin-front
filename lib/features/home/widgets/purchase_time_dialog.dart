import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sw/common/components/loading.dart';
import 'package:sw/common/constants/colors.dart';
import 'package:sw/features/rooms/cubit/room_cubit.dart';

class PurchaseTimeDialog extends StatelessWidget {
  final int roomId;

  PurchaseTimeDialog({super.key, required this.roomId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => RoomCubit(),
      child: BlocConsumer<RoomCubit, RoomState>(
        listener: (context, state) {
          if (state is TimePurchaseSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text("تمت العملية بنجاح!!"),
                backgroundColor: AppColors.primaryColor,
              ),
            );
            Navigator.pop(context);
          } else if (state is TimePurchaseError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Error: ${state.error}'),
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
                title: Column(
                  children: [
                    Text(
                      'تقييم الوقت المخصص لك',
                      style: TextStyle(
                        color: AppColors.primaryColor,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    // const SizedBox(height: 8),
                    // Text(
                    //   'شراء الوقت من هنا',
                    //   style: TextStyle(
                    //     color: Colors.grey[600],
                    //     fontSize: 16,
                    //   ),
                    // ),
                  ],
                ),
                content: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ..._timeOptions.map((option) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: ListTile(
                              leading: Text(
                                "${option['minutes']} دقيقة ب ${option['price']} نقطة",
                                style: TextStyle(
                                  color: AppColors.primaryColor,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              trailing: ElevatedButton(
                                onPressed: () {
                                  context.read<RoomCubit>().purchaseTime(
                                        roomId: roomId,
                                        minutes: option['minutes']!,
                                        price: option['price']!,
                                      );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.backgroundColor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    side: BorderSide(
                                      color: AppColors.primaryColor,
                                      width: 1,
                                    ),
                                  ),
                                ),
                                child: Text(
                                  "شراء",
                                  style: TextStyle(
                                    color: AppColors.primaryColor,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ),
                          )),
                      // ElevatedButton(
                      //   style: ElevatedButton.styleFrom(
                      //     backgroundColor: AppColors.primaryColor,
                      //     shape: RoundedRectangleBorder(
                      //       borderRadius: BorderRadius.circular(8),
                      //     ),
                      //     padding: const EdgeInsets.symmetric(
                      //       horizontal: 30,
                      //       vertical: 12,
                      //     ),
                      //   ),
                      //   onPressed: () {
                      //     // Handle points purchase
                      //   },
                      //   child: const Text(
                      //     'شراء النقاط من هنا',
                      //     style: TextStyle(
                      //       color: Colors.white,
                      //       fontSize: 16,
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                ),
              ),
              if (state is TimePurchaseLoading)
                Positioned.fill(
                  child: Container(
                    color: Colors.black.withOpacity(0.5),
                    child: const Loading(),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  final List<Map<String, int>> _timeOptions = [
    {'minutes': 30, 'price': 100},
    {'minutes': 60, 'price': 200},
    {'minutes': 360, 'price': 500},
  ];
}
