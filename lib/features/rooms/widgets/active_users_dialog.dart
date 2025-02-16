import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sw/common/constants/colors.dart';
import 'package:sw/features/auth/models/user_model.dart';
import 'package:sw/features/rooms/cubit/room_cubit.dart';

class ActiveUsersDialog extends StatelessWidget {
  const ActiveUsersDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<RoomCubit>(
      create: (context) => RoomCubit()..fetchActiveUsers(),
      child: BlocConsumer<RoomCubit, RoomState>(
        listener: (context, state) {
          if (state is ActiveUsersError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'خطأ: ${state.message}',
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
              Directionality(
                textDirection: TextDirection.ltr,
                child: AlertDialog(
                  backgroundColor: AppColors.backgroundColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  title: Text(
                    "اختر خصمك",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  content: SizedBox(
                    width: double.maxFinite,
                    height: 300,
                    child: () {
                      if (state is ActiveUsersLoading) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (state is ActiveUsersLoaded) {
                        final List<UserModel> users = state.users;
                        if (users.isEmpty) {
                          return const Center(
                              child: Text('لا يوجد مستخدمين نشطين'));
                        }
                        return ListView.builder(
                          shrinkWrap: true,
                          itemCount: users.length,
                          itemBuilder: (context, index) {
                            final UserModel user = users[index];
                            return ListTile(
                              leading: user.image != null
                                  ? CircleAvatar(
                                      backgroundImage:
                                          NetworkImage(user.image!),
                                    )
                                  : const CircleAvatar(
                                      child: Icon(Icons.person)),
                              title: Text(user.fullName ?? 'بدون اسم',
                                  style: TextStyle(
                                    color: AppColors.primaryColor,
                                  )),
                              subtitle: Text('المعرف: ${user.id}',
                                  style: TextStyle(
                                    color: AppColors.whiteColor,
                                  )),
                              onTap: () {
                                // Close the dialog and return the selected user's id.
                                Navigator.of(context).pop(user.id);
                              },
                            );
                          },
                        );
                      } else if (state is ActiveUsersError) {
                        return Center(child: Text(state.message));
                      }
                      return const SizedBox.shrink();
                    }(),
                  ),
                ),
              ),
              if (state is ActiveUsersLoading)
                Positioned.fill(
                  child: Container(
                    color: Colors.black.withOpacity(0.5),
                    child: Center(
                      child: CircularProgressIndicator(
                        valueColor:
                            AlwaysStoppedAnimation(AppColors.primaryColor),
                      ),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
