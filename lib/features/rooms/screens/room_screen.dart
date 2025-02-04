import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:sw/common/constants/colors.dart';
import 'package:sw/features/rooms/bloc/pusher_bloc.dart';
import 'package:sw/features/rooms/cubit/room_cubit.dart';
import 'package:sw/features/rooms/models/room_model.dart';
import 'package:sw/features/rooms/widgets/create_room_form.dart';
import 'package:sw/features/rooms/widgets/room_view.dart';

class RoomScreen extends HookWidget {
  const RoomScreen({super.key});
  @override
  Widget build(BuildContext context) {
    RoomModel? myRoom = context.watch<RoomCubit>().myRoom;
    useEffect(() {
      if (myRoom != null) {
        context.read<PusherBloc>().add(PusherConnect(myRoom.id!));
        context.read<PusherBloc>().add(GetOldMessages(myRoom.id!));
      } else {
        context.read<RoomCubit>().getMyRoom();
      }
      return null;
    }, [myRoom]);
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 30, 30, 36),
      appBar: AppBar(
        title: const Text("اسم الغرفة"),
        elevation: 0.0,
      ),
      body: BlocBuilder<RoomCubit, RoomState>(
        builder: (context, state) {
          if (state is GetMyRoomLoading) {
            return const Center(
              child: CircularProgressIndicator(
                color: AppColors.primaryColor,
              ),
            );
          } else {
            return myRoom != null
                ? RoomPageView(
                    roomId: myRoom.id!,
                  )
                : const CreateRoomScreen();
          }
        },
      ),
    );
  }
}
