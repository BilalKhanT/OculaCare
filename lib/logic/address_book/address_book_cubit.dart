import 'package:bloc/bloc.dart';
import 'package:cculacare/data/models/address/address_model.dart';
import 'package:cculacare/data/repositories/address_book/address_book_repo.dart';
import 'package:cculacare/data/repositories/local/preferences/shared_prefs.dart';
import 'package:cculacare/logic/address_book/address_book_state.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

class AddressBookCubit extends Cubit<AddressBookState> {
  AddressBookCubit() : super(AddressBookInitial());

  final AddressBookRepo addressBookRepo = AddressBookRepo();
  double lat = -99999.9;
  double long = -9999.9;
  final addressController = TextEditingController();

  Future<void> getAddresses() async {
    emit(AddressBookLoading());
    Address? currentAdd = sharedPrefs.getAddress();
    currentAdd ??= Address(lat: -98798.99, long: -98798.99, locationName: 'kkk');
    try {
      final List<Address> address = sharedPrefs.getAddressList();
      if (address.isEmpty) {
        emit(AddressBookError());
        return;
      }
      emit(AddressBookLoaded(address, currentAdd));
    } catch (e) {
      log(e);
      emit(AddressBookError());
    }
  }

  Future<void> setCoordinates(double latitude, double longitude) async {
    lat = latitude;
    long = longitude;
  }

  Future<void> selectCurrentAddress(Address address) async {
    sharedPrefs.setAddress(address);
    emit(AddressBookLoading());
    emit(AddressBookLoaded(sharedPrefs.getAddressList(), address));
  }

  Future<bool> addAddress() async {
    emit(AddressBookLoading());
    Address? currentAdd = sharedPrefs.getAddress();
    currentAdd ??= Address(lat: -98798.99, long: -98798.99, locationName: 'kkk');
    try {
      if (lat != -9999.9 &&
          long != -9999.9 &&
          addressController.text.trim() != '') {
        final add = Address(
            lat: lat, long: long, locationName: addressController.text.trim());
        final bool flag = await addressBookRepo.addAddress(
            email: sharedPrefs.email, address: add);
        lat = -9999.9;
        long = -9999.9;
        addressController.text = '';
        if (flag) {
          final List<Address> address = sharedPrefs.getAddressList();
          address.add(add);
          sharedPrefs.setAddressList(address);
          emit(AddressBookLoaded(address, currentAdd));
          return true;
        }
      }
      emit(AddressBookLoaded(sharedPrefs.getAddressList(), currentAdd));
      return false;
    } catch (e) {
      log(e);
      emit(AddressBookLoaded(sharedPrefs.getAddressList(), currentAdd));
      return false;
    }
  }

  Future<bool> deleteAddress(Address add) async {
    emit(AddressBookLoading());
    Address? currentAdd = sharedPrefs.getAddress();
    currentAdd ??= Address(lat: -98798.99, long: -98798.99, locationName: 'kkk');
    try {
      final bool flag = await addressBookRepo.deleteAddress(
          email: sharedPrefs.email, address: add);
      if (flag) {
        final List<Address> address = sharedPrefs.getAddressList();
        address.removeWhere(
            (address) => address.long == add.long && address.lat == add.lat);
        sharedPrefs.setAddressList(address);
        emit(AddressBookLoaded(address, currentAdd));
        return true;
      }
      emit(AddressBookLoaded(sharedPrefs.getAddressList(), currentAdd));
      return false;
    } catch (e) {
      log(e);
      emit(AddressBookLoaded(sharedPrefs.getAddressList(), currentAdd));
      return false;
    }
  }
}
