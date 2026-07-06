import 'package:flutter/material.dart';

/// Pfad zum lokalisierten Partner-Logo (Heilsarmee/Salvation Army),
/// passend zur aktuellen App-Sprache. Fällt auf Englisch zurück, wenn die
/// Sprache nicht Deutsch ist.
String localizedPartnerLogoAsset(BuildContext context) {
  return localizedPartnerLogoAssetForLanguage(Localizations.localeOf(context).languageCode);
}

String localizedPartnerLogoAssetForLanguage(String languageCode) {
  return languageCode == 'de' ? 'assets/Logo.de.png' : 'assets/Logo.en.png';
}
