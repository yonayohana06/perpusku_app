class LoginResponseModel {
  final String token;
  final String refreshToken;

  LoginResponseModel({required this.token, required this.refreshToken});

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? json;
    return LoginResponseModel(
      token: data['token'] ?? '',
      refreshToken: data['refresh_token'] ?? '',
    );
  }
}
