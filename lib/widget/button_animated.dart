import 'package:flutter/material.dart';
import 'package:raid/constants.dart';

class StaggerAnimation extends StatelessWidget {
  final VoidCallback onTap;
  final String titleButton;
  final Color background;
  final Color foreground;
  StaggerAnimation({
    Key key,
    this.buttonController,
    this.onTap,
    this.titleButton = 'Sign In',
    this.background,
    this.foreground,
  })  : buttonSqueezeanimation = Tween(
          begin: 350.0,
          end: 50.0,
        ).animate(
          CurvedAnimation(
            parent: buttonController,
            curve: const Interval(
              0.0,
              0.150,
            ),
          ),
        ),
        containerCircleAnimation = EdgeInsetsTween(
          begin: const EdgeInsets.only(bottom: 30.0),
          end: const EdgeInsets.only(bottom: 0.0),
        ).animate(
          CurvedAnimation(
            parent: buttonController,
            curve: const Interval(
              0.500,
              0.800,
              curve: Curves.ease,
            ),
          ),
        ),
        super(key: key);

  final AnimationController buttonController;
  final Animation<EdgeInsets> containerCircleAnimation;
  final Animation buttonSqueezeanimation;

  Widget _buildAnimation(BuildContext context, Widget child) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: buttonSqueezeanimation.value,
        height: 50,
        alignment: FractionalOffset.center,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: primaryColor.withOpacity(0.2),
              spreadRadius: 3,
              blurRadius: 4,
              offset: Offset(0, 3),
            ),
          ],
          color: background,
          borderRadius: BorderRadius.all(
              Radius.circular(buttonSqueezeanimation.value > 75.0 ? 10.0 : 25)),
        ),
        child: buttonSqueezeanimation.value > 75.0
            ? Text(
                titleButton,
                style: TextStyle(
                  color: foreground,
                  fontSize: 18.0,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.3,
                ),
              )
            : CircularProgressIndicator(
                value: null,
                strokeWidth: 1.0,
                valueColor: AlwaysStoppedAnimation<Color>(foreground),
              ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      builder: _buildAnimation,
      animation: buttonController,
    );
  }
}
