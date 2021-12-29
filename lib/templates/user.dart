import 'dart:developer'as dev;

class AppUser {

  final String? uid;
  String? name;
  List<AppUser>? friends;

  AppUser({
    this.uid,
    this.name,
    this.friends,
  });

}