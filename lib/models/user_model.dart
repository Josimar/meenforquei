class UserModel{
  String uid, name, email, avatarUrl;
  String data, phone, tagcasal, wedding;
  String nomecasal;

  UserModel();

  UserModel.fromAll(this.uid, this.data, this.phone, this.name, this.email, this.avatarUrl, this.tagcasal, this.wedding);

  String title = "UserModel";

  bool isCasal = false;
  bool isAdmin = false;
  bool isLoggedIn = false;
  int isLoading = 0; /* 0=reading 1=ok 2=error */

  static UserModel fromMap(Map<String, dynamic> map, String documentId) {
    if (map == null) return null;

    return UserModel.fromAll(
        map["uid"],
        map["data"],
        map["phone"],
        map["name"],
        map["email"],
        map["urlimagem"],
        map["tagcasal"],
        map["wedding"]
    );
  }

  static UserModel fromData(Map<String, dynamic> data, String uId){
    if (data == null) return null;

    return UserModel.fromAll(
        data["uid"] == null ? uId : data["uid"],
        data["data"],
        data["phone"],
        data["name"],
        data["email"],
        data["urlimagem"],
        data["tagcasal"],
        data["wedding"]
    );

  }

  Map<String, dynamic> toResumeMap(){ // toJson
    return {
      "data": data,
      "email": email,
      "name": name,
      "phone": phone,
      "tagcasal": tagcasal,
      "urlimagem": avatarUrl,
      "wedding": wedding
    };
  }

}