import 'package:flutter/material.dart';
import 'package:perfil_professor/components/colors.dart';

class CustomContainer extends StatefulWidget {
  final String imagePath;
  final int index;
  final bool isSelected;
  final ValueChanged<int> onSelectionChanged;
  final String text;
  final Color borderColor;

  const CustomContainer(
      {super.key,
      required this.imagePath,
      required this.index,
      required this.isSelected,
      required this.onSelectionChanged,
      required this.text,
      required this.borderColor});

  @override
  State<CustomContainer> createState() => _CustomContainerState();
}

class _CustomContainerState extends State<CustomContainer> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 156,
      height: 100,
      padding: const EdgeInsets.all(6.0),
      decoration: BoxDecoration(
        border: Border.all(
          width: 1,
          color: personalColor,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        crossAxisAlignment:
            CrossAxisAlignment.center, // Alinha todos os itens verticalmente
        children: [
          GestureDetector(
            onTap: () {
              widget.onSelectionChanged(widget.index);
            },
            child: Container(
              width: 24,
              height: 24,
              alignment: Alignment.center,
              child: Radio<int>(
                value: widget.index,
                groupValue: widget.isSelected ? widget.index : -1,
                onChanged: (int? value) {
                  widget.onSelectionChanged(value!);
                },
                activeColor: personalColor,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Align(
              alignment: Alignment
                  .centerLeft, // Garante que o texto fique alinhado à esquerda, mas centralizado verticalmente
              child: Text(
                widget.text,
                style: TextStyle(
                    fontSize: 13,
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
                softWrap: true, // Permite que o texto quebre linhas
              ),
            ),
          ),
          const SizedBox(width: 8),
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(widget.imagePath),
                fit: BoxFit.cover,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ],
      ),
    );
  }
}
