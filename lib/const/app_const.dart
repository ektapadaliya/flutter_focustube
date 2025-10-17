import 'package:flutter/material.dart';
import 'package:focus_tube_flutter/const/app_image.dart';

class AppConst {
  //App Name
  static const appName = "FocusTube";

  //App Bundle ID
  static const appBundleId = "com.heelfinfotech.focustube";

  /// The maximum width (in logical pixels) that form fields and buttons
  /// should occupy when the device is in landscape orientation.
  static const double kMaxLandscapeFormWidth = 700.0;

  /// Returns `true` if the device is currently in landscape orientation.
  static bool isLandscape(context) =>
      MediaQuery.of(context).orientation == Orientation.landscape;

  /// Returns `true` if the device is currently in portrait orientation.
  static bool isPortrait(context) =>
      MediaQuery.of(context).orientation == Orientation.portrait;

  /// Returns the maximum available width for the current screen.
  static double maxWidth(BuildContext context) =>
      MediaQuery.of(context).size.width;

  /// Returns the maximum available height for the current screen.
  static double maxHeight(BuildContext context) =>
      MediaQuery.of(context).size.height;

  static final List<UserInterestModel> userInterests = [
    UserInterestModel(
      id: "education_knowledge",
      image: AppImage.educationKnowledge,
      title: "Education & Knowledge",
      description: "Learning, academic subjects, tutorials, and lectures.",
    ),
    UserInterestModel(
      id: "science_technology",
      image: AppImage.scienceTechnology,
      title: "Science & Technology",
      description: "Research, innovation, coding, AI, and engineering.",
    ),
    UserInterestModel(
      id: "business_finance",
      image: AppImage.businessFinance,
      title: "Business & Finance",
      description: "Entrepreneurship, economics, investing, and careers.",
    ),
    UserInterestModel(
      id: "society_politics",
      image: AppImage.societyPolitics,
      title: "Society & Politics",
      description: "News, commentary, law, global issues, and activism.",
    ),
    UserInterestModel(
      id: "health_wellness",
      image: AppImage.healthWellness,
      title: "Health & Wellness",
      description: "Medicine, fitness, psychology, nutrition, and mindfulness.",
    ),
    UserInterestModel(
      id: "arts_creativity",
      image: AppImage.artsCreativity,
      title: "Arts & Creativity",
      description:
          "Design, illustration, crafts, photography, and performance art.",
    ),
    UserInterestModel(
      id: "music_performance",
      image: AppImage.musicPerformance,
      title: "Music & Performance",
      description: "Instruments, covers, concerts, dance, and composition.",
    ),
    UserInterestModel(
      id: "philosophy_culture",
      image: AppImage.philosophyCulture,
      title: "Philosophy & Culture",
      description: "Ideas, traditions, ethics, anthropology, and spirituality.",
    ),
    UserInterestModel(
      id: "mind_spirit",
      image: AppImage.mindSpirit,
      title: "Mind & Spirit",
      description:
          "Meditation, religion, inner growth, and philosophy of life.",
    ),
    UserInterestModel(
      id: "travel_exploration",
      image: AppImage.travelExploration,
      title: "Travel & Exploration",
      description: "Geography, adventure, cultural discovery, and vlogs.",
    ),
    UserInterestModel(
      id: "lifestyle_home",
      image: AppImage.lifestyleHome,
      title: "Lifestyle & Home",
      description:
          "Living, organization, parenting, minimalism, and home decor.",
    ),
    UserInterestModel(
      id: "food_cooking",
      image: AppImage.foodCooking,
      title: "Food & Cooking",
      description:
          "Recipes, cuisine, culinary education, and restaurant culture.",
    ),
    UserInterestModel(
      id: "fashion_beauty",
      image: AppImage.fashionBeauty,
      title: "Fashion & Beauty",
      description: "Style, grooming, makeup, trends, and self-expression.",
    ),
    UserInterestModel(
      id: "gaming_esports",
      image: AppImage.gamingEsports,
      title: "Gaming & Esports",
      description: "Playthroughs, commentary, tournaments, and game design.",
    ),
    UserInterestModel(
      id: "film_entertainment",
      image: AppImage.filmEntertainment,
      title: "Film & Entertainment",
      description: "Movies, reviews, comedy, animation, and pop culture.",
    ),
    UserInterestModel(
      id: "media_storytelling",
      image: AppImage.mediaStorytelling,
      title: "Media & Storytelling",
      description:
          "Podcasts, documentaries, journalism, writing, and interviews.",
    ),
    UserInterestModel(
      id: "vehicles_engineering",
      image: AppImage.vehiclesEngineering,
      title: "Vehicles & Engineering",
      description: "Cars, machines, aviation, and mechanical builds.",
    ),
    UserInterestModel(
      id: "nature_environment",
      image: AppImage.natureEnvironment,
      title: "Nature & Environment",
      description: "Wildlife, pets, sustainability, climate, and outdoor life.",
    ),
    UserInterestModel(
      id: "social_media_people",
      image: AppImage.socialMediaPeople,
      title: "Social Media & People",
      description: "Influencers, vlogs, challenges, and live content.",
    ),
    UserInterestModel(
      id: "experimental_future",
      image: AppImage.experimentalFuture,
      title: "Experimental & Future",
      description: "VR, digital art, futurism, and creative experiments.",
    ),
  ];
}

class UserInterestModel {
  final String id;
  final String image;
  final String title;
  final String description;

  const UserInterestModel({
    required this.id,
    required this.image,
    required this.title,
    required this.description,
  });
}
