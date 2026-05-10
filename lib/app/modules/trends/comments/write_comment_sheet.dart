import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:news_break/app/theme/app_assets.dart';
import 'package:news_break/app/widgets/bottom_sheet_handle.dart';
import '../../../controllers/reels/comment_controller.dart';
import '../../../controllers/social_interaction_controller.dart';
import '../../../controllers/social_utility_controller.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_text_styles.dart';
import '../../../widgets/my_gif_picker.dart';

class WriteCommentSheet extends StatefulWidget {
  final dynamic reelId;
  final String type;
  final String? replyToId;
  final String? replyToName;
  final bool onlyEmoji;
  final String? author;
  const WriteCommentSheet({
    super.key, required this.reelId,this.type = 'news',this.replyToId,this.replyToName,this.author, this.onlyEmoji = false});

  @override
  State<WriteCommentSheet> createState() => _WriteCommentSheetState();
}

class _WriteCommentSheetState extends State<WriteCommentSheet> {
  final commentController = Get.find<CommentController>();
  final utility = Get.find<SocialUtilityController>();

  @override
  void dispose() {
    utility.clearAllMedia();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (utility.isGifPickerMode.value) {
        return MyGifPicker(controller: utility);
      }
      return _buildWriteComment();
    });
  }

  Widget _buildWriteComment() {
    return Container(
      padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom),
      decoration: BoxDecoration(
          color:AppColors.sheet,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20.r))),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
             SizedBox(height: 12.h),
            _buildTopBar(),
            SizedBox(height: 12.h),
            _buildMediaPreview(),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: TextField(
                  controller: commentController.commentTextController,
                autofocus: true,
                maxLines: null,
                style: AppTextStyles.labelMedium,
                decoration: InputDecoration(
                    hintText: 'Write a comment...',
                    hintStyle: AppTextStyles.overline,
                    border: InputBorder.none))),

            _buildReactionRow(),

             Divider(color:AppColors.border, height: 1),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
              child: Row(
                children: [
                  if (!widget.onlyEmoji) ...[
                  IconButton(
                      onPressed: utility.pickImage,
                      icon:  Icon(Icons.image_outlined, color: AppColors.white, size: 22.sp)),
                   SizedBox(width: 4.w),

                  GestureDetector(
                      onTap: () => utility.isGifPickerMode.value = true,
                      child: Container(
                          padding:EdgeInsets.symmetric( horizontal: 6.w, vertical: 2.h),
                          decoration: BoxDecoration(
                              border: Border.all(color: AppColors.white),
                              borderRadius: BorderRadius.circular(6.r)),
                          child: Text('GIF', style: AppTextStyles.display.copyWith(fontSize: 10.sp))))],
                  const Spacer(),
                  Obx(() => commentController.isSendingComment.value
                      ?  SizedBox(width: 24.w, height: 24.h,
                      child: CircularProgressIndicator( strokeWidth: 2, color: AppColors.white))
                      : GestureDetector(
                    onTap: () async {
                      final text = commentController.commentTextController.text.trim();
                      if (widget.onlyEmoji) {
                        if (text.isNotEmpty) {
                          final socialCtrl = Get.find<SocialInteractionController>();
                          socialCtrl.updateReaction(widget.reelId, widget.type, text);
                          socialCtrl.incrementReactionCount(widget.reelId, source: widget.type);
                          commentController.commentTextController.clear();
                          Get.back();
                        }
                      } else {
                        final String? gifUrl = utility.selectedGifUrl.value;
                        final String? imagePath = utility.selectedImage.value?.path;
                        await commentController.submitComment(
                          widget.reelId,
                          gifUrl: gifUrl,
                          imagePath: imagePath,
                        );

                        if (widget.type == 'news') {
                          final commentCtrl = Get.find<CommentController>();
                          final news = commentCtrl.currentNews;
                          if (news != null) {
                            final socialCtrl = Get.find<SocialInteractionController>();
                            if (!socialCtrl.commentedNewsItems.any((n) => n.id == news.id)) {
                              socialCtrl.commentedNewsItems.add(news);
                            }
                          }
                        }
                      }
                    },

                    child: Container(
                      width: 32.w,
                      height: 32.h,
                      decoration: BoxDecoration(
                        color: Get.isDarkMode? Color(0xFF07345A):Color(0xFFA5D3F8),
                        shape: BoxShape.circle),
                      child: Center(
                        child: SvgPicture.asset(AppAssets.send1Icon, height: 18.h, width: 18.w,
                          colorFilter:ColorFilter.mode(AppColors.white, BlendMode.srcIn)))))),
                ],
              ),
            ),
             SizedBox(height: 40.h),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          const BottomSheetHandle(),
          SizedBox(height: 16.h),
          RichText(
            textAlign: TextAlign.start,
            text: TextSpan(style: AppTextStyles.overline,
              children: [
                const TextSpan(text: 'Please be respectful. Make sure your comment meets our '),
                TextSpan(text: 'community Guidlines', style: AppTextStyles.overline.copyWith(
                        color: AppColors.textGreen,
                        decoration: TextDecoration.underline)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMediaPreview() {
    return Obx(() {
      final gif = utility.selectedGifUrl.value;
      final image = utility.selectedImage.value;
      final bytes = utility.selectedImageBytes.value;

      if ((gif == null || gif.isEmpty) && image == null && bytes == null) {
        return const SizedBox.shrink();
      }

      return Padding(
        padding:EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12.r),
              child: (gif != null && gif.isNotEmpty)
                  ? Image.network(gif,
                  height: 120.h, width: 160.w, fit: BoxFit.cover)
                  : kIsWeb
                  ? Image.memory(bytes!,
                  height: 120.h, width: 160.w, fit: BoxFit.cover)
                  : Image.file(File(image!.path),
                  height: 120.h, width: 160.w, fit: BoxFit.cover)),
            Positioned(right: 5.w, top: 5.h,
              child: GestureDetector(
                onTap: utility.clearAllMedia,
                child: CircleAvatar(radius: 12.r, backgroundColor: Colors.black54,
                    child: Icon(Icons.close, size: 16.sp, color: Colors.white)))),
          ],
        ),
      );
    });
  }

  Widget _buildReactionRow() {
    final utility = Get.find<SocialUtilityController>();

    return Padding(
      padding:  EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: utility.reactions.map((emoji) {
            return Padding(
              padding:  EdgeInsets.symmetric(horizontal: 6.w),
              child: GestureDetector(
                onTap: () {
                  final controller = commentController.commentTextController;
                  final text = controller.text;
                  final selection = controller.selection;
                  final cursorPos = selection.base.offset < 0 ? text.length : selection.base.offset;
                  final newText = text.substring(0, cursorPos) + emoji + text.substring(cursorPos);
                  controller.text = newText;
                  controller.selection = TextSelection.fromPosition(
                    TextPosition(offset: cursorPos + emoji.length),
                  );
                },
                child: Text(emoji, style:TextStyle(fontSize: 22.sp)),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
  }