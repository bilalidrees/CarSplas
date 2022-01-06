import 'dart:async';
import 'package:hiltonSample/src/bloc/utility/SessionClass.dart';
import 'package:hiltonSample/src/ui/widgets/CustomTitleWidget.dart';
import 'dart:io';
import '../../../../route_generator.dart';
import '../../../bloc/utility/AppConfig.dart';
import 'package:hiltonSample/src/model/Location.dart' as CurrentLocation;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hiltonSample/src/app.dart';
import 'package:hiltonSample/src/bloc/AuthenticationBloc.dart';
import 'package:hiltonSample/src/bloc/utility/AppConfig.dart';
import 'package:hiltonSample/src/ui/ui_constants/ImageAssetsResolver.dart';
import 'package:hiltonSample/src/ui/ui_constants/theme/AppColors.dart';
import 'package:hiltonSample/src/ui/ui_constants/theme/string.dart';
import 'package:hiltonSample/src/ui/ui_constants/theme/style.dart';
import 'package:hiltonSample/src/ui/widgets/CustomButton.dart';
import 'package:hiltonSample/src/ui/widgets/DialogStatus.dart';
import 'package:hiltonSample/src/ui/widgets/LocationPermission.dart';
import 'package:hiltonSample/src/ui/widgets/MySearchLocationWidget.dart';
import 'package:hiltonSample/src/ui/pages/user/CarListScreen.dart';
import 'package:hiltonSample/src/ui/pages/other_module/MainPageNavigator.dart';
import 'package:location/location.dart' as Location;
import 'package:toast/toast.dart';

import '../../../../AppLocalizations.dart';

import '../../../../route_generator.dart';

class LocationScreen extends StatefulWidget {
  LocationScreen();

  @override
  _LocationScreenState createState() => _LocationScreenState();
}

final homeScaffoldKey = GlobalKey<ScaffoldState>();
final searchScaffoldKey = GlobalKey<ScaffoldState>();

class _LocationScreenState extends State<LocationScreen> with RouteAware {
  bool _isVisible = false,
      isLocationSelectedFromSearchBar = false,
      isFindRestaurantButtonEnabled = false;
  Color buttonBackgroundColor = AppColors.buttonDisableColor;
  Color buttonTextColor = AppColors.buttonDisableTextColor;
  Location.Location location = new Location.Location();
  bool _locationServiceEnabled;
  AuthenticationBloc authenticationBloc;
  String selectedAddress = Strings.EMAIL;
  static Position position;

  Widget _rootChild;
  GoogleMapController _controller;
  Completer<GoogleMapController> _mapController = Completer();
  final Set<Marker> _markers = {};

  static LatLng _initialPosition = LatLng(24.8553344, 67.0517562);
  static LatLng _lastMapPosition = _initialPosition;

  bool _isMapMoved = true;
  Timer _mapAddressDelayedTimer;
  TextEditingController _addressTextController = TextEditingController();

  void _onMapCreated(GoogleMapController controller) {
    _controller = controller;
    _mapController.complete(controller);
  }

  void _onCameraMove(CameraPosition position) {
    print("_onCameraMove method called ${position}");

    _lastMapPosition = position.target;

    if (_mapAddressDelayedTimer != null) _mapAddressDelayedTimer.cancel();

    _mapAddressDelayedTimer = new Timer(const Duration(milliseconds: 400), () {
      setState(() {
        _isMapMoved = true;
      });
    });
  }

  Future<void> checkLocationPermision() async {
    Location.PermissionStatus permission = await location.hasPermission();
    if (permission == Location.PermissionStatus.DENIED) {
      setState(() {
        _inverseVisiblity(true);
        _rootChild = findRestaurantWidget();
      });
    } else {
      checkForUserSelectedOption();
    }
  }

  void _getCurrentLocation() async {
    //Position res = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
    final Geolocator geoLocator = Geolocator()..forceAndroidLocationManager;
    Position lastKnownLocation = await geoLocator.getLastKnownPosition(
        desiredAccuracy: LocationAccuracy.best);
    Position res = await geoLocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best);
    setState(() {
      isFindRestaurantButtonEnabled = true;
      print("res : ${res.latitude},${res.longitude} ");
      //position = res;
      _lastMapPosition = LatLng(res.latitude, res.longitude);
      print(
          "_lastMapPosition : ${_lastMapPosition.latitude},${_lastMapPosition.longitude} ");
      _inverseVisiblity(false);
      _isMapMoved = true;
      _rootChild = findRestaurantWidget();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    RouteObservers.routeObserver.subscribe(this, ModalRoute.of(context));
  }

  @override
  void didPush() {
    print('didPush Screen3');
  }

  @override
  void didPopNext() {
    print('didPopNext Screen3');
    checkLocationPermision();
  }

  @override
  void initState() {
    authenticationBloc = AuthenticationBloc();
    checkLocationPermision();
    super.initState();
  }

  void _inverseVisiblity(bool status) {
    setState(() {
      _isVisible = status;
    });
  }

  void updateAddress(String description) {
    setState(() {
      isFindRestaurantButtonEnabled = true;
      //_addressTextController.text = description;
      _rootChild = findRestaurantWidget();
    });
  }

  @override
  Widget build(BuildContext context) {
    print("isMAPmoved  in build method ${_isMapMoved}");

    if (_isMapMoved) {
      setAddress();
    }

    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: _rootChild,
      ),
    );
  }



  Future setAddress() async {
    final coordinates =
        new Coordinates(_lastMapPosition.latitude, _lastMapPosition.longitude);
    var firstLineAddress;
    List<Placemark> placemark;
    try {
      if (Platform.isAndroid) {
        var results =
            await Geocoder.local.findAddressesFromCoordinates(coordinates);
        firstLineAddress = results.first;
      } else if (Platform.isIOS) {
        placemark = await Geolocator().placemarkFromCoordinates(
            _lastMapPosition.latitude, _lastMapPosition.longitude);
      }
      this.setState(() {
        if (_lastMapPosition != _initialPosition) {
          if (Platform.isAndroid) {
            _addressTextController.text = firstLineAddress.addressLine;
          } else {
            _addressTextController.text =
                getAddressFromPlaceMark(placemark.first);
          }
        } else {
          _addressTextController.text = "Current Address";
        }
      });
    } catch (e) {
      print("Error occured: $e");
    } finally {
      _isMapMoved = false;
    }
  }

  Widget findRestaurantWidget() {
    if (_isVisible) {
      return Container(
        decoration: BoxDecoration(
           color: AppColors.appScreenColor,
          // image: DecorationImage(
          //   image: AssetImage(ImageAssetsResolver.APP_BG),
          //   fit: BoxFit.cover,
          //   colorFilter: ColorFilter.mode(Colors.black54, BlendMode.darken),
          // )
        ),
        child: Stack(
          children: <Widget>[
            LocationPermission(
              isPermission: DialogStatus.LOCATION_PERMISSION.index,
//            onPressed: () {
//              askPermission();
//            },
              function: (name) {
                if (name ==
                    AppLocalizations.of(context).translate(Strings.YES)) {
                  setState(() {
                    _inverseVisiblity(false);
                    _rootChild = findRestaurantWidget();
                  });
                  askPermission();
                } else if (name ==
                    AppLocalizations.of(context).translate(Strings.NO)) {
                  setState(() {
                    _inverseVisiblity(false);
                    _rootChild = findRestaurantWidget();
                  });
                }
              },
            ),
          ],
        ),
      );
    } else {
      return Stack(
        children: <Widget>[
          getGoogleMapWidget(),
          Positioned.fill(
            top: AppConfig.of(context).appHeight(0),
            bottom: AppConfig.of(context).appHeight(5),
            right: AppConfig.of(context).appWidth(2),
            child: Center(
              child: Container(
                child: Image.asset(
                  ImageAssetsResolver.GPS_ICON,
                  height: AppConfig.of(context).appHeight(4),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          getDeliveryAddressWidget(),
          Positioned(
            top: 5,
            left: MediaQuery.of(context).size.width * 0.05,
            child: MySearchMapPlaceWidget(
              placeholder: "Search...",
              apiKey: Strings.CREDENTIALS,
              location: _lastMapPosition,
              radius: 1000,
              onSelected: (place) async {
                FocusScope.of(context).requestFocus(new FocusNode());
                setState(() {
                  _isMapMoved = true;
                  isFindRestaurantButtonEnabled = false;
                  _rootChild = findRestaurantWidget();
                });
                final geolocation = await place.geolocation;
                isLocationSelectedFromSearchBar = true;
                // Will animate the GoogleMap camera, taking us to the selected position with an appropriate zoom
                final GoogleMapController controller =
                    await _mapController.future;
                _controller.animateCamera(
                    CameraUpdate.newLatLng(geolocation.coordinates));
                Timer(const Duration(milliseconds: 2500), () {
                  updateAddress(place.description);
                });
                //updateAddress(place.description);
              },
            ),
          ),
        ],
      );
    }
  }

  Positioned getDeliveryAddressWidget() =>
      Positioned(bottom: 0, child: deliveryAddressWidget());

  String getAddressFromPlaceMark(Placemark placemark) {
    print(
        "location : ${placemark.subLocality} ${placemark.administrativeArea} ${placemark.name} ${placemark.postalCode} ${placemark.country}");
    String information;
    if (placemark.locality.isEmpty) {
      if (placemark.subLocality.isEmpty) {
        if (placemark.administrativeArea.isEmpty) {
          information = "";
        } else {
          information = placemark.administrativeArea;
        }
      } else {
        information = placemark.subLocality;
      }
    } else {
      information = placemark.locality;
    }

    return "${placemark.thoroughfare} ${placemark.subThoroughfare}, ${placemark.postalCode} $information ${placemark.country}";
  }

  Widget getGoogleMapWidget() {
    return GoogleMap(
      markers: _markers,
      onMapCreated: (controller) {
        controller.animateCamera(CameraUpdate.newCameraPosition(
          CameraPosition(
            bearing: 0,
//            target: LatLng(position.latitude, position.longitude),
            target: _lastMapPosition,
            zoom: 30.0,
          ),
        ));
        _onMapCreated(controller);
      },
      initialCameraPosition: CameraPosition(
//        target: LatLng(position.latitude, position.longitude),
        target: _lastMapPosition,
        zoom: 30.4746,
      ),
      zoomGesturesEnabled: true,
      onCameraMove: _onCameraMove,
    );
  }

  Widget deliveryAddressWidget() {
    return Container(
      margin: EdgeInsets.all(AppConfig.of(context).appWidth(5)),
      decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black45,
              blurRadius: 1.0, // has the effect of softening the shadow
              spreadRadius: 1.0, // has the effect of extending the shadow
              offset: Offset(
                2.0, // horizontal, move right 10
                2.0, // vertical, move down 10
              ),
            )
          ],
          color: AppColors.white,
          borderRadius: BorderRadius.all(Radius.circular(25.0))),
      height: AppConfig.of(context).appHeight(30),
      width: AppConfig.of(context).appWidth(90),
      child: Column(
        children: <Widget>[
          Center(
            child: Container(
              margin: const EdgeInsets.only(
                  right: 38.0, left: 38.0, top: 20, bottom: 20),
              child: Text(
                "Location",
                style: Theme.of(context).textTheme.display1,
                textAlign: TextAlign.center,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(
                left: AppConfig.of(context).appWidth(3),
                right: AppConfig.of(context).appWidth(3)),
            decoration: BoxDecoration(
                border: Border(
                    bottom: BorderSide(color: AppColors.timberWolf),
                    top: BorderSide(color: AppColors.timberWolf))),
            child: Container(
              margin: EdgeInsets.only(
                left: AppConfig.of(context).appWidth(1),
//                  right: AppConfig.of(context).appWidth(1)
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      enabled: false,
                      controller: _addressTextController,
                      style: TextStyle(
                          fontFamily: 'RobotoCondensed',
                          fontSize: 15.0,
                          color: AppColors(context).accentColor(1)),
                      decoration: InputDecoration(
                        alignLabelWithHint: false,
                        contentPadding: EdgeInsets.only(
                            top: AppConfig.of(context).appHeight(3),
                            bottom: AppConfig.of(context).appHeight(3)),
                        //hintText: selectedAddress,
                        hintStyle: Styles.getDescriptionStyle(),
                        border: InputBorder.none,
                      ),
                      // onChanged: _handlePressButton,
                    ),
                  ),
                  Container(
                    child: IconButton(
                        icon: Icon(
                          Icons.location_searching,
                          color: AppColors.timberWolf,
                        ),
                        onPressed: () async {
                          Position res =
                              await Geolocator().getCurrentPosition();
                          _controller
                              .animateCamera(CameraUpdate.newCameraPosition(
                            CameraPosition(
                              bearing: 0,
                              target: LatLng(res.latitude, res.longitude),
                              zoom: 30.0,
                            ),
                          ));
                        }),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: AppConfig.of(context).appHeight(3)),
          Container(
            padding: getScreenPadding(context),
            child: CustomButton(
              onPressed: () async {
                SessionClass.getInstance().then((sessionClass) {
                  sessionClass.setCurrentLocation(CurrentLocation.Location(
                      address: _addressTextController.text,
                      lat: _lastMapPosition.latitude.toString(),
                      lng: _lastMapPosition.longitude.toString()));
                  print(
                      "${_addressTextController.text},${_lastMapPosition.latitude.toString()},${_lastMapPosition.longitude.toString()}");
                  Navigator.of(context).pushReplacementNamed(
                      RouteNames.MAINPAGE,
                      arguments: ScreenArguments(currentPage: CarListScreen()));
                });
              },
              radius: 10,
              text: "Confirm",
              textColor: isFindRestaurantButtonEnabled
                  ? AppColors.white
                  : buttonTextColor,
              backgorundColor: isFindRestaurantButtonEnabled
                  ? AppColors.of(context).mainColor(1)
                  : buttonBackgroundColor,
              width: AppConfig.of(context).appWidth(80),
              isToShowEndingIcon: false,
            ),
          ),
        ],
      ),
    );
  }

  EdgeInsetsGeometry getScreenPadding(BuildContext context) {
    return EdgeInsets.only(
        left: AppConfig.of(context).appWidth(7.4),
        right: AppConfig.of(context).appWidth(7.4));
  }

  void askPermission() async {
    await location.requestPermission();
    checkForUserSelectedOption();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    RouteObservers.routeObserver.unsubscribe(this);
    super.dispose();
    if (_mapAddressDelayedTimer != null) _mapAddressDelayedTimer.cancel();
  }

  void checkForUserSelectedOption() async {
    var geolocator = Geolocator();
    GeolocationStatus geolocationStatus =
        await geolocator.checkGeolocationPermissionStatus();
    switch (geolocationStatus) {
      case GeolocationStatus.denied:
        break;
      case GeolocationStatus.granted:
        _locationServiceEnabled = await location.serviceEnabled();
        if (!_locationServiceEnabled) {
          _locationServiceEnabled = await location.requestService();
          if (_locationServiceEnabled) {
            _isMapMoved = true;
            _getCurrentLocation();
          } else {
//            setState(() {
//              _rootChild = findRestaurantWidget();
//            });
          }
        } else {
          _isMapMoved = true;
          _getCurrentLocation();
        }
    }
  }
}
