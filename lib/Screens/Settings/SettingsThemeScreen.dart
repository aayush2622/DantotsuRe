
import 'package:dantotsu/Widgets/AlertDialogBuilder.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../Adaptor/Settings/SettingsAdaptor.dart';
import '../../DataClass/Setting.dart';
import '../../Functions/Function.dart';
import '../../Preferences/PrefManager.dart';
import '../../Preferences/Preferences.dart';
import '../../Theme/CustomColorPicker.dart';
import '../../Theme/ThemeManager.dart';
import '../../Theme/ThemeProvider.dart';
import '../../Widgets/ScrollConfig.dart';
import 'Widgets/SettingsHeader.dart';

class SettingsThemeScreen extends StatelessWidget {
  const SettingsThemeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context).colorScheme;
    return Scaffold(
      body: CustomScrollConfig(
        context,
        children: [
          SliverToBoxAdapter(
            child: SettingsHeader(
                context,
                'Theme',
                Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: Icon(
                    size: 52,
                    Icons.color_lens_outlined,
                    color: theme.onSurface,
                  ),
                )),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            sliver: SliverList(
              delegate: SliverChildListDelegate(
                [
                  const ThemeDropdown(),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                    ),
                    child: SettingsAdaptor(
                      settings: _buildSettings(context),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Setting> _buildSettings(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    return [
      Setting(
        type: SettingType.switchType,
        name: 'Dark Mode',
        description: 'Enable Dark Mode',
        icon: Icons.dark_mode,
        isChecked: themeNotifier.isDarkMode,
        onSwitchChange: (bool value) async {
          themeNotifier.setDarkMode(value);
        },
      ),
      Setting(
        type: SettingType.switchType,
        name: 'OLED theme Variant',
        description: 'Enable OLED Mode',
        icon: Icons.brightness_4,
        isChecked: themeNotifier.isOled,
        onSwitchChange: (bool value) async {
          themeNotifier.setOled(value);
        },
      ),
      Setting(
        type: SettingType.switchType,
        name: 'Material You',
        description: 'Use the same color as your wallpaper',
        icon: Icons.new_releases,
        //isVisible: Platform.isAndroid,
        isChecked: themeNotifier.useMaterialYou,
        onSwitchChange: (bool value) async {
          themeNotifier.setMaterialYou(value);
        },
      ),
      Setting(
        type: SettingType.switchType,
        name: 'Custom theme',
        description: 'Use your own color for the theme',
        icon: Icons.color_lens_outlined,
        isChecked: themeNotifier.useCustomColor,
        onSwitchChange: (bool value) async {
          themeNotifier.useCustomTheme(value);
        },
      ),
      Setting(
        type: SettingType.normal,
        name: 'Color Picker',
        description: 'Choose a color',
        icon: Icons.color_lens_outlined,
        onClick: () async {
          var color = themeNotifier.customColor;
          Color? newColor = await showColorPickerDialog(context, Color(color));
          if (newColor != null) {
            themeNotifier.setCustomColor(newColor);
          }
        },
      ),
      Setting(
        type: SettingType.normal,
        name: 'Manage Layouts on Anime Page',
        description: 'Does not belong here',
        icon: Icons.palette,
        onClick: () async {
          final homeLayoutMap = PrefManager.getVal(PrefName.animeLayout);
          List<String> titles = List<String>.from(homeLayoutMap.keys.toList());
          List<bool> checkedStates =
              List<bool>.from(homeLayoutMap.values.toList());

          AlertDialogBuilder(context)
            ..setTitle('Manage Layouts on Anime Page')
            ..reorderableMultiSelectableItems(
              titles,
              checkedStates,
              (reorderedItems) => titles = reorderedItems,
              (newCheckedStates) => checkedStates = newCheckedStates,
            )
            ..setPositiveButton('OK', () {
              PrefManager.setVal(PrefName.animeLayout,
                  Map.fromIterables(titles, checkedStates));
              Refresh.activity[2]?.value = true;
            })
            ..setNegativeButton("Cancel", null)
            ..show();
        },
      ),
      Setting(
        type: SettingType.normal,
        name: 'Manage Layouts on Manga Page',
        description: 'Does not belong here',
        icon: Icons.palette,
        onClick: () async {
          final homeLayoutMap = PrefManager.getVal(PrefName.mangaLayout);
          List<String> titles = List<String>.from(homeLayoutMap.keys.toList());
          List<bool> checkedStates =
              List<bool>.from(homeLayoutMap.values.toList());

          AlertDialogBuilder(context)
            ..setTitle('Manage Layouts on Manga Page')
            ..reorderableMultiSelectableItems(
              titles,
              checkedStates,
              (reorderedItems) => titles = reorderedItems,
              (newCheckedStates) => checkedStates = newCheckedStates,
            )
            ..setPositiveButton('OK', () {
              PrefManager.setVal(PrefName.mangaLayout,
                  Map.fromIterables(titles, checkedStates));
              Refresh.activity[3]?.value = true;
            })
            ..setNegativeButton("Cancel", null)
            ..show();
        },
      ),
      Setting(
        type: SettingType.normal,
        name: 'Manage Layouts on Home Page',
        description: 'Does not belong here',
        icon: Icons.palette,
        onClick: () async {
          final homeLayoutMap = PrefManager.getVal(PrefName.homeLayout);
          List<String> titles = List<String>.from(homeLayoutMap.keys.toList());
          List<bool> checkedStates =
              List<bool>.from(homeLayoutMap.values.toList());

          AlertDialogBuilder(context)
            ..setTitle('Manage Layouts on Home Page')
            ..reorderableMultiSelectableItems(
              titles,
              checkedStates,
              (reorderedItems) => titles = reorderedItems,
              (newCheckedStates) => checkedStates = newCheckedStates,
            )
            ..setPositiveButton('OK', () {
              PrefManager.setVal(PrefName.homeLayout,
                  Map.fromIterables(titles, checkedStates));
              Refresh.activity[1]?.value = true;
            })
            ..setNegativeButton("Cancel", null)
            ..show();
        },
      ),
    ];
  }
}

//TODO
class ThemeSelector extends StatefulWidget {
  const ThemeSelector({super.key});

  @override
  ThemeSelectorState createState() => ThemeSelectorState();
}

class ThemeSelectorState extends State<ThemeSelector> {
  int selectedMode = 0;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Expanded(
            child: Opacity(
              opacity: 0.58,
              child: Text(
                'Theme',
                style: TextStyle(
                    fontFamily: 'Poppins', fontWeight: FontWeight.bold),
              ),
            ),
          ),
          _buildThemeButton(
            icon: Icons.brightness_high,
            mode: 1,
          ),
          const SizedBox(width: 8),
          _buildThemeButton(
            icon: Icons.brightness_4,
            mode: 2,
          ),
          const SizedBox(width: 8),
          _buildThemeButton(
            icon: Icons.brightness_auto,
            mode: 0,
          ),
        ],
      ),
    );
  }

  Widget _buildThemeButton({required IconData icon, required int mode}) {
    return Card(
      color: Colors.grey.shade800,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 0,
      child: IconButton(
        icon: Icon(icon),
        iconSize: 24,
        onPressed: () {
          setState(() {
            selectedMode = mode; // Update the selected mode
          });
        },
        color: selectedMode == mode
            ? Colors.white.withOpacity(1.0)
            : Colors.white.withOpacity(0.33),
      ),
    );
  }
}
