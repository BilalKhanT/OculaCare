import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import '../../../configs/presentation/constants/colors.dart';
import '../../../data/models/bookmark/bookmark_model.dart';

class CstmBookmarkTile extends StatelessWidget {
  final Bookmark bookmark;
  final VoidCallback onDelete;
  final VoidCallback onNavigate;

  const CstmBookmarkTile({
    Key? key,
    required this.bookmark,
    required this.onDelete,
    required this.onNavigate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;

    return Slidable(
      key: ValueKey(bookmark.placeId),
      endActionPane: ActionPane(
        motion: const StretchMotion(),
        children: [
          // Navigate Action
          SlidableAction(
            onPressed: (context) => onNavigate(),
            icon: Icons.navigation,
            label: 'Navigate',
            backgroundColor: Colors.green,
          ),
          // Delete Action
          SlidableAction(
            onPressed: (context) => onDelete(),
            icon: Icons.delete,
            label: 'Delete',
            backgroundColor: Colors.red,
          ),
        ],
      ),
      child: Container(
        margin: const EdgeInsets.all(8.0),
        padding: const EdgeInsets.all(12.0),
        width: screenWidth * 0.9,
        height: screenHeight * 0.15,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.0),
          boxShadow: [
            BoxShadow(
              color: AppColors.textPrimary.withOpacity(0.1),
              spreadRadius: 3,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            // Hospital Image
            ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.network(
                bookmark.iconUrl,
                width: screenWidth * 0.2,
                height: screenHeight * 0.1,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey[300],
                    child: const Icon(
                      Icons.image,
                      size: 30,
                      color: Colors.white,
                    ),
                  );
                },
              ),
            ),
            const SizedBox(width: 12.0),
            // Bookmark details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    bookmark.name,
                    style: TextStyle(
                      color: Colors.black,
                      fontFamily: 'MontserratMedium',
                      fontWeight: FontWeight.w800,
                      fontSize: screenWidth * 0.04,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: screenHeight * 0.004),
                  Text(
                    bookmark.address,
                    style: TextStyle(
                      color: Colors.grey.shade700,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w600,
                      fontSize: screenWidth * 0.032,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (bookmark.rating != null)
                    Row(
                      children: [
                        Icon(Icons.star, color: Colors.amber, size: screenWidth * 0.04),
                        SizedBox(width: screenWidth * 0.01),
                        Text(
                          '${bookmark.rating} (${bookmark.userRatingsTotal ?? 0} reviews)',
                          style: TextStyle(
                            color: Colors.grey.shade700,
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.w600,
                            fontSize: screenWidth * 0.032,
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
