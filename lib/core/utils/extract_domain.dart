String extractDomain(String url) {
  Uri uri = Uri.parse(url);
  return uri.host;
}
