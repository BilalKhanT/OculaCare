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
