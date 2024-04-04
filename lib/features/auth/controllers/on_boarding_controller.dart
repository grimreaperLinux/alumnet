import 'package:alumnet/constants/colors.dart';
import 'package:alumnet/constants/image_strings.dart';
import 'package:alumnet/constants/text_strings.dart';
import 'package:alumnet/features/auth/models/model_on_boarding.dart';
import 'package:alumnet/features/auth/screens/on_boarding/onboarding_page.dart';
import 'package:get/get.dart';
import 'package:liquid_swipe/PageHelpers/LiquidController.dart';

class OnBoardingController extends GetxController {
  final pages = [
    OnBoardingPage(
      model: OnBoardingModel(
        bgColor: tOnBoardingPage1Color,
        image: tOnBoardingImage1,
        title: tOnBoardingTitle1,
        subtitle: tOnBoardingSubTitle1,
        counterText: tOnBoardingCounter1,
      ),
    ),
    OnBoardingPage(
      model: OnBoardingModel(
        bgColor: tOnBoardingPage2Color,
        image: tOnBoardingImage2,
        title: tOnBoardingTitle2,
        subtitle: tOnBoardingSubTitle2,
        counterText: tOnBoardingCounter2,
      ),
    ),
    OnBoardingPage(
      model: OnBoardingModel(
        bgColor: tOnBoardingPage3Color,
        image: tOnBoardingImage3,
        title: tOnBoardingTitle3,
        subtitle: tOnBoardingSubTitle3,
        counterText: tOnBoardingCounter3,
      ),
    )
  ];
  final controller = LiquidController();
  RxInt currentPage = 0.obs;

  void onPageChangeCallback(int page) {
    currentPage.value = page;
  }

  skip() => controller.jumpToPage(page: 2);

  animateToNextSlide() {
    int nextPage = controller.currentPage + 1;
    controller.animateToPage(page: nextPage);
  }
}
