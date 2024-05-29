class DomainValidator {
  static String? validate(String? value) {
    if (value == null || value.isEmpty) {
      return null;
    }
    // Regular expression to match a valid domain format
    RegExp regex = RegExp(r'^(?:http(s)?:\/\/)?[\w.-]+\.[a-zA-Z]{2,}(?:\/\S*)?$');
    if (!regex.hasMatch(value)) {
      return 'Invalid domain format';
    }
    return null;
  }
}
