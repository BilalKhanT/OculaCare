import 'package:cculacare/logic/bookmark_cubit/bookmark_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import '../../../configs/presentation/constants/colors.dart';
import '../../../data/models/hospital_locator_model/helper_model/hospital_helper_model.dart';

class CstmBookmarkTile extends StatelessWidget {
  final HospitalHelper hospital;
  final VoidCallback onDelete;
  final VoidCallback onNavigate;

  const CstmBookmarkTile({
    Key? key,
    required this.hospital,
    required this.onDelete,
    required this.onNavigate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;
    final bookmarkCubit = context.read<BookmarkCubit>();

    return Slidable(
      key: const ValueKey(0),
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
            onPressed: (context) async{
              bookmarkCubit.deleteBookmark(hospital.id);
            } ,
            icon: Icons.delete,
            label: 'Delete',
            backgroundColor: Colors.red,
          ),
        ],
      ),
      child: Builder(
        builder: (context) => Container(
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
              // Placeholder image
              Container(
                width: screenWidth * 0.2,
                height: screenHeight * 0.1,
                color: Colors.grey[300],
                child: const Center(
                  child: Icon(
                    Icons.image,
                    size: 30,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(width: 12.0),
              // Hospital details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      hospital.name,
                      style: TextStyle(
                        color: Colors.black,
                        fontFamily: 'MontserratMedium',
                        fontWeight: FontWeight.w800,
                        fontSize: screenWidth * 0.04,
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.004),
                    Text(
                      '${hospital.distance} meters away',
                      style: TextStyle(
                        color: Colors.grey.shade700,
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.w600,
                        fontSize: screenWidth * 0.032,
                      ),
                    ),
                  ],
                ),
              ),
              // Info Icon Container
              Container(
                width: 40,
                height: 40,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: const Icon(
                    Icons.info_outline,
                    color: AppColors.appColor,
                  ),
                  onPressed: () {
                    Slidable.of(context)?.openEndActionPane();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
