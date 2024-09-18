enum ResourceType { video, image }

extension TypeParsing on ResourceType {
  String typeString() {
    switch (this) {
      case ResourceType.video:
        return "video";
      case ResourceType.image:
        return "image";
    }
  }
}
