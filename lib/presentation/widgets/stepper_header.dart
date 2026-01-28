import 'package:farmconnect/core/theme/app_theme.dart';
import 'package:flutter/material.dart';

class RegistrationStepper extends StatelessWidget {
  final int currentStep;
  final List<String> steps;

  const RegistrationStepper({
    super.key,
    required this.currentStep,
    required this.steps,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 16.0),
      child: Row(
        children: [
          for (int i = 0; i < steps.length; i++) ...[
            Expanded(
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 2,
                          color: i == 0
                              ? Colors.transparent
                              : (i <= currentStep
                                    ? AppTheme.primaryGreen
                                    : Colors.grey.shade300),
                        ),
                      ),

                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: i < currentStep
                              ? AppTheme.primaryGreen
                              : (i == currentStep
                                    ? AppTheme.primaryGreen
                                    : Colors.grey.shade300),
                        ),
                        child: Center(
                          child: i < currentStep
                              ? const Icon(
                                  Icons.check,
                                  color: Colors.white,
                                  size: 18,
                                )
                              : Text(
                                  '${i + 1}',
                                  style: TextStyle(
                                    color: i == currentStep
                                        ? Colors.white
                                        : Colors.grey.shade600,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        ),
                      ),
                      // Line after circle (except last)
                      Expanded(
                        child: Container(
                          height: 2,
                          color: i == steps.length - 1
                              ? Colors.transparent
                              : (i < currentStep
                                    ? AppTheme.primaryGreen
                                    : Colors.grey.shade300),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    steps[i],
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12,
                      color: i <= currentStep ? Colors.black87 : Colors.grey,
                      fontWeight: i == currentStep
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
