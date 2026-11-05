import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/strings.dart';
import '../../data/settings_controller.dart';

/// Gates premium features (offline downloads).
///
/// In the prototype enabling premium is immediate and local, but the flow is
/// the same a store purchase would follow: check entitlement, explain the
/// feature, unlock, then retry the action.
Future<bool> ensurePremium(BuildContext context) async {
  final settings = context.read<SettingsController>();
  if (settings.premiumUnlocked) return true;

  final strings = AppStrings.of(context);
  final scheme = Theme.of(context).colorScheme;

  final result = await showDialog<bool>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      icon: Icon(Icons.workspace_premium_rounded, color: scheme.secondary),
      title: Text(strings.premiumFeatureTitle),
      content: Text(
        strings.premiumFeatureBody,
        style: Theme.of(context).textTheme.bodyMedium,
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(dialogContext).pop(false),
          child: Text(strings.cancel),
        ),
        FilledButton(
          onPressed: () => Navigator.of(dialogContext).pop(true),
          child: Text(strings.activateDemo),
        ),
      ],
    ),
  );

  if (result == true) {
    await settings.setPremiumUnlocked(true);
    return true;
  }
  return false;
}
