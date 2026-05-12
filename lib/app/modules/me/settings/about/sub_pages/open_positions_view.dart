import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:news_break/app/theme/app_colors.dart';
import 'package:news_break/app/theme/app_text_styles.dart';
import 'package:news_break/app/modules/me/settings/about/sub_pages/help_widgets.dart';
import '../../../../../controllers/me/settings/open_positions_controller.dart';
import '../../../../../models/job_model.dart';

class OpenPositionsView extends StatefulWidget {
  const OpenPositionsView({super.key});

  @override
  State<OpenPositionsView> createState() => _OpenPositionsViewState();
}

class _OpenPositionsViewState extends State<OpenPositionsView> {

  final controller = Get.put(OpenPositionsController());

  final TextEditingController _searchController = TextEditingController();
  String? _selectedDepartment;
  String? _selectedOffice;
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: HelpWidgets.helpAppBar('Help Center'),
      body: Column(
        children: [
          const HelpTabBar(),
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              // Data filtering and grouping using controller logic
              final filteredJobs = controller.getFilteredJobs(
                query: _searchQuery,
                selectedDept: _selectedDepartment,
                selectedOffice: _selectedOffice);
              final grouped = controller.groupJobs(filteredJobs);

              return ListView(
                children: [
                  _buildHeroSection(),
                  _buildSearchBar(),
                  _buildFilters(),
                  _buildJobsCount(filteredJobs.length),

                  if (grouped.isEmpty)
                    _buildNoJobsFound()
                  else
                    ...grouped.entries.map((entry) => _buildDepartmentGroup(
                      department: entry.key,
                      jobs: entry.value)),

                   SizedBox(height: 16.h),
                  HelpWidgets.helpFooter(),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }

  // Hero Section
  Widget _buildHeroSection() {
    return Padding(
      padding:EdgeInsets.fromLTRB(16.w, 20.h, 16.w, 24.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Current Opening at newsBreak', style: AppTextStyles.chart.copyWith(color: Colors.black)),
          SizedBox(height: 12.h),
          Text('Explore career opportunities and join our mission to deliver news effectively.',
            style: AppTextStyles.overline.copyWith(color: const Color(0xFF6C6C6C)),
          ),
        ],
      ),
    );
  }

  // Search Bar
  Widget _buildSearchBar() {
    return Padding(
      padding:  EdgeInsets.symmetric(horizontal: 16.h),
      child: Container( height: 40,
        decoration: BoxDecoration(
            color: Colors.white,
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(color: Color(0xFFDDDDDD))),
        child: Row(
          children: [
             SizedBox(width: 12.w),
             Icon(Icons.search, color: Color(0xFF9E9E9E), size: 20.sp),
             SizedBox(width: 8.w),
            Expanded(
              child: TextField(
                controller: _searchController,
                onChanged: (v) => setState(() => _searchQuery = v),
                style: AppTextStyles.caption.copyWith(color: Colors.black),
                decoration: InputDecoration(
                  hintText: 'search',
                  hintStyle: AppTextStyles.caption.copyWith(color:AppColors.textOnDark),
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: EdgeInsets.zero))),
          ],
        ),
      ),
    );
  }

  // Filters Section
  Widget _buildFilters() {
    return Padding(
      padding:  EdgeInsets.all(16.w),
      child: Column(
        children: [
          _buildDropdownLabel('Department'),
          _buildDropdown(
            value: _selectedDepartment,
            items: controller.departments,
            onChanged: (v) => setState(() => _selectedDepartment = v),
          ),
           SizedBox(height: 16.h),
          _buildDropdownLabel('Office'),
          _buildDropdown(
            value: _selectedOffice,
            items: controller.offices,
            onChanged: (v) => setState(() => _selectedOffice = v),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdownLabel(String label) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding( padding: EdgeInsets.only(bottom: 12.h),
        child: Text(label, style: AppTextStyles.caption.copyWith(color: Color(0xFF626262)))),
    );
  }

  // Jobs Count
  Widget _buildJobsCount(int count) {
    return Padding( padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: Text('$count jobs', style: AppTextStyles.chart.copyWith(
          color:Color(0xFF282828), fontWeight: FontWeight.w500)),
    );
  }

  // Empty State
  Widget _buildNoJobsFound() {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Center(
        child: Text('No jobs found.', style: AppTextStyles.caption.copyWith(color: Colors.black54))),
    );
  }

  Widget _buildDropdown({
    required String? value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      height: 40.h,
      padding: EdgeInsets.symmetric(horizontal: 14.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6.r),
        border: Border.all(color: const Color(0xFFDDDDDD))),
      child: DropdownButtonHideUnderline(
        child: Theme(
          data: Theme.of(context).copyWith(
            hoverColor: Colors.transparent,
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            focusColor: Colors.transparent),
          child: DropdownButton<String>(
            value: value,
            dropdownColor: AppColors.arrow,
            hint: Text('Select', style: AppTextStyles.overline),
            icon: Icon(Icons.keyboard_arrow_down, color: AppColors.textOnDark, size: 20.sp),
            isExpanded: true,
            focusColor: Colors.transparent,
            items: items.map((item) {
              return DropdownMenuItem<String>(
                value: item,
                child: Text( item,
                  style: AppTextStyles.caption.copyWith(color: AppColors.white)),
              );
            }).toList(),
            selectedItemBuilder: (BuildContext context) {
              return items.map<Widget>((String item) {
                return Align( alignment: Alignment.centerLeft,
                  child: Text( item,
                    style: AppTextStyles.caption.copyWith(color: const Color(0xFF0D0D0D))),
                );
              }).toList();
            },
            onChanged: onChanged,
          ),
        ),
      ),
    );
  }

  // Department Group
  Widget _buildDepartmentGroup({required String department, required List<JobListing> jobs}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(department, style: AppTextStyles.head.copyWith(color:Color(0xFF466EB6))),
           SizedBox(height: 20.h),
          ...jobs.map((job) => _buildJobTile(job)),
        ],
      ),
    );
  }

  // Job Tile
  Widget _buildJobTile(JobListing job) {
    return GestureDetector(
      onTap: () => {},
      child: Padding( padding: EdgeInsets.only(bottom: 8.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(job.title, style: AppTextStyles.button.copyWith(color:Color(0xFF242424))),
            SizedBox(height: 2.h),
            Text(job.location, style: AppTextStyles.caption.copyWith(color: const Color(0xFF6C6C6C))),
          ],
        ),
      ),
    );
  }
}