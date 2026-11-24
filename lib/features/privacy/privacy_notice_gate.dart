import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:design_for_life/features/privacy/legal_texts.dart';
import 'package:design_for_life/features/privacy/privacy_notice_cubit.dart';

/// Legt beim ersten Start den Datenschutz-Hinweis über die App (siehe
/// [PrivacyNoticeCubit]). Als Overlay statt als Route, damit Deep Links
/// (z. B. Gaben-Referenz) unverändert funktionieren.
class PrivacyNoticeGate extends StatelessWidget {
  final Widget child;
  const PrivacyNoticeGate({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PrivacyNoticeCubit, bool>(
      builder: (context, acknowledged) {
        if (acknowledged) return child;
        return Stack(
          children: [
            child,
            const Positioned.fill(child: _NoticeOverlay()),
          ],
        );
      },
    );
  }
}

enum _View { notice, privacy, imprint }

class _NoticeOverlay extends StatefulWidget {
  const _NoticeOverlay();

  @override
  State<_NoticeOverlay> createState() => _NoticeOverlayState();
}

class _NoticeOverlayState extends State<_NoticeOverlay> {
  _View _view = _View.notice;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final t = LegalTexts.forLanguage(Localizations.localeOf(context).languageCode);

    Widget body;
    switch (_view) {
      case _View.notice:
        body = ListView(
          padding: const EdgeInsets.all(24),
          children: [
            Text(t.welcomeTitle, style: theme.textTheme.headlineSmall),
            const SizedBox(height: 12),
            Text(t.welcomeIntro, style: theme.textTheme.bodyLarge),
            const SizedBox(height: 12),
            for (final point in t.welcomePoints)
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(top: 2, right: 10),
                      child: Icon(Icons.check_circle_outline, size: 18),
                    ),
                    Expanded(child: Text(point)),
                  ],
                ),
              ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              children: [
                TextButton(
                  onPressed: () => setState(() => _view = _View.privacy),
                  child: Text(t.readPrivacy),
                ),
                TextButton(
                  onPressed: () => setState(() => _view = _View.imprint),
                  child: Text(t.readImprint),
                ),
              ],
            ),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: () => context.read<PrivacyNoticeCubit>().acknowledge(),
              child: Text(t.welcomeAck),
            ),
          ],
        );
      case _View.privacy:
      case _View.imprint:
        final doc = _view == _View.privacy ? t.privacyPolicy : t.imprint;
        body = Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton.icon(
                onPressed: () => setState(() => _view = _View.notice),
                icon: const Icon(Icons.arrow_back),
                label: Text(t.back),
              ),
            ),
            Expanded(child: LegalDocumentView(document: doc)),
          ],
        );
    }

    return Material(
      color: theme.colorScheme.surface,
      child: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 640),
            child: body,
          ),
        ),
      ),
    );
  }
}

/// Zeigt ein Rechtsdokument (Impressum, Datenschutzerklärung) als
/// auswählbaren Text, mit Entwurfs-Banner solange [kLegalTextsAreDraft].
class LegalDocumentView extends StatelessWidget {
  final LegalDocument document;
  const LegalDocumentView({super.key, required this.document});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final t = LegalTexts.forLanguage(Localizations.localeOf(context).languageCode);
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        if (kLegalTextsAreDraft)
          Container(
            padding: const EdgeInsets.all(12),
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: theme.colorScheme.errorContainer,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              t.draftBanner,
              style: TextStyle(color: theme.colorScheme.onErrorContainer),
            ),
          ),
        Text(document.title, style: theme.textTheme.headlineSmall),
        for (final (heading, body) in document.sections) ...[
          const SizedBox(height: 20),
          Text(
            heading,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          SelectableText(body),
        ],
      ],
    );
  }
}
