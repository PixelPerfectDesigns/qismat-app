import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';

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
        .then((_) {});
    // All questions are completed, set isProfileSetupComplete to true
    await FirebaseFirestore.instance
        .collection('users')
        .doc('user_$i')
        .collection('settings')
        .doc("general")
        .set({'isProfileSetupComplete': true, 'hideProfilePicture': true})
        .then((_) {})
        .catchError((error) {
          print('Error setting up profile: $error');
        });
  }
}

Map<String, dynamic> generateRandomProfile(int i) {
  final random = Random();
  final bool isMale = i.isEven;
  Map<int, String> names = {
    1: 'Emily',
    3: 'Olivia',
    5: 'Mia',
    7: 'Emma',
    9: 'Aria',
    11: 'Grace',
    13: 'Scarlett',
    15: 'Violet',
    2: 'Noah',
    4: 'Jackson',
    6: 'Lucas',
    8: 'Caleb',
    10: 'Mason',
    12: 'Benjamin',
    14: 'Elijah',
    16: 'Levi',
  };

  return {
    'name': names[i],
    'contactEmail': '${names[i]}@qismat.app',
    'contactPhoneNumber': '514-523-1571',
    'gender': isMale ? "Male" : "Female",
    'dateOfBirth': DateTime(
      1990 + random.nextInt(10),
      random.nextInt(12) + 1,
      random.nextInt(28) + 1,
    ),
    'ethnicity': randomEthnicity(),
    'country': 'Canada',
    'city': randomCanadianCity(),
    'educationLevel': randomEducationLevel(),
    'currentEducation': randomEducationLevel(),
    'profession': randomProfessions('profile'),
    'currentSalary': (20000 + random.nextInt(180000)).toDouble(),
    'skills': randomSkills(),
    'relationshipStatus': randomRelationshipStatus(),
    'futurePlans':
        'Building a future of love, laughter, and shared adventures. Seeking a partner with a similar vision for a joyful life together.',
    'aspirationsAndGoals':
        'Aspiring to make a positive impact in technology through my business.',
    'hobbies': randomHobbies(),
    'personalityTraits': randomPersonalityTraits(),
    'profilePicture': isMale
        ? 'https://firebasestorage.googleapis.com/v0/b/qismat-flutter-app.appspot.com/o/uploads%2Fmale_profile_pic.jpg?alt=media&token=b354bf0c-a90f-41a5-9e99-54f0063aa1c5'
        : 'https://firebasestorage.googleapis.com/v0/b/qismat-flutter-app.appspot.com/o/uploads%2Ffemale_profile_pic.jpg?alt=media&token=242ffa26-3749-4a15-a522-5cb4cd36464f',
    'about':
        "Passionate about photography and hiking, I embrace life with positivity. Advocating for sustainability, kindness, and personal growth, I'm excited to share my journey and learn about yours. Looking for a partner to and create meaningful moments together!",
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

String randomCanadianCity() {
  final canadianCities = [
    "Toronto",
    "Vancouver",
    "Montreal",
    "Calgary",
    "Edmonton",
    "Ottawa",
    "Quebec City",
    "Winnipeg",
    "Hamilton",
    "London",
    "Halifax",
    "Victoria",
    "Saskatoon",
    "Regina",
    "St. John's",
    "Kingston",
    "Fredericton",
    "Charlottetown",
    "Yellowknife",
    "Whitehorse",
  ];
  final random = Random();
  return canadianCities[random.nextInt(canadianCities.length)];
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
    "Sports",
    "Traveling",
    "Cooking",
    "Art",
    "Gardening",
    "Gaming",
    "Fitness",
    "Photography",
    "Hiking",
    "Crafts",
    "Volunteering",
    "Writing",
    "Collecting",
    "Fishing",
    "Camping",
    "Martial Arts",
    "Sculpting",
    "Model Building",
    "Other"
  ];
  final random = Random();
  return hobbies.where((element) => random.nextBool()).take(5).toList();
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
