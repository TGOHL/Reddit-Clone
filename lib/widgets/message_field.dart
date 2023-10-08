import 'package:flutter/material.dart';

class MessageField extends StatefulWidget {
  final Function(String) onSubmit;
  const MessageField({super.key, required this.onSubmit});

  @override
  State<MessageField> createState() => _MessageFieldState();
}

class _MessageFieldState extends State<MessageField> {
  final controller = TextEditingController();
  bool isFocused = false;
  @override
  Widget build(BuildContext context) {
    return Focus(
      onFocusChange: (val) {
        setState(() {
          isFocused = val;
        });
      },
      child: Container(
        color: Colors.white24,
        margin: const EdgeInsets.all(4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (isFocused) const Text('some stuff over here'),
            TextField(
              controller: controller,
              decoration: InputDecoration(
                hintText: "Enter your message",
                border: InputBorder.none,
                suffixIcon: isFocused ? null : const Icon(Icons.photo_rounded),
              ),
              onTapOutside: (event) {
                FocusScope.of(context).unfocus();
              },
            ),
            if (isFocused)
              Row(
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.add),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.add_a_photo_rounded),
                  ),
                  const Spacer(),
                  ElevatedButton(
                      onPressed: () {
                        widget.onSubmit(controller.text);
                      },
                      child: const Text('press'))
                ],
              )
          ],
        ),
      ),
    );
  }
}
