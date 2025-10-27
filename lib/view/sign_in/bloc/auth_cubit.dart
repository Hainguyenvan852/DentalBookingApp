import 'dart:async';
import 'package:dental_booking_app/view/sign_in/bloc/auth_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../service/authentication_repository.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository repo;
  StreamSubscription<User?>? _authSub;

  AuthCubit(this.repo) : super(const AuthUnknown()) {
    _authSub = repo.authState().listen((user) async {
      // Lắng nghe đăng nhập/đăng xuất (authStateChanges)
      if (user == null) {
        emit(const AuthUnauthenticated());
        return;
      }

      if (!user.emailVerified) {
        emit(const AuthNeedsEmailVerify());
        return;
      }

      final profile =  repo.loadProfile();
      emit(AuthAuthenticated(user.uid, await profile));
    });
  }

  Future<void> requestSignUp() async {
    emit(AuthRequestSignUp());
  }

  Future<void> requestSignIn() async {
    emit(AuthUnauthenticated());
  }

  Future<void> checkEmailVerified() async {
    final user = FirebaseAuth.instance.currentUser;
    await user?.reload();
    final refreshed = FirebaseAuth.instance.currentUser;
    final ok = refreshed?.emailVerified ?? false;

    if (refreshed == null) {
      emit(const AuthUnauthenticated());
      return;
    }

    if (!ok) {
      emit(const AuthNeedsEmailVerify());
      return;
    }
    final profile = await repo.loadProfile();
    emit(AuthAuthenticated(user!.uid, profile));
  }

  Future<void> signIn(String email, String password) async {
    emit(const AuthLoading());
    try {
      await repo.signIn(email, password);
    } catch (e) {
      emit(AuthUnauthenticated(_friendly(e)));
    }
  }

  Future<void> signUp(
      String email,
      String password,
      String fullName,
      String phone,
      DateTime dob,
      String address,
      ) async {
    emit(const AuthLoading());
    try {
      await repo.signUp(
        email: email,
        password: password,
        fullName: fullName,
        dob: dob,
        phone: phone,
        address: address,
      );
      emit(const AuthNeedsEmailVerify());
    } catch (e) {
      emit(AuthUnauthenticated(_friendly(e.toString())));
    }
  }

  Future<void> sendReset(String email) async {
    try { await repo.sendResetPassword(email); } catch (_) {}
  }

  Future<void> signOut() async {
    emit(AuthLoading());
    await repo.signOut();
  }

  String _friendly(Object e) {
    final msg = e.toString();
    if (msg.contains('invalid-credential') || msg.contains('wrong-password')) {
      return 'Email hoặc mật khẩu không đúng.';
    }
    if (msg.contains('user-not-found')) return 'Không tìm thấy tài khoản.';
    if (msg.contains('email-already-in-use')) return 'Email đã được tạo bởi tài khoản khác';
    if (msg.contains('invalid-email')) return 'Email không hợp lệ.';
    if (msg.contains('too-many-requests')) return 'Thử lại sau (quá nhiều lần).';
    return 'Thao tác thất bại. Vui lòng thử lại.';
  }

  @override
  Future<void> close() async {
    await _authSub?.cancel();
    return super.close();
  }
}
