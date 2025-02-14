import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sw/common/constants/colors.dart';
import 'package:sw/features/home/cubit/home_cubit.dart';

class TransferDialog extends StatefulWidget {
  const TransferDialog({super.key});

  @override
  _TransferDialogState createState() => _TransferDialogState();
}

class _TransferDialogState extends State<TransferDialog> {
  final _formKey = GlobalKey<FormState>();
  final _userIdController = TextEditingController();
  final _countryController = TextEditingController();
  final _phoneController = TextEditingController();
  final _pointsController = TextEditingController();

  @override
  void dispose() {
    _userIdController.dispose();
    _countryController.dispose();
    _phoneController.dispose();
    _pointsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => HomeCubit(),
      child: BlocConsumer<HomeCubit, HomeState>(
        listener: (context, state) {
          if (state is TransferSuccess) {
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
          } else if (state is TransferFailure) {
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
                  'Create Transfer',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                content: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _userIdController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: 'User ID',
                            labelStyle:
                                TextStyle(color: AppColors.primaryColor),
                            enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: AppColors.primaryColor),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: AppColors.primaryColor),
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter user id';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _countryController,
                          decoration: InputDecoration(
                            labelText: 'Country',
                            labelStyle:
                                TextStyle(color: AppColors.primaryColor),
                            enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: AppColors.primaryColor),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: AppColors.primaryColor),
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter country';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _phoneController,
                          decoration: InputDecoration(
                            labelText: 'Phone',
                            labelStyle:
                                TextStyle(color: AppColors.primaryColor),
                            enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: AppColors.primaryColor),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: AppColors.primaryColor),
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter phone';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _pointsController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: 'Points',
                            labelStyle:
                                TextStyle(color: AppColors.primaryColor),
                            enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: AppColors.primaryColor),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: AppColors.primaryColor),
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter points';
                            }
                            final points = int.tryParse(value);
                            if (points == null || points < 1000) {
                              return 'Points must be at least 1000';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      'Cancel',
                      style: TextStyle(color: AppColors.primaryColor),
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {
                      if (_formKey.currentState?.validate() ?? false) {
                        context.read<HomeCubit>().createTransfer(
                              userId: int.parse(_userIdController.text),
                              country: _countryController.text,
                              phone: _phoneController.text,
                              points: int.parse(_pointsController.text),
                            );
                      }
                    },
                    child: const Text('Submit'),
                  ),
                ],
              ),
              if (state is TransferLoading)
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
