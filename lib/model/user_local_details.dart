class UserLocalData {
  String userId;
  String userName;
  String userEmail;  
  String userPhotoUrl;

  UserLocalData({required this.userName,required  this.userId,required this.userEmail,required this.userPhotoUrl});

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'userName': userName,
      'userEmail': userEmail,
      'userPhotoUrl': userPhotoUrl,
    };
  }

  factory UserLocalData.fromMap(Map<String, dynamic> map) {
    return UserLocalData(
      userId: map['userId'],
      userName: map['userName'],
      userEmail: map['userEmail'],
      userPhotoUrl: map['userPhotoUrl']
    );
  }
}
