import 'package:flutter/material.dart';

class CardContainer extends StatefulWidget {
  final Widget child;
  final bool expand;
  final double margin;

  const CardContainer({required this.child, this.expand=false, this.margin = 20});

  @override
  _CardContainerState createState() => _CardContainerState();
}

class _CardContainerState extends State<CardContainer> {
  @override
  Widget build(BuildContext context) {
    if (false) {
      return Row(
        children: [
          Expanded(
              child: createCard(context, widget.child, widget.margin)),
        ],
      );
    }
    return createCard(context, widget.child, widget.margin);
  }
}

Container createCard(context, child, margin) {
  return Container(
    margin: EdgeInsets.all(margin),
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
    decoration: ShapeDecoration(
      color: Theme.of(context).secondaryHeaderColor,
      shadows: const [
        BoxShadow(color: Colors.black, offset: Offset(2, 2))
      ],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    ),
    child: child,
  );
}

