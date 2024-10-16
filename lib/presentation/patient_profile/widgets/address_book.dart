import 'package:cculacare/logic/address_book/address_book_cubit.dart';
import 'package:cculacare/logic/address_book/address_book_state.dart';
import 'package:cculacare/presentation/patient_profile/widgets/address_tile.dart';
import 'package:cculacare/presentation/widgets/cstm_loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../configs/presentation/constants/colors.dart';
import '../../../configs/routes/route_names.dart';
import '../../../logic/location_cubit/location_cubit.dart';
import '../../widgets/btn_flat.dart';

class AddressBook extends StatelessWidget {
  const AddressBook({super.key});

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.sizeOf(context).height;
    double screenWidth = MediaQuery.sizeOf(context).width;
    return Scaffold(
      backgroundColor: AppColors.screenBackground,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            context.pop();
          },
          icon: const Icon(
            Icons.arrow_back_ios_new_outlined,
            color: AppColors.appColor,
          ),
        ),
        backgroundColor: AppColors.screenBackground,
        title: Text(
          'Address Book',
          style: TextStyle(
            color: Colors.black,
            fontFamily: 'MontserratMedium',
            fontWeight: FontWeight.w800,
            fontSize: screenWidth * 0.05,
          ),
        ),
      ),
      body: SafeArea(
        child: BlocBuilder<AddressBookCubit, AddressBookState>(
          builder: (context, state) {
            if (state is AddressBookLoaded) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      child: ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        itemCount: state.addresses.length,
                        itemBuilder: (context, index) {
                          final address = state.addresses[index];
                          return AddressTile(
                            address: address,
                            isSelected: address.lat == state.currentAddress.lat,
                          );
                        },
                      ),
                    ),
                    SizedBox(
                      height: screenHeight * 0.03,
                    ),
                    ButtonFlat(
                      btnColor: AppColors.appColor,
                      textColor: AppColors.whiteColor,
                      onPress: () {
                        context.read<LocationCubit>().setLocation();
                        context.push(RouteNames.locationRoute, extra: true);
                      },
                      text: 'Add new address',
                    ),
                  ],
                ),
              );
            }
            else if (state is AddressBookLoading) {
              return const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  DotLoader(loaderColor: AppColors.appColor,),
                ],
              );
            }
            else if (state is AddressBookError) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Failed to load addresses',
                    style: TextStyle(
                      color: Colors.black,
                      fontFamily: 'MontserratMedium',
                      fontWeight: FontWeight.w800,
                      fontSize: screenWidth * 0.04,
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.05),
                  ButtonFlat(
                    btnColor: AppColors.appColor,
                    textColor: AppColors.whiteColor,
                    onPress: () {
                      context.read<AddressBookCubit>().getAddresses();
                    },
                    text: 'Reload',
                  ),
                ],
              );
            }
            else {
              return const SizedBox.shrink();
            }
          },
        ),
      ),
    );
  }
}
