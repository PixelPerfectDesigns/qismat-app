import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

Future<void> generateTestUsers() async {
  List<Map<String, dynamic>> testUsers = [];

  for (int i = 1; i <= 16; i++) {
    Map<String, dynamic> profile = generateRandomProfile(i);
    Map<String, dynamic> preferences = generateRandomPreferences();

    testUsers.add({
      'userUid': 'user_$i',
      'profile': profile,
      'preferences': preferences,
    });

    await FirebaseFirestore.instance
        .collection('users')
        .doc('user_$i')
        .set({}, SetOptions(merge: true))
        .then((_) {
          print('User document with ID user_$i created');
          return FirebaseFirestore.instance
              .collection('users')
              .doc('user_$i')
              .collection('user_info')
              .doc("profile")
              .set(profile, SetOptions(merge: true));
        })
        .then((_) => print('Profile saved to Firestore'))
        .catchError((error) => print('Error: $error'));

    await FirebaseFirestore.instance
        .collection('users')
        .doc('user_$i')
        .collection('user_info')
        .doc('preferences')
        .set(preferences, SetOptions(merge: true))
        .then((_) {
      print('Preferences saved to Firestore');
    });
    // All questions are completed, set isProfileSetupComplete to true
    await FirebaseFirestore.instance
        .collection('users')
        .doc('user_$i')
        .collection('settings')
        .doc("general")
        .set({'isProfileSetupComplete': true, 'hideProfilePicture': true}).then(
            (_) {
      print('Profile setup is complete.');
    }).catchError((error) {
      print('Error setting up profile: $error');
    });
  }
}

Map<String, dynamic> generateRandomProfile(int i) {
  final random = Random();
  final bool isMale = i.isEven;

  return {
    'name': 'User ${random.nextInt(100)}',
    'gender': isMale ? "Male" : "Female",
    'dateOfBirth': DateTime(
      1990 + random.nextInt(10),
      random.nextInt(12) + 1,
      random.nextInt(28) + 1,
    ),
    'ethnicity': randomEthnicity(),
    'country': randomCountry(),
    'city': 'City ${random.nextInt(10)}',
    'educationLevel': randomEducationLevel(),
    'currentEducation': randomEducationLevel(),
    'profession': randomProfessions('profile'),
    'currentSalary': (20000 + random.nextInt(180000)).toDouble(),
    'skills': randomSkills(),
    'relationshipStatus': randomRelationshipStatus(),
    'futurePlans': 'Future plans ${random.nextInt(10)}',
    'aspirationsAndGoals': 'Aspirations ${random.nextInt(10)}',
    'hobbies': randomHobbies(),
    'personalityTraits': randomPersonalityTraits(),
    'profilePicture':
        'https://firebasestorage.googleapis.com/v0/b/qismat-flutter-app.appspot.com/o/uploads%2F1701226238266?alt=media&token=942c47af-4d80-41f6-896c-6d6b2d379078',
    'about': 'About user ${random.nextInt(10)}',
  };
}

Map<String, dynamic> generateRandomPreferences() {
  final random = Random();

  return {
    'preferredAgeRange': {'min': 18.0, 'max': 40.0},
    'acceptableEthnicities': randomEthnicities(),
    'relocationPreference': 'Within my current city',
    'livingSituations': ['Living alone with spouse'],
    'educationLevelPreference': randomEducationLevel(),
    'preferredProfessions': randomProfessions('preferences'),
    'acceptableIndustries': randomIndustries(),
    'preferredSalaryRange': {'min': 50000.0, 'max': 100000.0},
    'employmentArrangement': randomEmploymentArrangement(),
    'partnerSkills': randomSkills(),
    'desiredNumberOfKids': '1-2',
    'preferredEducationSystem': ['Public School'],
    'acceptableRelationshipTypes': ['Divorcee'],
    'desiredPersonalityTraits': randomPersonalityTraits(),
  };
}

String randomEthnicity() {
  final ethnicities = [
    "Asian",
    "Black or African American",
    "Hispanic or Latino",
    "White",
    "Native American or Alaska Native",
    "Other"
  ];
  final random = Random();
  return ethnicities[random.nextInt(ethnicities.length)];
}

String randomCountry() {
  final countries = [
    "United States",
    "Canada",
    "United Kingdom",
    "Australia",
    "Germany",
    "France",
    "Spain",
    "Italy",
    "India",
    "China",
    "Japan",
    "Brazil",
    "Mexico",
    "South Africa",
    "Nigeria",
    "Kenya",
    "Egypt",
    "Saudi Arabia",
    "United Arab Emirates",
    "Other"
  ];
  final random = Random();
  return countries[random.nextInt(countries.length)];
}

String randomEducationLevel() {
  final educationLevels = [
    "High School",
    "Associate's Degree/College",
    "Bachelor's Degree",
    "Master's Degree",
    "Doctorate",
    "Other"
  ];
  final random = Random();
  return educationLevels[random.nextInt(educationLevels.length)];
}

dynamic randomProfessions(String answer) {
  final professions = [
    "Accountant",
    "Architect",
    "Artist",
    "Astronomer",
    "Attorney",
    "Biologist",
    "Chef",
    "Civil Engineer",
    "Computer Programmer",
    "Dentist",
    "Doctor",
    "Economist",
    "Electrician",
    "Fashion Designer",
    "Firefighter",
    "Graphic Designer",
    "Journalist",
    "Lecturer",
    "Librarian",
    "Mechanical Engineer",
    "Nurse",
    "Pharmacist",
    "Photographer",
    "Pilot",
    "Police Officer",
    "Psychologist",
    "Research Scientist",
    "Social Worker",
    "Software Engineer",
    "Teacher",
    "Veterinarian",
    "Web Developer",
    "Writer",
    "Other"
  ];
  final random = Random();

  if (answer == 'preferences') {
    return professions.where((element) => random.nextBool()).toList();
  }
  return professions[random.nextInt(professions.length)];
}

List<String> randomSkills() {
  final skills = [
    "Programming",
    "Graphic Design",
    "Cooking",
    "Public Speaking",
    "Language Proficiency",
    "Writing",
    "Artistic Skills",
    "Problem Solving",
    "Leadership",
    "Teamwork",
    "Data Analysis",
    "Digital Marketing",
    "Photography",
    "Video Editing",
    "Mathematics",
    "Customer Service",
    "Research",
    "Negotiation",
    "Project Management",
    "Sales",
    "Singing",
    "Gardening",
    "Martial Arts",
    "Woodworking",
    "Craftsmanship",
    "Event Planning",
    "Time Management",
    "Other"
  ];
  final random = Random();
  return skills
      .where((element) => random.nextBool())
      .toList(); // Select random skills
}

String randomRelationshipStatus() {
  final relationshipStatuses = [
    "Divorcee",
    "Divorcee with kids",
    "Never Married"
  ];
  final random = Random();
  return relationshipStatuses[random.nextInt(relationshipStatuses.length)];
}

List<String> randomHobbies() {
  final hobbies = [
    "Reading",
    "Sports (e.g., tennis, swimming)",
    "Traveling",
    "Cooking",
    "Art (e.g., painting, drawing)",
    "Gardening",
    "Gaming (e.g., video games)",
    "Fitness (e.g., running, yoga)",
    "Photography",
    "Hiking",
    "Crafts (e.g., knitting, woodworking)",
    "Volunteering",
    "Writing (e.g., blogging, poetry)",
    "Collecting (e.g., stamps, coins)",
    "Fishing",
    "Camping",
    "Martial Arts",
    "Sculpting",
    "Model Building",
    "Other"
  ];
  final random = Random();
  return hobbies.where((element) => random.nextBool()).toList();
}

List<String> randomPersonalityTraits() {
  final personalityTraits = [
    "Outgoing",
    "Introverted",
    "Adventurous",
    "Easygoing",
    "Optimistic",
    "Analytical",
    "Creative",
    "Responsible",
    "Empathetic",
    "Confident",
    "Spontaneous",
    "Reserved",
    "Detail-oriented",
    "Ambitious",
    "Social",
    "Calm",
    "Organized",
    "Open-minded",
    "Funny",
    "Serious",
    "Loyal",
    "Independent",
    "Other"
  ];
  final random = Random();
  return personalityTraits.where((element) => random.nextBool()).toList();
}

String randomEmploymentArrangement() {
  final employmentArrangements = [
    "Both partners are employed",
    "Only the man is employed",
    "Only the woman is employed"
  ];
  final random = Random();
  return employmentArrangements[random.nextInt(employmentArrangements.length)];
}

List<String> randomEthnicities() {
  final ethnicities = [
    "Asian",
    "Black or African American",
    "Hispanic or Latino",
    "White",
    "Native American or Alaska Native",
    "Other"
  ];
  final random = Random();
  return ethnicities.where((element) => random.nextBool()).toList();
}

List<String> randomIndustries() {
  final industries = [
    "Technology",
    "Healthcare",
    "Education",
    "Finance",
    "Engineering",
    "Arts and Entertainment",
    "Manufacturing",
    "Hospitality and Tourism",
    "Media and Communications",
    "Science and Research",
    "Nonprofit and Charity",
    "Government and Public Service",
    "Agriculture",
    "Retail",
    "Legal",
    "Construction",
    "Transportation and Logistics",
    "Energy",
    "Other"
  ];
  final random = Random();
  return industries.where((element) => random.nextBool()).toList();
}
