import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../helpers/responsive_ui_helper.dart';
import '../../../../shared/widgets/error_widget.dart';
import '../providers/twitter_page.riverpod.dart';
import '../../../../shared/widgets/error.page.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../config/colors_config.dart';
import '../responsive/twitterpage.responsive.dart';

class TwitterPage extends ConsumerWidget {
  static const String route = '/twitter';
  const TwitterPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final uiConfig = TwitterPageResponsiveConfig
        .responsiveUI[ResponsiveUIHelper.getDeviceType(context)]!;

    var twitterDataAsync = ref.watch(twitterProvider);
    return twitterDataAsync.when(
      loading: () => const Center(
          child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation(Colors.white),
      )),
      error: (error, stackTrace) =>
          ErrorNotification(message: error.toString()),
      data: (twitterData) {
        return Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                twitterData.icon,
                size: uiConfig.iconSize,
                color: TheColors.twitterIcon,
              ).animate(onPlay: (controller) {
                controller.repeat(reverse: true);
              }).scaleXY(
                begin: .8,
                end: 1,
                duration: 1.seconds,
                curve: Curves.easeIn,
              ),
              Text.rich(
                TextSpan(
                    style: TextStyle(
                      fontSize: uiConfig.titleSize,
                      color: Colors.white,
                    ),
                    children: [
                      //const TextSpan(text: "I'm "),
                      TextSpan(
                        text: twitterData.title,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ]),
                textAlign: TextAlign.center,
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        twitterData.subTitle,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: uiConfig.subtitleSize,
                          color: const Color.fromARGB(255, 244, 246, 248),
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(30),
                        child: Container(
                          color: TheColors.twitterSecondary,
                          child: GestureDetector(
                            onTap: () async {
                              var myTwitterUrl = Uri.parse(twitterData.url);
                              if (!await launchUrl(myTwitterUrl)) {
                                const ErrorPage(
                                  errorMessage: 'Could not Launch URL',
                                );
                              }
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Text(
                                twitterData.handle,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: uiConfig.buttonLabelSize,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ]
                .animate(
                  interval: 100.ms,
                )
                .slideY(
                  begin: 1,
                  end: 0,
                  duration: 0.5.seconds,
                  curve: Curves.easeInOut,
                )
                .fadeIn(),
          ),
        );
      },
    );
  }
}
