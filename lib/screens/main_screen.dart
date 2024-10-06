import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:eye_meditation/screens/widgets/complete_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late int _timeLeft;
  Timer? _timer;
  bool _isStart = false;
  int _currentStage = 1;
  late int _stageDuration;
  bool _stage2Started = false;
  late AudioPlayer _audioPlayer;

  @override
  void initState() {
    super.initState();
    _setStageDuration();
    _audioPlayer = AudioPlayer();
    _setStageDuration();
  }

  void _playSound() async {
    await _audioPlayer.play(AssetSource('sounds/switch_sound.mp3'));
  }

  void _setStageDuration() {
    _stageDuration = _currentStage == 1 ? 30 : 80;
    _timeLeft = _stageDuration;
  }

  void _startTimer() {
    if (_isStart) {
      _stopMeditation();
    } else {
      _startMeditation();
    }
  }

  void _startMeditation() {
    if (_timer != null) {
      _timer!.cancel();
    }
    setState(() {
      _isStart = true;
      if (_currentStage == 2) {
        _stage2Started = false;
      }
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timeLeft > 0) {
        setState(() {
          _timeLeft--;

          if (_currentStage == 2) {
            if (_timeLeft == 50) {
              _stage2Started = true;
              _playSound();
            } else if (_timeLeft == 40) {
              _stage2Started = false;
              _playSound();
            } else if (_timeLeft == 10) {
              _stage2Started = true;
              _playSound();
            }
          }
        });
      } else {
        _stopMeditation();
        _showCompletionDialog();
      }
    });
  }
  void _stopMeditation() {
    setState(() {
      _isStart = false;
    });
    _timer?.cancel();
  }

  void _showCompletionDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return CompleteDialog(
          onContinueTap: _currentStage == 1 ? _continueToNextStage : _goBackToStage1,
          onAgainTap: () {
            Navigator.pop(context);

            setState(() {
              _isStart = false;
              _stage2Started = false;
              _setStageDuration();
              _timeLeft = _stageDuration;
            });
          },
          isSecondStage: _currentStage == 2,
        );
      },
    );
  }
  void _goBackToStage1() {
    Navigator.pop(context);
    _stopMeditation();
    setState(() {
      _currentStage = 1;
      _setStageDuration();
      _timeLeft = _stageDuration;
    });
  }

  void _continueToNextStage() {
    Navigator.pop(context);
    setState(() {
      _currentStage = 2;
      _isStart = false;
      _stage2Started = false;
      _setStageDuration();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Meditation',
          style: TextStyle(
            fontSize: 28.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: false,
        actions: [
          Text(
            'Stage $_currentStage',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          SizedBox(height: 20.h),
          Align(
            alignment: Alignment.center,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              height: 36.h,
              width: 100.w,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30.r),
                color: _isStart
                    ? const Color(0xFFD7E3FC)
                    : const Color(0xFF1E1E1E).withOpacity(0.16),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '$_timeLeft sec.',
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 14.sp,
                      color: Colors.black,
                    ),
                  ),
                  SvgPicture.asset(
                    'assets/icons/time.svg',
                    fit: BoxFit.contain,
                    width: 16.w,
                    height: 16.h,
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 16.h),
          if (_isStart && _currentStage == 2)
            Text(
              _currentStage == 1
                  ? 'Keep your eyes open'
                  : _stage2Started
                  ? 'Try to discern your\nsurroundings by focusing on everything'
                  : 'Close your eyes',
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF5C87FF),
              ),
              textAlign: TextAlign.center,
            ),
          SizedBox(height: 16.h),
          if (_currentStage == 2)
            Text(
              'Wearing headphones is recommended',
              style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 14.sp,
                color: const Color(0xFF1E1E1E).withOpacity(0.6),
              ),
            ),
          SizedBox(height: 28.h),
          if (_currentStage == 1)
            Align(
              alignment: Alignment.center,
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 32.w),
                height: 350.h,
                width: 310.w,
                child: Center(
                  child: Container(
                    height: 32.h,
                    width: 32.w,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xFF5C87FF),
                    ),
                  ),
                ),
              ),
            ),
          if (_currentStage == 2 && !_isStart)
            SizedBox(height: 60.h),
          if (_currentStage == 2)
            Image.asset(
              _isStart
                  ? (_stage2Started
                  ? 'assets/images/open_eyes.png'
                  : 'assets/images/close_eyes.png')
                  : 'assets/images/meditation2.png',
              fit: BoxFit.contain,
              height: 280.h,
              width: double.infinity,
            ),
          const Spacer(),
          GestureDetector(
            onTap: _startTimer,
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 32.w),
              alignment: Alignment.center,
              height: 44.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24.r),
                border: Border.all(
                    color: _isStart
                        ? const Color(0xFF1E1E1E)
                        : Colors.transparent),
                color: _isStart ? Colors.transparent : const Color(0xFF5C87FF),
              ),
              child: Text(
                _isStart ? 'Stop meditating' : 'Start meditating',
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 16.sp,
                  color: !_isStart ? Colors.white : const Color(0xFF1E1E1E),
                ),
              ),
            ),
          ),
          SizedBox(height: 42.h),
        ],
      ),
    );
  }
}