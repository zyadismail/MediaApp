import 'package:flutter/material.dart';

class ChoiceCard extends StatelessWidget {
  final bool isActive;
  final String text;
  final IconData icon;
  const ChoiceCard({Key? key ,
    required this.isActive,
    required this.text,
    required this.icon
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0)
      ),
      color: isActive?Colors.teal : Colors.white,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 24.0,
                color: isActive?Colors.white: Colors.black,
              ),
              const SizedBox(
                width: 20.0,
              ),
              Text(
                text,
                style: TextStyle(
                  color: isActive?Colors.white: Colors.black,
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
