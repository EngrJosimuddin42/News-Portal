import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:news_break/app/theme/app_colors.dart';
import 'package:news_break/app/theme/app_text_styles.dart';
import '../../controllers/nbot_controller.dart';
import '../../controllers/signin_controller.dart';
import '../../controllers/social_interaction_controller.dart';
import '../../models/comment_source.dart';
import '../../models/news_model.dart';
import '../../theme/app_assets.dart';
import '../../widgets/about_profile_sheet.dart';
import '../../widgets/follow_button.dart';
import '../../widgets/network_or_file_image.dart';
import '../../widgets/publisher_avatar.dart';
import '../ai/nbot_sheet.dart';
import '../signin/signin_view.dart';
import 'show_more_sheets.dart';

class NewsDetailView extends StatefulWidget {
  const NewsDetailView({super.key});

  @override
  State<NewsDetailView> createState() => _NewsDetailViewState();
}

class _NewsDetailViewState extends State<NewsDetailView> {
  late final NewsModel news;
  late final String tabType;
  late final SocialInteractionController socialCtrl;

  @override
  void initState() {
    super.initState();
    socialCtrl = Get.find<SocialInteractionController>();
    final dynamic args = Get.arguments;
    news = (args is Map) ? args['news'] as NewsModel : args as NewsModel;
    tabType = (args is Map) ? (args['tabType'] ?? 'news') : 'news';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: AppColors.scaffoldBg,
        elevation: 0,
        titleSpacing: 0,
        leading: GestureDetector(
          onTap: () => Get.back(),
          child: Icon(Icons.arrow_back_ios, color:AppColors.textOnDark, size: 20.sp)),
        title: GestureDetector(
          onTap: () {
            if (!Get.isRegistered<NBotController>()) {
              Get.lazyPut(() => NBotController());
            }
            showModalBottomSheet(
              context: Get.context!,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(Get.context!).size.width,
                maxHeight: MediaQuery.of(Get.context!).size.height * 0.84),
              builder: (_) => const NBotSheet(),
            );
          },
          child: Container(
            height: 36.h, width: 260.w,
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            decoration: BoxDecoration(
                border: Border.all(color: AppColors.border),
                color: AppColors.scaffoldBg,
                borderRadius: BorderRadius.circular(8.r)),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ShaderMask(
                    shaderCallback: (Rect bounds) {
                      return AppColors.aiGradient.createShader(bounds);
                    },
                    child: SvgPicture.asset( AppAssets.starIcon, width: 22.w, height: 22.h,
                        colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn))),
                SizedBox(width: 8.w),
                Expanded(
                  child: Text('ask_anything'.tr, maxLines: 1,
                    overflow: TextOverflow.visible,
                    style: AppTextStyles.overline.copyWith( letterSpacing: 0, height: 1))),
              ],
            ),
          ),
        ),
        actions: [
          Obx(() {
            final saved = socialCtrl.isSaved(news.id, type: 'news');
            return IconButton(
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              icon: Icon(
                saved ? Icons.bookmark : Icons.bookmark_border,
                color: saved ? Colors.blueAccent : AppColors.textOnDark,size: 20.sp),
              onPressed: () => socialCtrl.onSaveNews(news),
            );
          }),
          IconButton(
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            icon: Icon(Icons.more_vert, color: AppColors.textOnDark, size: 24.sp),
            onPressed: () => NewsBottomSheets.showMoreSheet(context, news),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: EdgeInsets.all(17.w),
              children: [
                // Title
                Text(news.title,
                  style:AppTextStyles.headlineMedium.copyWith(color: AppColors.white)),
                 SizedBox(height: 12.h),

                // Category & Time
                Padding(
                  padding:  EdgeInsets.fromLTRB(0.w, 12.h, 12.w, 16.h),
                  child: Row(
                    children: [

                      SvgPicture.asset(AppAssets.personIcon, height: 18.h, width: 18.w,
                          colorFilter: ColorFilter.mode(AppColors.info, BlendMode.srcIn)),
                      SizedBox(width: 4.w),
                      Flexible(
                          child: Text(news.category, style: AppTextStyles.overline.copyWith(
                            color: AppColors.info,letterSpacing: 0,height: 1.0,),
                              overflow: TextOverflow.visible, maxLines: 1)),
                      SizedBox(width: 18.w),

                      SvgPicture.asset(AppAssets.locationIcon, height: 18.h, width: 18.w,
                          colorFilter: ColorFilter.mode(AppColors.info, BlendMode.srcIn)),
                      SizedBox(width: 4.w),
                      Flexible(
                          child: Text(news.publisherMeta,
                              style: AppTextStyles.overline.copyWith(
                                color: AppColors.info,letterSpacing: 0,height: 1.0,),
                              overflow: TextOverflow.visible, maxLines: 1)),
                      SizedBox(width: 18.w),

                      SvgPicture.asset(AppAssets.timeIcon, height: 18.h, width: 18.w,
                          colorFilter: ColorFilter.mode(AppColors.info, BlendMode.srcIn)),
                      SizedBox(width: 4.w),
                      Flexible(
                          child: Text(
                              news.formattedTime.isNotEmpty
                                  ? '${news.formattedTime[0].toUpperCase()}${news.formattedTime.substring(1)}'
                                  : '',
                              style: AppTextStyles.overline.copyWith(color: AppColors.info),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1)),
                    ],
                  ),
                ),

                // Publisher row
                Row(
                  children: [

                    PublisherAvatar.fromNews(news: news),

                     SizedBox(width: 8.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Flexible(
                                  child: GestureDetector(
                                      onTap: () => AboutProfileSheet.showFromNews(context, news),
                                      child: Text(news.publisherName,
                                          style: AppTextStyles.bodyMedium.copyWith(color: AppColors.white),
                                          overflow: TextOverflow.ellipsis, maxLines: 1))),
                              if (news.isVerified) ...[
                                SizedBox(width: 6.w),
                                SvgPicture.asset(AppAssets.verifiedIcon, width: 20.w, height: 20.h,colorFilter: ColorFilter.mode(AppColors.verify, BlendMode.srcIn)),
                              ],
                            ],
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),

                    FollowButton(news: news),
                  ],
                ),
                 SizedBox(height: 12.h),

                // Main image
                NetworkOrFileImage( url: news.imageUrl,  height: 200.h,  width: double.infinity,
                  borderRadius: BorderRadius.circular(8.r)),

                 SizedBox(height: 8.h),
                if (news.imageCaption.isNotEmpty)
                  Padding( padding: EdgeInsets.only(top: 8.0.h),
                    child: Text(news.imageCaption, style: AppTextStyles.overline.copyWith(color: const Color(0xFF9C9C9C)))),
                 SizedBox(height: 16.h),

                // Body text
                Text( news.body,style: AppTextStyles.caption.copyWith(color: AppColors.body)),
                if (news.secondaryImageUrl != null && news.secondaryImageUrl!.isNotEmpty)
                  Padding( padding: EdgeInsets.symmetric(vertical: 16.h),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8.r),
                      child: Image.network(
                        news.secondaryImageUrl!,
                        errorBuilder: (context, error, stackTrace) => const SizedBox.shrink()))),
                if (news.secondarySubtitle != null && news.secondarySubtitle!.isNotEmpty)
                  Padding( padding: EdgeInsets.only(top: 16.w),
                    child: Text( news.secondarySubtitle!, style: AppTextStyles.overline.copyWith(color: AppColors.white))),
              ],
            ),
          ),

          // Bottom bar
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
            decoration: BoxDecoration(
              color:AppColors.scaffoldBg),
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                      onTap: () {
                        Get.lazyPut(() => SignInController());
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                          constraints: BoxConstraints( maxWidth: MediaQuery.of(context).size.width),
                          builder: (context) => const SignInView(isSheet: true),
                        );
                      },
                    child: Container(
                      padding:  EdgeInsets.symmetric(horizontal: 5.w, vertical: 8.h),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(48.r),
                      border: Border.all(color: AppColors.border)),
                      child: Text('write_a_comment'.tr, style: AppTextStyles.overline,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center)))),
                 SizedBox(width: 16.w),

                  // Like, Comment, Share Action Buttons
                Obx(() {

                  final isLiked = socialCtrl.isLiked(news, type: tabType);

                  final likeCount = socialCtrl.getAdjustedNewsLikes(news, type: tabType);

                  final Color likedColor = Colors.blue;

                  return _actionItem(
                    label: likeCount,
                    onTap: () => socialCtrl.toggleLike(news, type: tabType),
                    asset: AppAssets.likeIcon, color: isLiked ? likedColor : AppColors.white, isLiked: isLiked
                  );
                }),

                 SizedBox(width: 16.w),

                Obx(() {
                  final commentCount = socialCtrl.getCommentCount(news, source: tabType);
                  return _actionItem(
                      label: socialCtrl.formatCount(commentCount.value),
                      onTap: () {
                        final source = (tabType == 'post')
                            ? CommentSource.social
                            : (tabType == 'reel' ? CommentSource.reel : CommentSource.news);
                        socialCtrl.openComments(
                            news.id,
                            source,
                            tabType: tabType,
                            author: news.author
                        );
                      },
                    asset: AppAssets.commentIcon, color: AppColors.white,
                  );
                }),
                   SizedBox(width: 16.w),

                   _actionItem(label:'share',
                       onTap: () => socialCtrl.onSharePressed(news),asset: AppAssets.shareIcon,color: AppColors.white),
               ],
            ),
          ),
          SizedBox(height: MediaQuery.of(context).padding.bottom + 16.h)
         ]
         ),
        );
       }

  Widget _actionItem({
    required String label,
    required VoidCallback onTap,
    String? asset,
    IconData? icon,
    required Color color,
    bool isLiked = false,
  }) {
    return GestureDetector(
      onTap: onTap,


      behavior: HitTestBehavior.opaque,
      child: Row(
        children: [
          if (asset != null)
            SvgPicture.asset( asset, width: 20.0.w, height: 20.0.h,
              colorFilter: ColorFilter.mode(color, BlendMode.srcIn))
          else
            Icon(icon, color: color, size: 20.sp),

           SizedBox(width: 4.w),
          Text( label.tr,
            style: AppTextStyles.labelMedium.copyWith(color: color),
          ),
        ],
      ),
    );
  }
}