let
  userChrome = ''
    #TabsToolbar {
        visibility: collapse;
    }

    #titlebar {
        visibility: collapse;
    }

    #sidebar-header {
        visibility: collapse;
    }

    /*** BEGIN Firefox 77 (June 2, 2020) Override URL bar enlargement ***/
    /***  https://support.mozilla.org/en-US/questions/1290682         ***/

    /* Compute new position, width, and padding */

    #urlbar[breakout][breakout-extend] {
      top: 5px !important;
      left: 0px !important;
      width: 100% !important;
      padding: 0px !important;
    }
    /* for alternate Density settings */
    [uidensity="compact"] #urlbar[breakout][breakout-extend] {
      top: 3px !important;
    }
    [uidensity="touch"] #urlbar[breakout][breakout-extend] {
      top: 4px !important;
    }

    /* Prevent shift of URL bar contents */

    #urlbar[breakout][breakout-extend] > #urlbar-input-container {
      height: var(--urlbar-height) !important;
      padding: 0 !important;
    }

    /* Do not animate */

    #urlbar[breakout][breakout-extend] > #urlbar-background {
      animation: none !important;;
    }

    /* Remove shadows */

    #urlbar[breakout][breakout-extend] > #urlbar-background {
      box-shadow: none !important;
    }

    /*** END Firefox 77 (June 2, 2020) Override URL bar enlargement ***/
  '';

  userChromeClean = ''
    /* There is only xul */
    @namespace url("http://www.mozilla.org/keymaster/gatekeeper/there.is.only.xul"); /* set default namespace to XUL */

    /* Remove all UI */
    #TabsToolbar {visibility: collapse;}
    #navigator-toolbox {visibility: collapse;}
    browser {margin-right: -14px; margin-bottom: -14px;}
  '';

  settings = {
    # UI Config
    "widget.content.gtk-theme-override" = "Adwaita:light";
    "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
    "browser.newtabpage.enabled" = false;
    "browser.newtab.url" = "about:blank";
    "devtools.theme" = "dark";

    # Misc
    "identity.fxaccounts.enabled" = false;

    # Forms
    "signon.autofillForms" = false;
    "sigon.rememberSignons" = false;

    # UI
    "network.IDN_show_punycode" = true;
    "layout.css.visited_links_enabled" = false;

    # URL Bar Config
    "browser.urlbar.openViewOnFocus" = false;
    "browser.urlbar.update1" = false;
    "browser.urlbar.update1.interventions" = false;
    "browser.urlbar.update1.searchTips" = false;

    # ESNI
    "network.trr.custom_uri" = "https://127.0.0.1:3000/dns-query";
    "network.trr.uri" = "https://127.0.0.1:3000/dns-query";
    "network.trr.mode" = 3;
    "network.security.esni.enabled" = true;

    #
    # Hardening
    # https://github.com/pyllyukko/user.js
    #

    # Disable JS APIs
    "dom.serviceWorkers.enable" = false;
    "dom.enable_performance" = false;
    "dom.enable_user_timing" = false;
    "geo.enabled" = false;
    "media.peerconnection.enabled" = false; # WebRTC
    "javascript.options.wasm" = false;
    "javascript.options.asmjs" = false;
    "javascript.options.shared_memory" = false;
    "webgl.disabled" = true;
    "dom.disable_beforeunload" = true;
    "dom.event.contextmenu.enabled" = false;
    "offline-apps.allow_by_default" = false;

    # Clipboard
    "dom.event.clipboardevents.enabled" = false;
    "dom.allow_cut_copy" = false;

    # Network Spam
    "beacon.enabled" = false;
    "browser.send_pings" = false;

    # getUserMedia
    "media.navigator.enabled" = false;
    "media.navigator.video.enabled" = false;
    "media.getusermedia.screensharing.enabled" = false;
    "media.audiocapture.enabled" = false;
    "media.getusermedia.browser.enabled" = false;

    # Misc JS APIs
    "media.webspeech.recognition.enable" = false;
    "media.synth.enable" = false;
    "dom.battery.enabled" = false;
    "dom.gamepad.enabled" = false;
    "dom.vr.enabled" = false;
    "dom.vibrator.enabled" = false;
    "dom.enable_resource_timing.enabled" = false;
    "dom.telephony.enabled" = false;
    "device.sensors.enabled" = false;
    "dom.mozTCPSocket.enabled" = false;
    "dom.netinfo.enabled" = false;

    # Media
    "media.autoplay.default" = 2;
    "media.video_status.enabled" = false;
    "media.gmp-gmpopenh264.enabled" = false;
    "media.gmp-gmpopenh264.visible" = false;
    "media.gmp-manager.url" = false;
    "media.gmp-widevinecdm.enable" = false;
    "media.gmp-widevinecdm.visible" = false;

    # MISC
    "dom.maxHardwareConcurrency" = 2;
    "camera.control.face_detection.enabled" = false;
    "browser.search.countryCode" = "US";
    "browser.search.region" = "US";
    "browser.search.geoip.url" = "";
    "intl.accept_languages" = "en-US";
    "browser.search.geoSpecificDefaults" = false;
    "clipboard.autocopy" = false;
    "javascript.use_us_english_locale" = true;
    "browser.urlbar.trimURLs" = false;
    "browser.fixup.alternate.enabled" = false;
    "network.manage-offline-status" = false;
    "security.mixed_content.block_active_content" = true;
    "security.mixed_content.block_display_content" = true;
    "security.mixed_content.block_object_subrequest" = true;
    "browser.urlbar.filter.javascript" = true;
    "broser.display.use_document_fonts" = 0;
    "ui.use_standins_for_native_colors" = true;

    # Plugins
    "security.dialog_enable_delay" = 1000;
    "xpinstall.signatures.required" = true;
    "extensions.getAddons.cache.enabled" = false;
    "lightweightThemes.update.enabled" = false;
    "plugin.state.flash" = 0;
    "plugin.state.java" = 0;
    "shumway.disabled" = true;
    "plugin.state.libgnome-shell-browser-plugin" = 0;
    "extensions.blocklist.enabled" = true;
    "services.blocklist.update_enabled" = true;
    "extensions.blocklist.url" =
      "https://blocklist.addons.mozilla.org/blocklist/3/%APP_ID%/%APP_VERSION%/";
    "extensions.systemAddon.update.enabled" = false;

    # AntiFeatures
    "browser.newtabpage.activity-stream.asrouter.userprefs.cfr" = false;
    "devtools.webide.enabled" = false;
    "devtools.webide.autoinstallADBHelper" = false;
    "devtools.webide.autoinstallFxdtAdapters" = false;
    "devtools.debugger.remote-enabled" = false;
    "devtools.chrome.enabled" = false;
    "devtools.debugger.force-local" = false;
    "toolkit.telemetry.enabled" = false;
    "toolkit.telemetry.unified" = false;
    "toolkit.telemetry.archive.enabled" = false;
    "experiments.supported" = false;
    "experiments.enabled" = false;
    "experiments.manifest.uri" = "";
    "network.allow-experiments" = false;
    "breakpad.reportURL" = "";
    "browser.tabs.crashReporting.sendReport" = false;
    "browser.crashReports.unsubmittedCheck.enabled" = false;
    "dom.flyweb.enabled" = false;
    "browser.uitour.enabled" = false;
    "datareporting.healthreport.uploadEnabled" = false;
    "datareporting.healthreport.service.enabled" = false;
    "datareporting.policy.dataSubmissionEnabled" = false;
    "browser.discovery.enabled" = false;
    "browser.selfsupport.url" = "";
    "loop.logDomains" = false;
    "browser.pocket.enabled" = false;
    "extensions.pocket.enabled" = false;
    "extensions.shield-recipe-client.enabled" = false;
    "app.shield.optoutstudies.enabled" = false;
    "browser.newtabpage.activity-stream.feeds.section.topstories" = false;

    # Fingerprinting
    "privacy.trackingprotection.enabled" = true;
    "privacy.trackingprotection.pbmode.enabled" = true;
    "privacy.userContext.enabled" = true;
    "privacy.resistFingerprinting" = true;
    "pdfjs.disabled" = true;

    # Safe Browsing
    "browser.safebrowsing.phishing.enabled" = true;
    "browser.safebrowsing.malware.enabled" = true;
    "browser.safebrowsing.downloads.remote.enabled" = false;

    # Automatic Connections
    "network.prefetch-next" = false;
    "network.dns.disablePrefetch" = true;
    "network.dns.disablePrefetchFromHTTPS" = true;
    "network.predictor.enabled" = false;
    "network.dns.blockDotOnion" = true;
    "network.http.speculative-parallel-limit" = 0;
    "browser.aboutHomeSnippets.updateUrl" = false;
    "browser.search.update" = false;
    "network.captive-portal-service.enabled" = false;
    "browser.casting.enabled" = false;

    # HTTP
    "network.negotiate-auth.allow-insecure-ntlm-v1" = false;
    "network.negotiate-auth.allow-insecure-ntlm-v1-http" = false;
    "security.csp.experimentalEnabled" = true;
    "security.csp.enable" = true;
    "secirity.sri.enable" = true;
    "privacy.donottrackheader.enabled" = true;
    "network.http.referer.spoofSource" = true;
    "network.cookie.cookieBehavior" = 1;
    "privacy.firstparty.isolate" = true;

  };

in
{
  enable = true;
  profiles = {
    default = { inherit userChrome settings; };
    clean = {
      inherit settings;
      id = 1;
      userChrome = userChromeClean;
    };
  };
}
