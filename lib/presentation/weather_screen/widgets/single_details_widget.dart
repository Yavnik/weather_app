import 'package:flutter/material.dart';
import 'package:weather_app/presentation/core/colors.dart';

class SingleDetailsWidget extends StatelessWidget {
  final String title;
  final String value;
  final IconData iconData;
  const SingleDetailsWidget({super.key, required this.title, required this.value, required this.iconData});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 65,
      decoration: BoxDecoration(
        color: ColorPallete.primaryContainer,
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            radius: 16,
            child: Icon(iconData, size: 16),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
