/// Capitalize first letter of each word in given [String]
/// converts 'broken clouds' to 'Broken Clouds'

extension StringExtention on String {
  String capitalize() {
    return split(' ').map((word) => '${word[0].toUpperCase()}${word.substring(1)}').join(' ');
  }
}
