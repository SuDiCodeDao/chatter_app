class UserEntity {
  String? uid;
  String? email;
  String? displayName;
  String? photoUrl;
  String? phone;
  List<String>? conversationIds;

  UserEntity(
      {this.uid,
      this.email,
      this.displayName,
      this.photoUrl,
      this.phone,
      this.conversationIds});
}
