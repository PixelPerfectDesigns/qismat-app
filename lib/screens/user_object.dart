import 'package:flutter/material.dart';

class User {
  UserProfile profile;
  UserPreferences preferences;

  User({required this.profile, required this.preferences});

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
        profile: UserProfile.fromMap(map['profile']),
        preferences: UserPreferences.fromMap(map['preferences']));
  }

  Map<String, dynamic> toMap() {
    return {
      'profile': profile.toMap(),
      'preferences': preferences.toMap(),
    };
  }
}

class UserProfile {
  String name;
  String gender;
  DateTime dateOfBirth;
  String ethnicity;
  String country;
  String city;
  String educationLevel;
  String currentEducation;
  String profession;
  int currentSalary;
  List<String> skills;
  int previousMarriages;
  String futurePlans;
  String aspirationsAndGoals;
  List<String> hobbies;
  List<String> personalityTraits;

  UserProfile({
    required this.name,
    required this.gender,
    required this.dateOfBirth,
    required this.ethnicity,
    required this.country,
    required this.city,
    required this.educationLevel,
    required this.currentEducation,
    required this.profession,
    required this.currentSalary,
    required this.skills,
    required this.previousMarriages,
    required this.futurePlans,
    required this.aspirationsAndGoals,
    required this.hobbies,
    required this.personalityTraits,
  });

  factory UserProfile.fromMap(Map<String, dynamic> map) {
    return UserProfile(
      name: map['name'],
      gender: map['gender'],
      dateOfBirth: map['dateOfBirth'].toDate(),
      ethnicity: map['ethnicity'],
      country: map['country'],
      city: map['city'],
      educationLevel: map['educationLevel'],
      currentEducation: map['currentEducation'],
      profession: map['profession'],
      currentSalary: map['currentSalary'],
      skills: List<String>.from(map['skills']),
      previousMarriages: map['previousMarriages'],
      futurePlans: map['futurePlans'],
      aspirationsAndGoals: map['aspirationsAndGoals'],
      hobbies: List<String>.from(map['hobbies']),
      personalityTraits: List<String>.from(map['personalityTraits']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'gender': gender,
      'dateOfBirth': dateOfBirth,
      'ethnicity': ethnicity,
      'country': country,
      'city': city,
      'educationLevel': educationLevel,
      'currentEducation': currentEducation,
      'profession': profession,
      'currentSalary': currentSalary,
      'skills': skills,
      'previousMarriages': previousMarriages,
      'futurePlans': futurePlans,
      'aspirationsAndGoals': aspirationsAndGoals,
      'hobbies': hobbies,
      'personalityTraits': personalityTraits,
    };
  }
}

class UserPreferences {
  String ageRange;
  List<String> acceptableEthnicities;
  String relocationPreference;
  List<String> livingSituations;
  String educationLevelPreference;
  List<String> preferredProfessions;
  List<String> acceptableIndustries;
  Map<String, int> preferredSalaryRange;
  String employmentArrangement;
  List<String> partnerSkills;
  String desiredNumberOfKids;
  List<String> preferredEducationSystem;
  List<String> acceptableRelationshipTypes;

  UserPreferences({
    required this.ageRange,
    required this.acceptableEthnicities,
    required this.relocationPreference,
    required this.livingSituations,
    required this.educationLevelPreference,
    required this.preferredProfessions,
    required this.acceptableIndustries,
    required this.preferredSalaryRange,
    required this.employmentArrangement,
    required this.partnerSkills,
    required this.desiredNumberOfKids,
    required this.preferredEducationSystem,
    required this.acceptableRelationshipTypes,
  });

  factory UserPreferences.fromMap(Map<String, dynamic> map) {
    return UserPreferences(
      ageRange: map['ageRange'],
      acceptableEthnicities: List<String>.from(map['acceptableEthnicities']),
      relocationPreference: map['relocationPreference'],
      livingSituations: List<String>.from(map['livingSituations']),
      educationLevelPreference: map['educationLevelPreference'],
      preferredProfessions: List<String>.from(map['preferredProfessions']),
      acceptableIndustries: List<String>.from(map['acceptableIndustries']),
      preferredSalaryRange: Map<String, int>.from(map['preferredSalaryRange']),
      employmentArrangement: map['employmentArrangement'],
      partnerSkills: List<String>.from(map['partnerSkills']),
      desiredNumberOfKids: map['desiredNumberOfKids'],
      preferredEducationSystem:
          List<String>.from(map['preferredEducationSystem']),
      acceptableRelationshipTypes:
          List<String>.from(map['acceptableRelationshipTypes']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'ageRange': ageRange,
      'acceptableEthnicities': acceptableEthnicities,
      'relocationPreference': relocationPreference,
      'livingSituations': livingSituations,
      'educationLevelPreference': educationLevelPreference,
      'preferredProfessions': preferredProfessions,
      'acceptableIndustries': acceptableIndustries,
      'preferredSalaryRange': preferredSalaryRange,
      'employmentArrangement': employmentArrangement,
      'partnerSkills': partnerSkills,
      'desiredNumberOfKids': desiredNumberOfKids,
      'preferredEducationSystem': preferredEducationSystem,
      'acceptableRelationshipTypes': acceptableRelationshipTypes,
    };
  }
}
