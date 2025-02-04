// import 'dart:math';

// import 'package:flutter/material.dart';
// import 'package:flutter_animate/flutter_animate.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:sw/features/c4/bloc/c4_bloc.dart';
// import 'package:sw/common/components/connect4/board_tile.dart';
// import 'package:flutter_hooks/flutter_hooks.dart';
// import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

// class C4GameBoard extends HookWidget {
//   const C4GameBoard({super.key});
//   @override
//   Widget build(BuildContext context) {
//     final lockedBoardAnimationController = useAnimationController();

//     useEffect(() {
//       return () {
//         lockedBoardAnimationController.dispose();
//       };
//     }, const []);
//     return Animate(
//       controller: lockedBoardAnimationController,
//       autoPlay: false,
//       effects: [
//         ShakeEffect(duration: 500.milliseconds, rotation: 0.01),
//         BoxShadowEffect(
//             duration: 500.microseconds,
//             begin: const BoxShadow(color: Colors.transparent),
//             end: BoxShadow(
//               color: Colors.red.shade300,
//               blurRadius: 20,
//               offset: const Offset(0, 2),
//             )),
//       ],
//       child: ClipRRect(
//         borderRadius: const BorderRadius.vertical(
//             top: Radius.circular(60), bottom: Radius.circular(20)),
//         child: Container(
//           constraints: BoxConstraints(
//             maxWidth: MediaQuery.of(context).size.width,
//             maxHeight: MediaQuery.of(context).size.height * 0.5,
//           ),
//           padding: EdgeInsets.all(
//             MediaQuery.of(context).size.width * 0.07,
//           ),
//           decoration: BoxDecoration(
//             color: Colors.grey.shade800,
//           ),
//           child: BlocConsumer<C4Bloc, C4BlocState>(
//             listener: (context, state) {
//               if (state is C4BoardLockedState) {
//                 lockedBoardAnimationController
//                     .forward()
//                     .then((value) => lockedBoardAnimationController.reset());
//               }
//             },
//             builder: (context, state) {
//               final board = context.watch<C4Bloc>().board;
//               if (board != null && board.isNotEmpty) {
//                 return GridView.builder(
//                   shrinkWrap: true,
//                   physics: const NeverScrollableScrollPhysics(),
//                   itemCount: board.length * board[0].length,
//                   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                     crossAxisCount: board[0].length, // Number of columns
//                     crossAxisSpacing: 12,
//                     mainAxisSpacing: 12,
//                   ),
//                   itemBuilder: (BuildContext context, int index) {
//                     int row = index ~/ board[0].length;
//                     int col = index % board[0].length;
//                     return AnimationConfiguration.staggeredGrid(
//                         position: index,
//                         columnCount: board[0].length,
//                         duration: const Duration(milliseconds: 500),
//                         child: FadeInAnimation(
//                             child: ScaleAnimation(
//                                 child: BoardTile(
//                           col: col,
//                           row: row,
//                           color: board[row][col],
//                         ))));
//                   },
//                 );
//               } else {
//                 return const Center(child: CircularProgressIndicator());
//               }
//             },
//           ),
//         ),
//       ),
//     );
//   }
// }
// // GridView.count(
// //         crossAxisCount: boardSettings.cols,
// //         children: [
// //           for (int i = 0; i < boardSettings.totalTiles(); i++)
//             // AnimationConfiguration.staggeredGrid(
//             //     position: i,
//             //     columnCount: boardSettings.cols,
//             //     duration: const Duration(milliseconds: 500),
//             //     child: FadeInAnimation(
//             //         child: ScaleAnimation(
//             //             child: BoardTile(
//             //                 boardIndex: i, boardSettings: boardSettings))))
// //         ],
// //       ),
