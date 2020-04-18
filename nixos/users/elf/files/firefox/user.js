/*
 * user.js
 * based off of https://github.com/pyllyukko/user.js/
 */

/* UI Config */
user_pref("widget.content.gtk-theme-override", "Adwaita:light");
user_pref("toolkit.legacyUserProfileCustomizations.stylesheets", true);
user_pref("browser.newtabpage.enabled", false);
user_pref("browser.newtab.url", "about:blank");

user_pref("browser.urlbar.openViewOnFocus", false);
user_pref("browser.urlbar.update1", false);
user_pref("browser.urlbar.update1.interventions", false);
user_pref("browser.urlbar.update1.searchTips", false);

/* ESNI */
user_pref("network.trr.custom_uri", "https://127.0.0.1:3000/dns-query");
user_pref("network.trr.uri", "https://127.0.0.1:3000/dns-query");
user_pref("network.trr.mode", 2);
user_pref("network.security.esni.enabled", true);


/* Security Config */

// JS APIs
user_pref("dom.serviceWorkers.enabled", false);
user_pref("dom.enable_performance", false);
user_pref("dom.enable_user_timing", false);
user_pref("dom.webaudio.enabled", false);
user_pref("geo.enabled", false);


// WebRTC, Wasm, WebGL
user_pref("media.peerconnection.enabled", false);
user_pref("javascript.options.wasm", false);
user_pref("webgl.disabled", true);

// getUserMedia
user_pref("media.navigator.enabled",                false);
user_pref("media.navigator.video.enabled",          false);
user_pref("media.getusermedia.screensharing.enabled",       false);
user_pref("media.getusermedia.audiocapture.enabled", false);

// webspeech and face detection
user_pref("media.webspeech.recognition.enable", false);
user_pref("media.webspeech.synth.enable", false);

// Clipboard
user_pref("dom.event.clipboardevents.enabled", false);
user_pref("dom.allow_cut_copy", false);

// Pings
user_pref("browser.send_pings", false);
user_pref("beacon.enabled", false);

// DOM Stuff
user_pref("dom.battery.enabled", false);
user_pref("dom.gamepad.enabled", false);
user_pref("dom.vr.enabled", false);
user_pref("dom.vibrator.enabled", false);
user_pref("dom.enable_resource_timing", false);
user_pref("dom.telephony.enabled", false);
user_pref("device.sensors.enabled", false);

+// Disable Plugins
+user_pref("media.gmp-gmpopenh264.enabled", false);
+user_pref("media.gmp-gmpopenh264.visible", false);
+user_pref("media.gmp-widevinecdm.enabled", false);
+user_pref("media.gmp-widevinecdm.visible", false);

// spoof dual core cpu
user_pref("dom.maxHardwareConcurrency", 2);

// MISC
user_pref("camera.control.face_detection.enabled", false);
user_pref("browser.search.countryCode", "US");
user_pref("browser.search.region", "US");
user_pref("browser.search.geoip.url", "");
user_pref("intl.accept_languages", "en-US, en");
user_pref("intl.locale.matchOS", false);
user_pref("browser.search.geoSpecificDefaults", false);
user_pref("javascript.use_us_english_locale", true);
user_pref("browser.urlbar.trimURLs", false);
user_pref("browser.fixup.alternate.enabled", false);
user_pref("network.manage-offline-status", false);
user_pref("network.jar.open-unsafe-types", false);
user_pref("browser.urlbar.filter.javascript", true);
user_pref("media.video_stats.enabled", false);
user_pref("layout.css.visited_links_enabled", false);

// HTTP
user_pref("privacy.donottrackheader.enabled", true);
user_pref("network.http.referer.spoofSource", true);
user_pref("network.cookie.cookieBehavior", 1);
user_pref("privacy.firstparty.isolate", true);

// Autofill
user_pref("signon.autofillForms", false);
user_pref("signon.rememberSignons", false);

// Extensions and Plugins
user_pref("security.dialog_enable_delay", 1000);
user_pref("xpinstall.signatures.required",      true);
user_pref("extensions.getAddons.cache.enabled", false);
user_pref("lightweightThemes.update.enabled", false);
user_pref("plugin.state.flash", 0);
user_pref("shumway.disabled", true);
user_pref("plugin.state.java", 0);
user_pref("plugin.state.libgnome-shell-browser-plugin", 0);
user_pref("extensions.update.enabled", true);
user_pref("extensions.blocklist.enabled",           true);
user_pref("services.blocklist.update_enabled", true);
user_pref("extensions.blocklist.url", "https://blocklist.addons.mozilla.org/blocklist/3/%APP_ID%/%APP_VERSION%/");
user_pref("extensions.systemAddon.update.enabled", false);

// Telemetry
user_pref("browser.newtabpage.activity-stream.asrouter.userprefs.cfr",  false);
user_pref("devtools.webide.enabled",                false);
user_pref("devtools.webide.autoinstallADBHelper",       false);
user_pref("devtools.webide.autoinstallFxdtAdapters", false);
user_pref("devtools.debugger.remote-enabled",           false);
user_pref("devtools.chrome.enabled",                false);
user_pref("devtools.debugger.force-local", true);
user_pref("toolkit.telemetry.enabled",              false);
user_pref("toolkit.telemetry.unified",              false);
user_pref("toolkit.telemetry.archive.enabled",          false);
user_pref("experiments.supported",              false);
user_pref("experiments.enabled",                false);
user_pref("experiments.manifest.uri", "");
user_pref("network.allow-experiments", false);
user_pref("breakpad.reportURL", "");
user_pref("browser.tabs.crashReporting.sendReport",     false);
user_pref("browser.crashReports.unsubmittedCheck.enabled", false);
user_pref("dom.flyweb.enabled", false);
user_pref("browser.uitour.enabled", false);
user_pref("privacy.trackingprotection.enabled",         true);
user_pref("privacy.trackingprotection.pbmode.enabled", true);
user_pref("privacy.userContext.enabled", true);
user_pref("privacy.resistFingerprinting", true);
user_pref("pdfjs.disabled", true);
user_pref("datareporting.healthreport.uploadEnabled",       false);
user_pref("datareporting.healthreport.service.enabled",     false);
user_pref("datareporting.policy.dataSubmissionEnabled", false);
user_pref("browser.discovery.enabled", false);
user_pref("browser.selfsupport.url", "");
user_pref("loop.logDomains", false);
user_pref("browser.safebrowsing.phishing.enabled", true);
user_pref("browser.safebrowsing.malware.enabled", true);
user_pref("browser.safebrowsing.downloads.remote.enabled", false);
user_pref("browser.pocket.enabled",             false);
user_pref("extensions.pocket.enabled", false);
user_pref("extensions.shield-recipe-client.enabled",        false);
user_pref("app.shield.optoutstudies.enabled", false);
user_pref("browser.newtabpage.activity-stream.feeds.section.topstories", false);

// Automatic Connections
user_pref("network.prefetch-next", false);
user_pref("network.predictor.enabled", false);
user_pref("network.dns.blockDotOnion", true);
user_pref("browser.search.suggest.enabled", false);
user_pref("network.http.speculative-parallel-limit", 0);
user_pref("browser.aboutHomeSnippets.updateUrl", "");
user_pref("browser.search.update", false);
user_pref("network.captive-portal-service.enabled", false);
