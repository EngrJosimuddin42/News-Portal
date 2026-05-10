import 'package:get/get.dart';

import '../../../models/blog_model.dart';

class BlogController extends GetxController {
  var posts = <BlogPost>[].obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchPosts();
  }

  void fetchPosts() async {
    try {
      isLoading.value = true;
      await Future.delayed(const Duration(milliseconds: 500));

      var dummyData = [
        BlogPost(
            tag: 'Behind the byline',
            title: 'Reviving local journalism',
            body: 'Lorem ipsum dolor sit amet consectetur. Lacus ut habitant id nec erat egestas libero lectus. Ipsum velit dictum sit ultrices porttitor. Tellus justo nascetur pellentesque praesent vitae viverra etiam ipsum a.',
            author: 'Newsbreak',
            date: 'March 4, 2026 16:00',
            imageUrl: 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=600'),
       BlogPost(
         tag: 'Behind the byline',
         title: 'Reviving local journalism',
         body: 'Lorem ipsum dolor sit amet consectetur. Lacus ut habitant id nec erat egestas libero lectus. Ipsum velit dictum sit ultrices porttitor. Tellus justo nascetur pellentesque praesent vitae viverra etiam ipsum a.',
         author: 'Newsbreak',
         date: 'March 4, 2026 16:00',
         imageUrl: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=600'),
        BlogPost(
          tag: 'Behind the byline',
          title: 'Reviving local journalism',
          body: 'Lorem ipsum dolor sit amet consectetur. Lacus ut habitant id nec erat egestas libero lectus. Ipsum velit dictum sit ultrices porttitor. Tellus justo nascetur pellentesque praesent vitae viverra etiam ipsum a.',
          author: 'Newsbreak',
          date: 'March 4, 2026 16:00',
          imageUrl: 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=600'),
      ];

      posts.value = dummyData;
    } finally {
      isLoading.value = false;
    }
  }
}