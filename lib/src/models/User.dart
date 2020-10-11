class User {
  String name;
  String email;
  int profile;

  User({this.name, this.email, this.profile});

  User.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    email = json['email'];
    profile = json['profile'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['email'] = this.email;
    data['profile'] = this.profile;
    return data;
  }
}
