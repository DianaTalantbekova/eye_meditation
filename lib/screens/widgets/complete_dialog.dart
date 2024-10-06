import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CompleteDialog extends StatelessWidget {
  const CompleteDialog({
    super.key,
    this.onContinueTap,
    this.onAgainTap,
    required this.isSecondStage, // New parameter to check stage
  });

  final VoidCallback? onContinueTap;
  final VoidCallback? onAgainTap;
  final bool isSecondStage; // New parameter

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Color(0xFFF2F2F2).withOpacity(0.8),
      child: Container(
        padding: const EdgeInsets.all(16),
        height: 450.h,
        width: 277.w,
        child: Column(
          children: [
            const Align(
              alignment: Alignment.centerRight,
              child: Icon(Icons.close),
            ),
            Text(
              'Yay',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 20.sp,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              isSecondStage?  'You have completed a set of eye meditations': 'You have completed stage 1 of the meditations. To proceed to the 2nd stage, click on the button below.',
              style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 14.sp,
                color: const Color(0xFF1E1E1E).withOpacity(0.6),
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 14.h),
            Image.asset(
              'assets/images/meditation.png',
              fit: BoxFit.contain,
              width: 160.w,
              height: 160.h,
            ),
            SizedBox(height: 14.h),
            GestureDetector(
              onTap: onContinueTap,
              child: Container(
                alignment: Alignment.center,
                height: 36.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24.r),
                  color: const Color(0xFF5C87FF),
                ),
                child: Text(
                  isSecondStage ? 'Back to stage 1' : 'Continue (stage 2)', // Change button text
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            SizedBox(height: 8.h),
            GestureDetector(
              onTap: onAgainTap,
              child: Container(
                alignment: Alignment.center,
                height: 36.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24.r),
                  color: Colors.white,
                  border: Border.all(
                    color: const Color(0xFF1E1E1E).withOpacity(0.2),
                  ),
                ),
                child: Text(
                  'Go through again',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}