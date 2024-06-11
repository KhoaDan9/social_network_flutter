import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagramz_flutter/features/home/bloc/home_event.dart';
import 'package:instagramz_flutter/features/home/bloc/home_state.dart';
import 'package:instagramz_flutter/resources/auth_method.dart';
import 'package:instagramz_flutter/resources/firestore_method.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final FireStoreMethod fireStoreMethod;

  HomeBloc({required this.fireStoreMethod}) : super(const HomeState()) {
    on<SetUser>((event, emit) async {
      emit(HomeState(user: event.user));
    });
  }
}
