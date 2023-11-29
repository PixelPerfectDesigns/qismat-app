class Person {
  String? userUid;
  PersonProfile? profile;
  PersonPreferences? preferences;

  Person({this.userUid, this.profile, this.preferences});

  factory Person.fromMap(Map<String, dynamic> map) {
    return Person(
      userUid: map['userUid'],
      profile:
          map['profile'] != null ? PersonProfile.fromMap(map['profile']) : null,
      preferences: map['preferences'] != null
          ? PersonPreferences.fromMap(map['preferences'])
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userUid': userUid,
      'profile': profile?.toMap(),
      'preferences': preferences?.toMap(),
    };
  }
}

class PersonProfile {
  String name;
  String gender;
  DateTime dateOfBirth;
  int age;
  String ethnicity;
  String country;
  String city;
  String educationLevel;
  String currentEducation;
  String profession;
  double currentSalary;
  List<String> skills;
  String relationshipStatus;
  String futurePlans;
  String aspirationsAndGoals;
  List<String> hobbies;
  List<String> personalityTraits;
  String profilePicture;
  String about;

  PersonProfile({
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
    required this.relationshipStatus,
    required this.futurePlans,
    required this.aspirationsAndGoals,
    required this.hobbies,
    required this.personalityTraits,
    required this.profilePicture,
    required this.about,
  }) : age = calculateAge(dateOfBirth);

  factory PersonProfile.fromMap(Map<String, dynamic> map) {
    return PersonProfile(
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
      relationshipStatus: map['relationshipStatus'],
      futurePlans: map['futurePlans'],
      aspirationsAndGoals: map['aspirationsAndGoals'],
      hobbies: List<String>.from(map['hobbies']),
      personalityTraits: List<String>.from(map['personalityTraits']),
      profilePicture: map['profilePicture'],
      about: map['about'],
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
      'relationshipStatus': relationshipStatus,
      'futurePlans': futurePlans,
      'aspirationsAndGoals': aspirationsAndGoals,
      'hobbies': hobbies,
      'personalityTraits': personalityTraits,
      'profilePicture': profilePicture,
      'about': about,
    };
  }

  static int calculateAge(DateTime dateOfBirth) {
    // Get the current date and time
    DateTime now = DateTime.now();

    // Calculate the difference between the current date and the birthdate
    Duration difference = now.difference(dateOfBirth);

    // Calculate the age in years
    int age = (difference.inDays / 365).floor();

    return age;
  }
}

class PersonPreferences {
  Map<String, double> preferredAgeRange;
  List<String> acceptableEthnicities;
  String relocationPreference;
  List<String> livingSituations;
  String educationLevelPreference;
  List<String> preferredProfessions;
  List<String> acceptableIndustries;
  Map<String, double> preferredSalaryRange;
  String employmentArrangement;
  List<String> partnerSkills;
  String desiredNumberOfKids;
  List<String> preferredEducationSystem;
  List<String> acceptableRelationshipTypes;
  List<String> desiredPersonalityTraits;

  PersonPreferences({
    required this.preferredAgeRange,
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
    required this.desiredPersonalityTraits,
  });

  factory PersonPreferences.fromMap(Map<String, dynamic> map) {
    return PersonPreferences(
      preferredAgeRange: Map<String, double>.from(map['preferredAgeRange']),
      acceptableEthnicities: List<String>.from(map['acceptableEthnicities']),
      relocationPreference: map['relocationPreference'],
      livingSituations: List<String>.from(map['livingSituations']),
      educationLevelPreference: map['educationLevelPreference'],
      preferredProfessions: List<String>.from(map['preferredProfessions']),
      acceptableIndustries: List<String>.from(map['acceptableIndustries']),
      preferredSalaryRange:
          Map<String, double>.from(map['preferredSalaryRange']),
      employmentArrangement: map['employmentArrangement'],
      partnerSkills: List<String>.from(map['partnerSkills']),
      desiredNumberOfKids: map['desiredNumberOfKids'],
      preferredEducationSystem:
          List<String>.from(map['preferredEducationSystem']),
      acceptableRelationshipTypes:
          List<String>.from(map['acceptableRelationshipTypes']),
      desiredPersonalityTraits:
          List<String>.from(map['desiredPersonalityTraits']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'preferredAgeRange': preferredAgeRange,
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
      'desiredPersonalityTraits': desiredPersonalityTraits,
    };
  }
}
