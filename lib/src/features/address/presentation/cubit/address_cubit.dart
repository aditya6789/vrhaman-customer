import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:vrhaman/src/utils/toast.dart';
import '../../data/model/addressModel.dart';
import '../../data/datasources/address_remote_data_source.dart';

part 'address_state.dart';

class AddressCubit extends Cubit<AddressState> {
  final AddressRemoteDataSource addressRemoteDataSource;

  AddressCubit({required this.addressRemoteDataSource}) : super(AddressInitial());

  Future<void> getAddresses() async {
    try {
      emit(AddressLoading());
      final response = await addressRemoteDataSource.getAddresses();
    print('cubit response: ${response.addresses}');
      emit(AddressLoaded(response));

    } catch (e) {
      emit(AddressError(e.toString()));
    }
  }

  Future<void> addAddress(String address, String city, String state, String postalCode) async {
    try {
      emit(AddressLoading());
      await addressRemoteDataSource.addAddress(address, city, state, postalCode);
      await getAddresses();
    } catch (e) {
      emit(AddressError(e.toString()));
    }
  }

  Future<void> updateAddress(String id, String address, String city, String state, String postalCode) async {
    try {
      emit(AddressLoading());
      await addressRemoteDataSource.updateAddress(id, address, city, state, postalCode);
      await getAddresses();
    } catch (e) {
      emit(AddressError(e.toString()));
    }
  }

  Future<void> deleteAddress(String id) async {
    try {
      emit(AddressLoading());
      await addressRemoteDataSource.deleteAddress(id);
      showToast('Address deleted successfully');
      await getAddresses();
    } catch (e) {
      emit(AddressError(e.toString()));
    }
  }

  Future<void> setDefaultAddress(String id) async {
    try {
      emit(AddressLoading());
      await addressRemoteDataSource.setDefaultAddress(id);
      await getAddresses();
    } catch (e) {
      emit(AddressError(e.toString()));
    }
  }
}

