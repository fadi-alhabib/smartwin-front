import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lottie/lottie.dart';
import 'package:sw/common/components/loading.dart';
import 'package:sw/common/constants/colors.dart';
import 'package:sw/features/rooms/cubit/room_cubit.dart';
import 'package:sw/features/rooms/models/room_model.dart';
import 'package:sw/features/rooms/widgets/create_room_form.dart';
import 'package:sw/features/rooms/widgets/room_view.dart';

class RoomScreen extends HookWidget {
  const RoomScreen({super.key, this.roomId});
  final int? roomId;
  @override
  Widget build(BuildContext context) {
    RoomModel? myRoom = context.watch<RoomCubit>().myRoom;
    useEffect(() {
      context.read<RoomCubit>().getMyRoom(id: roomId);

      return null;
    }, []);
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 30, 30, 36),
      appBar: AppBar(
        title: Text(myRoom?.name ?? "",
            style: TextStyle(
              color: AppColors.primaryColor,
            )),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(
                "${myRoom?.availableTime}",
                style: TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                    fontSize: 16),
              ),
              Lottie.asset('images/animations/clock.json', width: 40),
            ],
          ),
        ],
      ),
      body: BlocBuilder<RoomCubit, RoomState>(
        builder: (context, state) {
          if (state is GetMyRoomLoading) {
            return Loading();
          } else {
            return myRoom != null
                ? RoomPageView(
                    roomId: myRoom.id!,
                    room: myRoom,
                  )
                : const CreateRoomScreen();
          }
        },
      ),
    );
  }
}
