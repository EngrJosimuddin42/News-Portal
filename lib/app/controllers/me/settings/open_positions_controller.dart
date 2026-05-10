import 'package:get/get.dart';
import '../../../models/job_model.dart';

class OpenPositionsController extends GetxController {
  var allJobs = <JobListing>[].obs;
  var departments = <String>[].obs;
  var offices = <String>[].obs;
  var isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchJobs();
  }

  void fetchJobs() async {
    try {
      isLoading(true);
      await Future.delayed(const Duration(seconds: 1));

      var dummyJobs = [
        JobListing(title: 'AI Development Engineer', location: 'CA, USA', department: 'Engineering',office:'Mountain view office'),
        JobListing(title: 'AI Development Engineer', location: 'CA, USA', department: 'Engineering',office: 'Mountain view office'),
        JobListing(title: 'AI Development Engineer', location: 'CA, USA', department: 'Product and Design',office:'Remote' ),
        JobListing(title: 'AI Development Engineer', location: 'CA, USA', department: 'Product and Design',office: 'Remote'),
        JobListing(title: 'Backend Engineer', location: 'CA, USA', department: 'Engineering',office: 'Remote'),
        JobListing(title: 'iOS Developer', location: 'CA, USA', department: 'Engineering',office: 'Dhaka Office'),
        JobListing(title: 'UX Designer', location: 'CA, USA', department: 'Product and Design',office: 'Remote'),
        JobListing(title: 'Software Intern', location: 'CA, USA', department: 'Internship Program',office: 'Dhaka Office'),
        JobListing(title: 'Product Manager', location: 'CA, USA', department: 'Product and Design',office: 'Mountain view office'),
      ];
      allJobs.assignAll(dummyJobs);

      departments.assignAll( allJobs.map((job) => job.department).toSet().toList());

      offices.assignAll(allJobs.map((job) => job.office).toSet().toList()..sort());
    } finally {
      isLoading(false);
    }
  }

  List<JobListing> getFilteredJobs({
    required String query,
    String? selectedDept,
    String? selectedOffice,
  }) {
    final searchTerm = query.trim().toLowerCase();

    return allJobs.where((job) {
      final matchesDept = selectedDept == null || job.department == selectedDept;
      final matchesOffice = selectedOffice == null || job.office == selectedOffice;
      final matchesSearch = searchTerm.isEmpty || job.title.toLowerCase().contains(searchTerm) || job.department.toLowerCase().contains(searchTerm);
      return matchesDept && matchesOffice && matchesSearch;
    }).toList();
  }

  Map<String, List<JobListing>> groupJobs(List<JobListing> filteredList) {
    final Map<String, List<JobListing>> grouped = {};
    for (final job in filteredList) {
      grouped.putIfAbsent(job.department, () => []).add(job);
    }
    return grouped;
  }
}