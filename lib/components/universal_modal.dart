/*
ACTION ORCHESTRATION LAYER FILE
- must support async properly
-> is now full width instead of MediaQuery hack for cleaner
responsive behavior
-> can now support chat, feed, and profile actions
*/

import 'package:flutter/material.dart';

class ModalAction {
  final String title;
  final String subtitle;
  final Color color;
  final Color borderColor;
  final Future<void> Function() onTap;

  ModalAction({
    required this.title,
    required this.subtitle,
    required this.color,
    required this.borderColor,
    required this.onTap,
  });
}

class CreateModalWidget extends StatefulWidget {
  const CreateModalWidget({
    super.key,
    required this.actions,
  });

  final List<ModalAction> actions;

  @override
  State<CreateModalWidget> createState() => _CreateModalWidgetState();
}

class _CreateModalWidgetState extends State<CreateModalWidget> {
  bool isLoading = false;

  Future<void> _handleTap(ModalAction action) async {
    setState(() => isLoading = true);

    try {
      await action.onTap();
      if (mounted) Navigator.pop(context);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      }
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  Widget _buildTile(ModalAction action) {
    return InkWell(
      onTap: isLoading ? null : () => _handleTap(action),
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: action.color,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: action.borderColor,
            width: 2,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              action.title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              action.subtitle,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black54,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 44),
        child: Container(
          width: double.infinity,
          constraints: const BoxConstraints(maxWidth: 570),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            boxShadow: const [
              BoxShadow(
                blurRadius: 4,
                color: Color(0x33000000),
                offset: Offset(0, 2),
              )
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 16),

              /// drag handle
              Container(
                width: 60,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),

              const SizedBox(height: 16),

              ...widget.actions.map(
                (a) => Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: _buildTile(a),
                ),
              ),

              const SizedBox(height: 8),

              if (isLoading)
                const Padding(
                  padding: EdgeInsets.only(bottom: 12),
                  child: CircularProgressIndicator(),
                ),
            ],
          ),
        ),
      ),
    );
  }
}