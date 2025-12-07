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

class AuthAuthenticatedDoctor extends AuthState {
  final String uid;
  const AuthAuthenticatedDoctor(this.uid);
}

class AuthAuthenticatedPatient extends AuthState {
  final String uid;
  const AuthAuthenticatedPatient(this.uid);
}

class AuthRequestSignUp extends AuthState{
  const AuthRequestSignUp();
}