class User {
  int id;
  String name;
  String email;
  int profile;

  User({this.id, this.name, this.email, this.profile});

  User.fromJson(Map<String, dynamic> json) {
    if (json['id'] != null) id = json['id'];
    name = json['name'];
    email = json['email'];
    profile = json['profile'] != null ? json['profile'] : json['profileId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['email'] = this.email;
    data['profile'] = this.profile;
    return data;
  }
}
