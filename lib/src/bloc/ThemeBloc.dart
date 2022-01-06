import 'bloc_provider.dart';
import 'package:rxdart/rxdart.dart';

class ThemeBloc implements BlocBase {
  static ThemeBloc themeBloc;
  bool isDarkThemeSelected;

  final themeStreamController = BehaviorSubject<bool>();

  Stream<bool> get darkThemeIsEnabled => themeStreamController.stream;

  ThemeBloc({this.isDarkThemeSelected});

  static ThemeBloc getInstance({bool darkTheme}) {
    if (themeBloc == null) {
      print("instance created");
      themeBloc = ThemeBloc(isDarkThemeSelected: darkTheme);
    }
    return themeBloc;
  }

  bool changeTheTheme()  {
    return !isDarkThemeSelected;
  }

  @override
  void dispose() {
    themeStreamController.close();
  }
}
