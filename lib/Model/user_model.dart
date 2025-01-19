class UserModel {
  String email;
  String name;
  String password;
  String userName;
  String userUid;
  String profileURL;
  String? time;
  bool? isOnline;
  String? lastMessage;
  UserModel(
      {required this.email,
      required this.name,
      required this.password,
      required this.userName,
      this.isOnline,
      required this.profileURL,
      this.lastMessage,
      this.time,
      required this.userUid});
  Map<String, dynamic> userMap() {
    return {
      "uid": userUid,
      "name": name,
      "email": email,
      "password": password,
      "username": userName,
      "profilepic": profileURL
    };
  }
}
