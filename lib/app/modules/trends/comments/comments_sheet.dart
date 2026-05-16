import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:news_break/app/modules/trends/comments/write_comment_sheet.dart';
import 'package:news_break/app/theme/app_assets.dart';
import 'package:news_break/app/theme/app_colors.dart';
import 'package:news_break/app/theme/app_text_styles.dart';
import 'package:news_break/app/widgets/bottom_sheet_handle.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../../../controllers/auth/auth_controller.dart';
import '../../../controllers/reels/comment_controller.dart';
import '../../../controllers/social_interaction_controller.dart';
import '../../../models/comment_model.dart';
import '../../../models/comment_source.dart';
import 'option_sheet.dart';
class CommentsSheet extends StatefulWidget {
  final dynamic id;
  final CommentSource source;

  const CommentsSheet({
    super.key,
    required this.id,
    required this.source,
  });

  @override
  State<CommentsSheet> createState() => _CommentsSheetState();
}

class _CommentsSheetState extends State<CommentsSheet> {
  late final AuthController _authController;
  late final CommentController _commentController;
  late final SocialInteractionController _socialCtrl;

  @override
  void initState() {
    super.initState();
    _authController = Get.find<AuthController>();
    _commentController = Get.find<CommentController>();
    _socialCtrl = Get.find<SocialInteractionController>();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      decoration: BoxDecoration(
          color: AppColors.sheet,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20.r))),
      child: Column(
        children: [
          const BottomSheetHandle(),
          SizedBox(height: 12.h),

          // Header
          Padding(
            padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 8.h),
            child: Row(
              children: [
                Expanded(
                  child: Obx(() => Text(
                      '${_socialCtrl.formatCount(_commentController.commentsList.length)} Comments',
                      textAlign: TextAlign.center,
                      style: AppTextStyles.bodyMedium.copyWith(color: AppColors.white)))),
                GestureDetector(
                    onTap: () => Get.back(),
                    child: Icon(Icons.close, color:AppColors.white, size: 20.sp)),
              ],
            ),
          ),

          // Comments list
          Expanded(
            child: Obx(() {
              if (_commentController.isCommentsLoading.value) {
                return  Center(
                    child: CircularProgressIndicator(color:AppColors.white));
              }
              if (_commentController.commentsList.isEmpty) {
                return Center(
                    child: Text("No comments yet", style: TextStyle(color:AppColors.white)));
              }
              return ListView.builder(
                padding: EdgeInsets.only(top: 8.h),
                itemCount: _commentController.commentsList.length,
                itemBuilder: (_, i) => _buildComment(
                    context, _commentController.commentsList[i]),
              );
            }),
          ),

          // Write comment input
          Container(
            padding: EdgeInsets.only( left: 12.w, right: 12.w, top: 12.h, bottom: 36),
            child: GestureDetector(
              onTap: () => _showWriteCommentSheet(context, widget.id),
              child: Container( height: 44.h,
                padding: EdgeInsets.symmetric(horizontal: 12.h),
                decoration: BoxDecoration(
                    color: AppColors.search,
                    border: Border.all(color: AppColors.border),
                    borderRadius: BorderRadius.circular(60.r)),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(100.r),
                      child: Obx(() => Image.network(
                        _authController.user.value?.profileImageUrl ?? '',
                        width: 24.w,
                        height: 24.h,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                         Icon(Icons.account_circle, color:AppColors.textOnDark, size: 28.sp),
                      )),
                    ),
                     SizedBox(width: 10.w),
                    Text('Write a comment...', style: AppTextStyles.overline.copyWith(fontSize: 10.sp)),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildComment(BuildContext context, CommentModel comment) {
    return Padding(
      padding:  EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar( radius: 18.r,
              backgroundImage: NetworkImage(comment.userProfileImage),
              backgroundColor:AppColors.textOnDark),
           SizedBox(width: 10.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(comment.userName, style: AppTextStyles.small.copyWith(color: AppColors.white)),
                           SizedBox(height: 2.h),
                          Text(comment.location, style: AppTextStyles.overline),
                        ],
                      ),
                    ),

                    ValueListenableBuilder<int>(
                      valueListenable: _socialCtrl.followNotifier,
                      builder: (context, value, child) {
                        final bool isFollowing =
                        _socialCtrl.isFollowing(comment.userName);
                        return GestureDetector(
                          onTap: () => _socialCtrl.toggleFollow(comment),
                          child: Text(
                            isFollowing ? 'Following' : 'Follow',
                            style: AppTextStyles.overline.copyWith(
                                color: isFollowing
                                    ? AppColors.textOnDark
                                    : AppColors.textGreen,
                                fontWeight: FontWeight.bold),
                          ),
                        );
                      },
                    ),
                  ],
                ),
                 SizedBox(height: 6.h),
                _buildCommentBody(comment),
                 SizedBox(height: 10.h),

                Row(
                  children: [
                    // Reply
                    _commentAction(AppAssets.commentIcon, 'Reply',
                        onTap: () => _showWriteCommentSheet(
                          context, widget.id,
                          replyToId: comment.id.toString(),
                          replyToName: comment.userName,
                        )),
                     SizedBox(width: 12.w),

                    // Like
                    Obx(() {
                      final commentId = comment.id.toString();
                      final isLiked = _socialCtrl.isCommentLiked(commentId);
                      final currentLikes =

                      _socialCtrl.getAdjustedLikes(commentId, comment.likes);

                      return _commentAction(AppAssets.likeUpIcon,
                        _socialCtrl.formatCount(currentLikes),

                        onTap: () => _socialCtrl.likeComment(commentId),

                        iconColor: isLiked ? Colors.blue : Colors.white,
                      );
                    }),
                     SizedBox(width: 12.w),

                    // Dislike
                    Obx(() {
                      final commentId = comment.id.toString();
                      final isDisliked = _socialCtrl.isCommentDisliked(commentId);

                      return _commentAction( AppAssets.likeDownIcon, '',
                        onTap: () => _socialCtrl.dislikeComment(commentId),
                        iconColor: isDisliked ? Colors.blue : Colors.white,
                      );
                    }),
                     SizedBox(width: 12.w),

                    // Share
                    _commentAction(AppAssets.shareIcon, 'Share',
                        onTap: () => _socialCtrl.shareContent(
                            comment.id.toString(),
                            type: 'comment')),


                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Flexible(
                            child: Text(
                              timeago.format(
                                  comment.createdAt,
                                  locale: 'en_short'), // 'en_short' dila  1m, 2h, 5h

                              style:TextStyle( color: AppColors.textOnDark, fontSize: 10.sp),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1)),

                           SizedBox(width: 8.w),
                          GestureDetector(
                            onTap: () => _showCommentOptionsSheet(
                                context, widget.id, comment.userName),
                            child: Icon(Icons.more_vert,  color: AppColors.white, size: 20.sp),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildCommentBody(CommentModel comment) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (comment.gifUrl != null && comment.gifUrl!.isNotEmpty)
          _buildMediaFrame(Image.network(comment.gifUrl!,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => const Text(
                  "GIF could not load",
                  style: TextStyle(color: Colors.red)))),
        if (comment.imagePath != null && comment.imagePath!.isNotEmpty)
          _buildMediaFrame(Image.file(File(comment.imagePath!),
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => const Text(
                  "Image error",
                  style: TextStyle(color: Colors.red)))),
        if (comment.text.isNotEmpty) ...[
          if (comment.gifUrl != null || comment.imagePath != null)
             SizedBox(height: 6.h),
          Text(comment.text, style: AppTextStyles.labelMedium),
        ],
      ],
    );
  }

  Widget _buildMediaFrame(Widget child) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8.r),
      child: Container(
          height: 140.h, width: 180.w, color: Colors.black12, child: child),
    );
  }

  Widget _commentAction(String svgIcon, String label,
      {VoidCallback? onTap, Color iconColor = Colors.white}) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset( svgIcon, width: 16.w, height: 16.h,
            colorFilter: ColorFilter.mode(AppColors.white, BlendMode.srcIn)),
          if (label.isNotEmpty) ...[
            SizedBox(width: 4.w),
            Text(label, style: AppTextStyles.labelMedium.copyWith(color:AppColors.white)),
          ],
        ],
      ),
    );
  }

  void _showWriteCommentSheet(BuildContext context, dynamic id,
      {String? replyToId, String? replyToName}) {

    final commentCtrl = Get.find<CommentController>();
    final String type = commentCtrl.currentTabType;
    final String? author = commentCtrl.currentAuthor;

    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        useRootNavigator: true,
        backgroundColor: Colors.transparent,
        constraints:
        BoxConstraints(maxWidth: MediaQuery.of(context).size.width),
        builder: (context) => WriteCommentSheet(
            reelId: id,
            onlyEmoji: false,
            type: type,
            author: author,
            replyToId: replyToId,
            replyToName: replyToName));
  }

  void _showCommentOptionsSheet(
      BuildContext context, dynamic id, String name) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        constraints:
        BoxConstraints(maxWidth: MediaQuery.of(context).size.width),
        builder: (_) => OptionsSheet(reelId: id, authorName: name));
  }
}