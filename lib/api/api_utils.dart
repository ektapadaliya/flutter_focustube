class ApiUtils {
  static const domain = "www.focustube.co.in";

  static const baseUrl = "https://$domain/api/";
  static const authorizationToken = "Wxk82YrEOhSRSG5tgS7nWeT6ePufDtVNCoXBESoz";

  static const me = "${baseUrl}me";
  static const pages = "${baseUrl}pages";
  static const login = "${baseUrl}login";
  static const logout = "${baseUrl}logout";
  static const signup = "${baseUrl}signup";
  static const appInfo = "${baseUrl}app-info";
  static const verifyCode = "${baseUrl}verify-code";
  static const resendEmail = "${baseUrl}resend-email";
  static const resetPassword = "${baseUrl}reset-password";
  static const generateToken = "${baseUrl}generate-token";
  static const forgotPassword = "${baseUrl}forgot-password";
  static const signupVerifyCode = "${baseUrl}signup-verify-code";

  static const updateDailyLimit = "${baseUrl}update-daily-limit";
  static const updateNotificationPreference =
      "${baseUrl}update-notification-preference";

  static const interests = "${baseUrl}interests";
  static const updateInterest = "${baseUrl}update-interest";
  static const getUserInterests = "${baseUrl}get-user-interests";
  static const editProfile = "${baseUrl}edit-profile";

  static const changePassword = "${baseUrl}change-password";
  static const deleteAccount = "${baseUrl}delete-account";

  static const getBookmarkVideos = "${baseUrl}get-bookmark-videos";
  static const getRecommenedVideos = "${baseUrl}get-recommened-videos";
  static const getPopularVideos = "${baseUrl}get-popular-videos";
  static const subjects = "${baseUrl}subjects";
  static const subsubjects = "${baseUrl}subsubjects";
  static const updateSubject = "${baseUrl}update-subject";
  static const bookmarkVideo = "${baseUrl}bookmark-video";
  static const getSubjectVideos = "${baseUrl}get-subject-videos";
  static const getMySubjectVideos = "${baseUrl}get-my-subject-videos";
  static const getVideos = "${baseUrl}get-videos";
  static const getVideoDetails = "${baseUrl}get-video-details";
  static const addVideoFeedback = "${baseUrl}add-video-feedback";
  static const playlistList = "${baseUrl}playlist/list";
  static const playlistCreate = "${baseUrl}playlist/create";
  static const playlistEdit = "${baseUrl}playlist/edit";
  static const playlistDelete = "${baseUrl}playlist/delete";
  static const playlistDetail = "${baseUrl}playlist/detail";

  static const playlistVideoAdd = "${baseUrl}playlist/video/add";
  static const playlistVideoDelete = "${baseUrl}playlist/video/delete";
  static const playlistVideoList = "${baseUrl}playlist/video/list";
  static const noteCreate = "${baseUrl}note/create";
  static const noteEdit = "${baseUrl}note/edit";
  static const noteDelete = "${baseUrl}note/delete";
  static const noteList = "${baseUrl}note/list";
  static const setDailyGoal = "${baseUrl}daily-goal/set";
  static const getDailyGoal = "${baseUrl}daily-goal/list";
  static const getDailyGoalVideo = "${baseUrl}daily-goal/videos";
  static const getMyHistory = "${baseUrl}get-my-history";

  static const channelCurated = "${baseUrl}channel/curated";
  static const channelScholartube = "${baseUrl}channel/scholartube";
  static const channelMe = "${baseUrl}channel/me";
  static const channelAdd = "${baseUrl}channel/add";
}
