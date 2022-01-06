import 'package:hiltonSample/src/model/Location.dart';
class SessionClass {

  static SessionClass sessionClass;
  static String baseUrl;
  static String _token;
  static String fcmToken;
  static bool isOrderPlaced;
  Location _currentLocation;
  bool isCartItemAddedForPreviousRestaurant = false;

  static Future<SessionClass> getInstance() async {
    if (sessionClass == null) {
      sessionClass = new SessionClass();
    }
    return sessionClass;
  }

  void setBaseUrl(String url) {
    baseUrl = url;
  }

  String getBaseUrl() {
    return baseUrl;
  }

  void setFcmToken(String token) {
    fcmToken = token;
  }

  String getFcmToken() {
    return fcmToken;
  }

  void setIsOrderPlaced(bool order) {
    isOrderPlaced = order;
  }

  bool getIsOrderPlaced() {
    return isOrderPlaced;
  }

  String getToken() {
    return _token;
  }

  bool getCartItemAddedForPreviousRestaurant() {
    return isCartItemAddedForPreviousRestaurant;
  }

  setCartItemAddedForPreviousRestaurant(bool value) {
    isCartItemAddedForPreviousRestaurant = value;
  }
  void setCurrentLocation(Location location){
    _currentLocation=location;
  }
  Location getCurrentLocation(){
    return _currentLocation;
  }
}
