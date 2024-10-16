import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../../../configs/presentation/constants/colors.dart';
import '../../../configs/utils/utils.dart';
import '../../../data/models/address/address_model.dart';
import '../../../logic/address_book/address_book_cubit.dart';

class AddressTile extends StatelessWidget {
  final Address address;
  final bool isSelected;

  const AddressTile({
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
        child: Slidable(
          key: const ValueKey(0),
          endActionPane: ActionPane(
            motion: const StretchMotion(),
            children: [
              SlidableAction(
                onPressed: (context) {
                  context.read<AddressBookCubit>().selectCurrentAddress(address);
                },
                icon: Icons.location_on_outlined,
                backgroundColor: AppColors.appColor.withOpacity(0.7),
              ),
              SlidableAction(
                onPressed: (context) async {
                  final bool flag =
                  await context.read<AddressBookCubit>().deleteAddress(address);
                  if (context.mounted) {
                    if (flag) {
                      AppUtils.showToast(context, 'Address Removed',
                          'Address has been removed successfully', false);
                      return;
                    }
                    AppUtils.showToast(context, 'Error Occurred',
                        'Failed to successfully remove address', true);
                  }
                },
                icon: Icons.delete_outlined,
                backgroundColor: const Color(0xffB81736),
              )
            ],
          ),
          child: Builder(
            builder: (context) => Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(9.0),
                boxShadow: isSelected ? [
                BoxShadow(
                  color: AppColors.appColor.withOpacity(0.9),
                  spreadRadius: 1,
                  blurRadius: 0.5,
                  offset: const Offset(0, 0),
                ),
                  ] : [
                  BoxShadow(
                    color: AppColors.textPrimary.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 0.5,
                    offset: const Offset(0, 0),
                  ),
                ],
              ),
              child: Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: 10.0, vertical: 17.0),
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
                    Padding(
                      padding: const EdgeInsets.only(right: 10.0, left: 4),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100.0),
                          color: AppColors.appColor.withOpacity(0.2),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(1.0),
                          child: IconButton(
                            onPressed: () {
                              Slidable.of(context)?.openEndActionPane();
                            },
                            icon: const Icon(
                              Icons.navigate_next_outlined,
                            ),
                            color: AppColors.appColor,
                            iconSize: 23,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
