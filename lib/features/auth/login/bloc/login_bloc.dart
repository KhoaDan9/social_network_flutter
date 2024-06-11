import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instagramz_flutter/features/auth/login/bloc/login_event.dart';
import 'package:instagramz_flutter/features/auth/login/bloc/login_state.dart';
import 'package:instagramz_flutter/models/user_model.dart';
import 'package:instagramz_flutter/resources/auth_method.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthMethod authMethod;
  LoginBloc({required this.authMethod}) : super(const LoginState()) {
    on<LoginOnClickEvent>((event, emit) async {
      emit(const LoginState(isLoading: true));
      try {
        final email = event.email;
        final password = event.password;
        final UserModel user = await authMethod.loginUser(email, password);
        emit(LoginSuccess(user: user, isLoading: false));
      } on FirebaseException catch (e) {
        emit(LoginFailure(exception: e.code, isLoading: false));
      }
    });
  }
}
