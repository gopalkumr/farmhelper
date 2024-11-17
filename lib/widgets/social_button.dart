import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:farmhelp/helper/colors.dart';

class SocialButton extends StatelessWidget {
  const SocialButton({
    super.key,
    required this.name,
    required this.icon,
    required this.onPressed, // Add the onPressed parameter
    this.appleLogo = false,
  });

  final String name;
  final String icon;
  final VoidCallback onPressed; // Define the type for onPressed
  final bool appleLogo;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed, // Use the provided onPressed function
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
          side: const BorderSide(
            width: 0.1,
            color: Colors.white,
            style: BorderStyle.solid,
          ),
        ),
        backgroundColor: ColorSys.kSecondary,
        padding: EdgeInsets.all(MediaQuery.of(context).size.width / 30),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          appleLogo
              ? SvgPicture.asset(
                  icon,
                  height: 30.0,
                  colorFilter: const ColorFilter.mode(
                    Colors.white,
                    BlendMode.srcIn,
                  ),
                )
              : SvgPicture.asset(
                  icon,
                  height: 30.0,
                ),
          const SizedBox(width: 16.0),
          Text(
            name,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w400,
                ),
          ),
        ],
      ),
    );
  }
}
