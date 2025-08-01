// Boy kısmı
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_text_styles.dart';

class SliderCard extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final RxDouble value;
  final double min;
  final double max;
  final int divisions;
  final String unit;
  final ValueChanged<double> onChanged;
  final bool isExpandable; // Kartın açılır kapanır olup olmayacağı
  final RxBool isExpanded = false.obs; // Kartın genişletilmiş durumu

  SliderCard({
    Key? key,
    required this.title,
    required this.description,
    required this.icon,
    required this.value,
    required this.min,
    required this.max,
    required this.divisions,
    required this.unit,
    required this.onChanged,
    this.isExpandable = false, // Varsayılan olarak genişletilebilir değil
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (isExpandable) isExpanded.toggle(); // Kart tıklanınca genişleme durumu değiştir
      },
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [AppColors.primaryColor, AppColors.accentColor],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.4),
              spreadRadius: 3,
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 30.0, color: Colors.white),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    title,
                    style: AppTextStyles.heading.copyWith(fontSize: 18, color: Colors.white),
                  ),
                ),
                if (isExpandable) // Sadece açılabilir olduğunda ok işareti göster
                  Obx(() => Icon(
                    isExpanded.value ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                    color: Colors.white70,
                  )),
              ],
            ),
            Obx(() {
              if (!isExpanded.value && isExpandable) return const SizedBox.shrink(); // Kapalıysa gizle
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  Text(description, style: const TextStyle(color: Colors.white70)),
                  const SizedBox(height: 10),
                  Slider(
                    value: value.value,
                    min: min,
                    max: max,
                    divisions: divisions,
                    label: '${value.value.round()} $unit',
                    onChanged: onChanged,
                  ),
                  Text(
                    '${value.value.round()} $unit',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ],
              );
            }),
          ],
        ),
      ),
    );
  }
}
