import 'package:animate_do/animate_do.dart';
import 'package:cculacare/logic/location_cubit/current_loc_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../configs/presentation/constants/colors.dart';
import '../../../data/models/address/address_model.dart';

class CurrentAddressTile extends StatelessWidget {
  final Address address;
  final bool isSelected;

  const CurrentAddressTile({
    super.key,
    required this.address,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.sizeOf(context).width;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 9.0),
      child: FadeIn(
        duration: const Duration(milliseconds: 1000 + (5 * 100)),
        child: GestureDetector(
          // Use selectAddress to mark the address as selected
          onTap: () => context.read<CurrentLocationCubit>().selectAddress(address),
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(9.0),
              boxShadow: isSelected
                  ? [
                BoxShadow(
                  color: AppColors.appColor.withOpacity(0.9),
                  spreadRadius: 1,
                  blurRadius: 0.5,
                  offset: const Offset(0, 0),
                ),
              ]
                  : [
                BoxShadow(
                  color: AppColors.textPrimary.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 0.5,
                  offset: const Offset(0, 0),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 17.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Flexible(
                    child: Text(
                      '${address.locationName}',
                      style: TextStyle(
                        fontFamily: 'MontserratMedium',
                        fontWeight: FontWeight.w800,
                        fontSize: screenWidth * 0.037,
                        color: AppColors.textPrimary,
                      ),
                      overflow: TextOverflow.visible,
                      maxLines: null,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

