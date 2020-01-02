class GooglePayload {
  final String name;
  final String email;
  final String googleId;

  GooglePayload(
    this.name,
    this.email,
    this.googleId,
  );
}

class GoogleRegistrationPayload {
  final String name;
  final String position;
  final String email;
  final String phone;
  final String googleId;

  GoogleRegistrationPayload(
    this.name,
    this.position,
    this.email,
    this.phone,
    this.googleId,
  );
}
