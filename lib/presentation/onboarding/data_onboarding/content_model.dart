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
          "Industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it "),
  OnBoardingContent(
      title: 'Therapies',
      image: 'assets/images/onboarding_vector.png',
      discription:
          "Industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it "),
  OnBoardingContent(
      title: 'Vision Tests',
      image: 'assets/images/onboarding_vector.png',
      discription:
          "Industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it "),
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
