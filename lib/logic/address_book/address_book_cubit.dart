import 'package:bloc/bloc.dart';
import 'package:cculacare/data/models/address/address_model.dart';
import 'package:cculacare/data/repositories/local/preferences/shared_prefs.dart';
import 'package:cculacare/logic/address_book/address_book_state.dart';
import 'package:nb_utils/nb_utils.dart';

class AddressBookCubit extends Cubit<AddressBookState> {
  AddressBookCubit() : super(AddressBookInitial());

  Future<void> getAddresses() async {
    emit(AddressBookLoading());
    try {
      final List<Address> address = sharedPrefs.getAddressList();
      if (address.isEmpty) {
        emit(AddressBookError());
        return;
      }
      emit(AddressBookLoaded(address));
    } catch (e) {
      log(e);
      emit(AddressBookError());
    }
  }

  Future<void> addAddress(Address add) async {
    emit(AddressBookLoading());
    try {
      final List<Address> address = sharedPrefs.getAddressList();
      address.add(add);
      sharedPrefs.setAddressList(address);
      emit(AddressBookLoaded(address));
    } catch (e) {
      log(e);
      emit(AddressBookError());
    }
  }

  Future<void> deleteAddress(Address add) async {
    emit(AddressBookLoading());
    try {
      final List<Address> address = sharedPrefs.getAddressList();
      address.removeWhere(
          (address) => address.long == add.long && address.lat == add.lat);
      sharedPrefs.setAddressList(address);
      emit(AddressBookLoaded(address));
    } catch (e) {
      log(e);
      emit(AddressBookError());
    }
  }
}
