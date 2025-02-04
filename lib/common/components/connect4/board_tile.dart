// import 'dart:developer';

// import 'package:flutter/material.dart';
// import 'package:flutter_animate/flutter_animate.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:sw/features/c4/bloc/c4_bloc.dart';
// import 'package:sw/features/c4/models/connect4/tile_model.dart';
// import 'package:flutter_hooks/flutter_hooks.dart';

// class BoardTile extends HookWidget {
//   final int col;
//   final int row;
//   final int color;
//   const BoardTile({
//     super.key,
//     required this.col,
//     required this.row,
//     required this.color,
//   });

//   @override
//   Widget build(BuildContext context) {
//     Tile tile = Tile(col: col, row: row, color: color);
//     final bloc = context.read<C4Bloc>();

//     return BlocConsumer<C4Bloc, C4BlocState>(
//       listener: (context, state) {},
//       builder: (context, state) {
//         bool? isPlayer = context.read<C4Bloc>().isPlayer;
//         return InkWell(
//             onTap: !isPlayer!
//                 ? null
//                 : () {
//                     bloc.add(C4MakeMove(column: tile.col));
//                   },
//             child: Container(
//                 margin:
//                     EdgeInsets.all(MediaQuery.of(context).size.width * 0.001),
//                 decoration: const BoxDecoration(
//                   color: Colors.transparent,
//                 ),
//                 child: Container(
//                   decoration: BoxDecoration(
//                     shape: BoxShape.circle,
//                     color: tile.color,
//                   ),
//                 )));
//       },
//     );
//   }
// }
