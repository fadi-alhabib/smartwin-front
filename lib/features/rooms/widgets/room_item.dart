import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:sw/features/rooms/models/room_model.dart';

class RoomItem extends StatelessWidget {
  const RoomItem({
    super.key,
    required this.room,
  });

  final RoomModel room;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, boxConstraints) {
      return Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(2, 5),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(25),
              child: Image.network(
                room.image ?? '',
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
                errorBuilder: (context, error, stackTrace) => Container(
                  color: Colors.grey[800],
                ),
              ),
            ),
          ),

          // Online Status Badge
          Positioned(
            top: 12,
            right: 12,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: (room.online ?? 0) == 1 ? Colors.green : Colors.grey,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 4,
                    offset: const Offset(1, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Icon(
                    (room.online ?? 0) == 1
                        ? Icons.circle
                        : Icons.circle_outlined,
                    color: Colors.white,
                    size: 12,
                  ),
                  const Gap(4),
                  Text(
                    (room.online ?? 0) == 1 ? 'LIVE' : 'OFFLINE',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Bottom Info Overlay
          Container(
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(25),
                bottomRight: Radius.circular(25),
              ),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.black.withOpacity(0.7),
                ],
              ),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  room.name ?? 'Unnamed Room',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    shadows: [
                      Shadow(
                        color: Colors.black54,
                        blurRadius: 4,
                        offset: Offset(1, 1),
                      ),
                    ],
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (room.availableTime != null) ...[
                  const Gap(8),
                  Row(
                    children: [
                      const Icon(
                        Icons.access_time,
                        color: Colors.white70,
                        size: 18,
                      ),
                      const Gap(4),
                      Text(
                        '${(room.availableTime! / 60).toStringAsFixed(1)}h',
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      );
    });
  }
}
