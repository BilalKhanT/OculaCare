import 'package:cculacare/data/models/address/address_model.dart';
import 'package:equatable/equatable.dart';

sealed class AddressBookState extends Equatable {
  const AddressBookState();

  @override
  List<Object?> get props => [];
}

class AddressBookInitial extends AddressBookState {}

class AddressBookLoading extends AddressBookState {}

class AddressBookLoaded extends AddressBookState {
  final List<Address> addresses;
  final Address currentAddress;

  const AddressBookLoaded(this.addresses, this.currentAddress);

  @override
  List<Object?> get props => [addresses];
}

class AddressBookError extends AddressBookState {}
