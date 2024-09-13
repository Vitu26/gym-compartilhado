import 'package:flutter/material.dart';
import 'package:sprylife/utils/colors.dart';

class ProgressBar extends StatelessWidget {
  final int currentStep;
  final int totalSteps;
  final Color color;

  const ProgressBar({
    required this.currentStep,
    required this.totalSteps,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 200,
          child: Stack(
            children: [
              Container(
                height: 8,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              LayoutBuilder(
                builder: (context, constraints) {
                  return Container(
                    width: constraints.maxWidth * (currentStep / totalSteps),
                    height: 8,
                    decoration: BoxDecoration(
                      color: color,
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
          style: TextStyle(color: alunoCor, fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ],
    );
  }
}
