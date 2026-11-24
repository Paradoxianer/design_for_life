{{flutter_js}}
{{flutter_build_config}}

// Datenschutz: Die App soll nur mit dem eigenen Server sprechen.
// - CanvasKit liegt dank "--no-web-resources-cdn" im Build selbst (nicht bei
//   www.gstatic.com).
// - Flutter lädt für Zeichen, die keine gebündelte Schrift abdeckt, sonst
//   Ersatzschriften von fonts.gstatic.com nach. Die Basis-URL zeigt deshalb
//   auf den eigenen Server; die gebündelten Schriften (Noto Sans, Inter,
//   Playfair) decken Deutsch, Englisch, Polnisch, Litauisch, Französisch,
//   Niederländisch, Schwedisch und Russisch ab.
_flutter.loader.load({
  serviceWorkerSettings: {
    serviceWorkerVersion: {{flutter_service_worker_version}},
  },
  config: {
    fontFallbackBaseUrl: "fonts-fallback/",
  },
});
