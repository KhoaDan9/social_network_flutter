import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instagramz_flutter/features/auth/register/bloc/register_event.dart';
import 'package:instagramz_flutter/features/auth/register/bloc/register_state.dart';
import 'package:instagramz_flutter/resources/auth_method.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final AuthMethod authMethod;

  RegisterBloc({required this.authMethod}) : super(const RegisterState()) {
    on<RegisterOnClickEvent>((event, emit) async {
      emit(const RegisterState(isLoading: true));
      try {
        await authMethod.registerUser(
            email: event.email,
            fullname: event.fullname,
            username: event.username,
            password: event.password,
            image: event.image);
        emit(const RegisterSuccess());
      } on FirebaseException catch (e) {
        emit(RegisterFailure(exception: e.code, isLoading: false));
      } catch (e) {
        emit(RegisterFailure(exception: e.toString(), isLoading: false));
      }
    });
    on<RefreshRegisterEvent>((event, emit) {
      emit(const RegisterState());
    });
  }
}
