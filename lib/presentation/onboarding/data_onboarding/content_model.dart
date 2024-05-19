class OnBoardingContent {
  String? image;
  String? title;
  String? discription;

  OnBoardingContent({this.image, this.title, this.discription});
}

class EducationModel {
  final String title, description, image;

  EducationModel({
    required this.title,
    required this.description,
    required this.image,
  });
}

List<OnBoardingContent> contents = [
  OnBoardingContent(
      title: 'Timely Detection',
      image: 'assets/images/onboarding_vector.png',
      discription:
          "Timely identify eye diseases with our advanced detection tools."),
  OnBoardingContent(
      title: 'Therapies',
      image: 'assets/images/onboarding_vector.png',
      discription:
          "Access personalized therapy plans to improve your eye health."),
  OnBoardingContent(
      title: 'Vision Tests',
      image: 'assets/images/onboarding_vector.png',
      discription:
          "Take comprehensive vision tests to monitor your eye health."),
];

List<EducationModel> education = [
  EducationModel(
    title: "Eye Health Tips",
    description: "",
    image: 'assets/images/edu_1.jpeg',
  ),
  EducationModel(
    title: "Eye Health Tips",
    description: "",
    image: 'assets/images/edu_3.jpeg',
  ),
  EducationModel(
    title: "Eye Health Tips",
    description: "",
    image: 'assets/images/edu_2.jpeg',
  ),
  EducationModel(
    title: "Eye Health Tips",
    description: "",
    image: 'assets/images/edu_1.jpeg',
  ),
];
