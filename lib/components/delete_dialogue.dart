/*
UI FILE ONLY
- added loading state
- single active action lock
- safer UX for more destructive Supabase ops

Eventually, we need to handle:
1. deleting chat messages
2. deleting convos
3. deleting posts/comments
4. removing users from groups
5. deleting media from storage

Right now, this is good for:
1. async Supabase ops
2. storage deletes
3. multi-table cascades
*/

import 'package:flutter/material.dart';

class DialogAction {
  final String title;
  final IconData icon;
  final Color? color;
  final Future Function() onTap;

  DialogAction({
    required this.title,
    required this.icon,
    this.color,
    required this.onTap,
  });
}

class UniversalActionDialog extends StatefulWidget {
  const UniversalActionDialog({
    super.key,
    required this.actions,
  });

  final List<DialogAction> actions;

  @override
  State<UniversalActionDialog> createState() =>
      _UniversalActionDialogState();
}

class _UniversalActionDialogState extends State<UniversalActionDialog> {
  int? confirmIndex;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            "Options",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 12),

          ...List.generate(widget.actions.length, (i) {
            final action = widget.actions[i];

            final isConfirming = confirmIndex == i;

            return Column(
              children: [
                ListTile(
                  leading: Icon(
                    action.icon,
                    color: action.color,
                  ),
                  title: Text(action.title),
                  onTap: isLoading
                      ? null
                      : () {
                          setState(() {
                            confirmIndex = i;
                          });
                        },
                ),

                if (isConfirming) ...[
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    child: Text(
                      "Are you sure?",
                      style: TextStyle(color: Colors.red),
                    ),
                  ),

                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                    onPressed: isLoading
                        ? null
                        : () async {
                            setState(() => isLoading = true);

                            try {
                              await action.onTap();

                              if (context.mounted) {
                                Navigator.pop(context);
                              }
                            } catch (e) {
                              if (context.mounted) {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(
                                  SnackBar(content: Text('$e')),
                                );
                              }
                            } finally {
                              if (mounted) {
                                setState(() => isLoading = false);
                              }
                            }
                          },
                    child: isLoading
                        ? const SizedBox(
                            height: 16,
                            width: 16,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Text("Confirm"),
                  ),

                  const Divider(),
                ]
              ],
            );
          }),
        ],
      ),
    );
  }
}