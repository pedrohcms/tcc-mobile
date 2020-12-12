import 'Profile.dart';
import 'User.dart';

class UserProfile {
  User user;
  List<Profile> profiles;

  UserProfile({this.user, this.profiles});

  UserProfile.fromJson(Map<String, dynamic> json) {
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
    if (json['profiles'] != null) {
      profiles = new List<Profile>();
      json['profiles'].forEach((v) {
        profiles.add(new Profile.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.user != null) {
      data['user'] = this.user.toJson();
    }
    if (this.profiles != null) {
      data['profiles'] = this.profiles.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
