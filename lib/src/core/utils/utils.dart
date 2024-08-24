
// Logger extension to print the exception
extension LoggerExtension on Exception {
  void log() {
    print(toString());
  }
}