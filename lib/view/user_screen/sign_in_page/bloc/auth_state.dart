abstract class AuthState{
  const AuthState();
}

class AuthUnknown extends AuthState{
  const AuthUnknown();
}

class AuthLoading extends AuthState{
  const AuthLoading();
}

class AuthUnauthenticated extends AuthState {
  final String? message;
  const AuthUnauthenticated([this.message]);
}

class AuthNeedsEmailVerify extends AuthState {
  const AuthNeedsEmailVerify();
}

class AuthAuthenticated extends AuthState {
  final String uid;
  final Map<String, dynamic>? profile;
  const AuthAuthenticated(this.uid, this.profile);
}

class AuthRequestSignUp extends AuthState{
  const AuthRequestSignUp();
}