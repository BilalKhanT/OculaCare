class OnBoardingContent {
  String? image;
  String? title;
  String? discription;

  OnBoardingContent({this.image, this.title, this.discription});
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
