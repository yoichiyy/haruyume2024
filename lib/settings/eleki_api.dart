class GoogleApiSettings {
  static const String spreadsSheetsUrl =
      "1fMdeCbePbmxmJ_3rjz69g-ng1dOaoyuR9zZl6KugPy8";
  static const String sheetName = "book";
  static const String apiKey = "AIzaSyAnoJBdD1vfTUXImK3ap8DJNBQbaO5svR4";

  static String getGoogleSheet() {
    if (spreadsSheetsUrl.isEmpty || sheetName.isEmpty || apiKey.isEmpty) {
      throw ('please set google api settings.');
    }
    return 'https://sheets.googleapis.com/v4/spreadsheets/$spreadsSheetsUrl/values/$sheetName?key=$apiKey';
  }
}

