class UserData {
  final String name;
  final int id;
  String avatar;
  final String phoneNumber;

  UserData({
    required this.name,
    required this.id,
    required this.avatar,
    required this.phoneNumber,
  });

  factory UserData.fromJson(Map<String, dynamic> json) => UserData(
        name: json["displayName"] ?? 'Khong co du lieu',
        id: json["id"] ?? 0,
        avatar: json["avatar"] ?? "",
        phoneNumber: json["phoneNumber"] ?? "",
      );
}
