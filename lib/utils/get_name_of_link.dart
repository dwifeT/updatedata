String getNameOfLink(String link) {
  final index = link.lastIndexOf("/");
  return link.substring(index + 1);
}
