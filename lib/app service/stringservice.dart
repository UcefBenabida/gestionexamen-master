class StringService {
  static String capitalizeString(String name) {
    return '${name[0].toUpperCase()}${name.substring(1).toLowerCase()}';
  }
}
