class SignUpFailure {
  final String message;

  const SignUpFailure([this.message = "An Unknown Error Occurred."]);

  factory SignUpFailure.code(String code) {
    switch (code) {
      case 'email-already-in-use':
        return const SignUpFailure('Email is already in use.');
      case 'invalid-email':
        return const SignUpFailure('Email is invalid.');
      case 'operation-not-allowed':
        return const SignUpFailure('Operation is not allowed.');
      case 'weak-password':
        return const SignUpFailure('Password is too weak.');
      case 'user-disabled':
        return const SignUpFailure('User is disabled.');
      default:
        return const SignUpFailure();
    }
  }
}
