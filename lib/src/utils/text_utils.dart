class TextUtils {
  static String cutTextRange(String text, int init, {int? end}) {
    String textFormated = "";
    if (end == null) {
      //only initial part
      textFormated = text.substring(init);
    } else {
      textFormated = text.substring(init, end);
    }
    return textFormated;
  }
}
