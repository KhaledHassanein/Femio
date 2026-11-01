// The "Privacy policy" row in Settings → Privacy, and how it opens the policy.
//
// Why it exists: Google Play asks for a privacy policy link or text inside the app, and
// the policy lives on the website (femioapp.com), in her language. femio has no network
// code of its own, so the row hands the address to her browser; if the phone cannot
// open one, it shows the address as selectable text with a Copy button instead.

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../l10n/app_localizations.dart';
import '../../theme/spacing.dart';

/// The site that hosts the policy.
const privacyPolicyHost = 'femioapp.com';

/// The languages the website has a policy page in. Anything else gets English.
const _policyLanguages = {'en', 'ar', 'fr', 'es'};

/// The policy page for [languageCode], e.g. `https://femioapp.com/ar/privacy`.
/// Unknown codes fall back to English, so the link always works.
Uri privacyPolicyUri(String languageCode) {
  final lang = _policyLanguages.contains(languageCode) ? languageCode : 'en';
  return Uri(scheme: 'https', host: privacyPolicyHost, path: '/$lang/privacy');
}

/// Opens [uri] outside femio. True when the phone accepted it; false when it could not
/// (no browser, or the launcher failed), so the caller can show the address instead.
typedef UrlOpener = Future<bool> Function(Uri uri);

/// The real opener: her default browser, never an in-app web view.
Future<bool> openInBrowser(Uri uri) async {
  try {
    return await launchUrl(uri, mode: LaunchMode.externalApplication);
  } catch (error) {
    debugPrint('The browser could not be opened: $error');
    return false;
  }
}

/// The settings row. [open] is replaceable so a test need not start a browser.
class PrivacyPolicyTile extends StatelessWidget {
  const PrivacyPolicyTile({super.key, this.open = openInBrowser});
  final UrlOpener open;

  @override
  Widget build(BuildContext context) {
    final l = L10n.of(context);
    return ListTile(
      leading: const Icon(Icons.policy_outlined),
      title: Text(l.privacyPolicyTitle),
      subtitle: Text(l.privacyPolicySubtitle),
      trailing: const Icon(Icons.open_in_new_rounded),
      onTap: () async {
        final uri = privacyPolicyUri(Localizations.localeOf(context).languageCode);
        final opened = await open(uri);
        if (!opened && context.mounted) {
          await showDialog<void>(
            context: context,
            builder: (_) => _AddressDialog(address: uri.toString()),
          );
        }
      },
    );
  }
}

/// The fallback: the address as text she can select, and a Copy button.
class _AddressDialog extends StatelessWidget {
  const _AddressDialog({required this.address});
  final String address;

  @override
  Widget build(BuildContext context) {
    final l = L10n.of(context);
    return AlertDialog(
      title: Text(l.privacyPolicyTitle),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l.privacyPolicyOpenFailed),
          const SizedBox(height: space3),
          // A web address reads left to right even inside Arabic.
          SelectableText(address, textDirection: TextDirection.ltr),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () async {
            final messenger = ScaffoldMessenger.of(context);
            await Clipboard.setData(ClipboardData(text: address));
            messenger.showSnackBar(SnackBar(content: Text(l.learnLinkCopied)));
          },
          child: Text(l.copyLabel),
        ),
        TextButton(onPressed: () => Navigator.of(context).pop(), child: Text(l.closeLabel)),
      ],
    );
  }
}
