import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:sw/common/components/grid_view_builder.dart';
import 'package:sw/common/constants/colors.dart';
import 'package:sw/features/rooms/cubit/room_cubit.dart';
import 'package:sw/features/rooms/screens/room_screen.dart';
import 'package:sw/features/rooms/widgets/room_item.dart';

class RoomsScreen extends HookWidget {
  const RoomsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    useEffect(() {
      context.read<RoomCubit>().getRooms();
      return null;
    });
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "غرف اللعب",
              style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 20,
            ),
            BlocBuilder<RoomCubit, RoomState>(
              builder: (context, state) {
                if (state is RoomsLoading || state is RoomInitial) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: AppColors.primaryColor,
                    ),
                  );
                } else if (state is RoomsSuccess) {
                  return GridViewBuilder(
                    crossAxisCount: 2,
                    itemCount: state.data.length,
                    itemBuilder: (context, index) {
                      final rooms = state.data;
                      return AnimationConfiguration.staggeredGrid(
                          duration: const Duration(milliseconds: 500),
                          columnCount: 2,
                          position: index,
                          child: ScaleAnimation(
                              child: GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => RoomScreen(
                                        roomId: rooms[index].id,
                                      )));
                            },
                            child: RoomItem(
                              room: rooms[index],
                            ),
                          )));
                    },
                  );
                } else if (state is RoomsError) {
                  return const Center(
                    child: Text('Something Wrong happend'),
                  );
                } else {
                  return const SizedBox();
                }
              },
            )
          ],
        ),
      ),
    );
  }
}
