import 'package:flutter/material.dart';
import 'package:sprylife/components/colors.dart';


class ProgressBar extends StatelessWidget {
  final int currentStep;
  final int totalSteps;

  const ProgressBar({super.key, 
    required this.currentStep,
    required this.totalSteps,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 200, // Ajuste a largura conforme necessário
          child: Stack(
            children: [
              Container(
                height: 8, // Ajuste a altura conforme necessário
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              LayoutBuilder(
                builder: (context, constraints) {
                  return Container(
                    width: constraints.maxWidth * (currentStep / totalSteps),
                    height: 8, // Ajuste a altura conforme necessário
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                          colors: [personalColor, secondaryColor],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
        SizedBox(width: 8),
        Text(
          '$currentStep/$totalSteps',
          style: TextStyle(
              color: personalColor, fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ],
    );
  }
}
