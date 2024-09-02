import 'package:dantotsu/Functions/Extensions.dart';
import 'package:flutter/material.dart';

  Widget SettingsHeader(BuildContext context, String title, Widget icon) {
    var theme = Theme.of(context).colorScheme;
    return SizedBox(
      height: 200.statusBar(),
      child: Stack(
        children: [
          Positioned(
            top: 42.statusBar(),
            left: 24,
            child: Card(
              elevation: 0,
              color: theme.surface,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: IconButton(
                icon: Icon(Icons.arrow_back_ios_new, color: theme.onSurface),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
          ),
          Positioned(
            top: 124.statusBar(),
            left: 32,
            right: 16,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 28,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.bold,
                  ),
                ),
                icon,
              ],
            ),
          ),
        ],
      ),
    );
  }