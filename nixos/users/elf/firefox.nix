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
    "browser.aboutConfig.showWarning" = false;
    "browser.newtab.url" = "about:blank";
    "browser.newtabpage.enabled" = false;
    "devtools.theme" = "dark";
    "extensions.pocket.enabled" = false;
    "browser.pocket.enabled" = false;
    "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
    "widget.content.gtk-theme-override" = "Adwaita:light";

    # Misc
    "identity.fxaccounts.enabled" = false;

    # Forms
    "signon.autofillForms" = false;
    "sigon.rememberSignons" = false;

    # UI
    "network.IDN_show_punycode" = true;
    "layout.css.visited_links_enabled" = false;
    "browser.uitour.enabled" = false;
    "browser.formfill.enable" = false;

    # URL Bar Config
    "browser.urlbar.openViewOnFocus" = false;
    "browser.urlbar.trimURLs" = false;
    "browser.fixup.alternate.enabled" = false;
    "browser.urlbar.filter.javascript" = true;

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
    "camera.control.face_detectoin.enabled" = false;
    "device.sensors.enabled" = false;
    "dom.enable_performance" = false;
    "dom.enable_resource_timing.enabled" = false;
    "dom.enable_user_timing" = false;
    "dom.flyweb.enabled" = false;
    "dom.gamepad.enabled" = false;
    "dom.mozTCPSocket.enabled" = false;
    "dom.netinfo.enabled" = false;
    "dom.serviceWorkers.enable" = false;
    "dom.serviceWorkers.enabled" = false;
    "dom.telephony.enabled" = false;
    "dom.vibrator.enabled" = false;
    "dom.vr.enabled" = false;
    "dom.webaudio.enabled" = false;
    "dom.workers.enabled" = false;
    "geo.enabled" = false;
    "javascript.options.asmjs" = false;
    "javascript.options.shared_memory" = false;
    "javascript.options.wasm" = false;
    "media.peerconnection.enabled" = false; # WebRTC
    "media.peerconnection.ice.no_host" = false;
    "media.synth.enable" = false;
    "media.webspeech.recognition.enable" = false;
    "media.webspeech.synth.enabled" = false;
    "offline-apps.allow_by_default" = false;
    "webgl.disabled" = true;

    # Web AntiFeatures
    "dom.event.clipboardevents.enabled" = false;
    "dom.allow_cut_copy" = false;
    "dom.event.contextmenu.enabled" = false;
    "dom.disable_beforeunload" = true;

    # Traching Features
    "beacon.enabled" = false;
    "browser.send_pings" = false;

    # getUserMedia
    "media.navigator.enabled" = false;
    "media.navigator.video.enabled" = false;
    "media.getusermedia.screensharing.enabled" = false;
    "media.audiocapture.enabled" = false;

    # Media
    "media.autoplay.default" = 2;
    "media.video_stats.enabled" = false;
    "media.gmp-gmpopenh264.enabled" = false;
    "media.gmp-gmpopenh264.visible" = false;
    "media.gmp-manager.url" = false;
    "media.gmp-widevinecdm.enable" = false;
    "media.gmp-widevinecdm.visible" = false;

    # Generic Information
    "dom.maxHardwareConcurrency" = 2;
    "browser.search.countryCode" = "US";
    "browser.search.region" = "US";
    "browser.search.geoip.url" = "";
    "intl.accept_languages" = "en-US";
    "intl.locale.matchOS" = false;
    "browser.search.geoSpecificDefaults" = false;
    "javascript.use_us_english_locale" = true;

    # MISC
    "glx.font_rendering.opentype_svg.enabled" = false;
    "clipboard.autocopy" = false;
    "network.manage-offline-status" = false;
    "network.proxy.socks_remote_dns" = true;
    "security.mixed_content.block_active_content" = true;
    "security.mixed_content.block_display_content" = true;
    "security.mixed_content.block_object_subrequest" = true;
    "security.fileuri.scrict_origin_policy" = true;
    "security.xpconnect.plugin.unrestricted" = false;
    "security.dialog_enable_delay" = 1000;
    "security.getAddons.cache.enabled" = false;
    "lightweightThemes.update.enabled" = false;
    "broser.display.use_document_fonts" = 0;

    # Extensions
    "extensions.update.enalbed" = true;
    "extensions.blocklist.enabled" = true;
    "services.blocklist.update_enabled" = true;

    # Fingerprinting
    "privacy.trackingprotection.enabled" = true;
    "privacy.userContext.enabled" = true;
    "privacy.resistFingerprinting" = true;
    "pdfjs.disabled" = true;

    # Anti-Features
    "devtools.webide.enabled" = false;
    "devtools.debugger.remote-enabled" = false;
    "devtools.chrome.enabled" = false;
    "devtools.debugger.force-local" = true;

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
    "network.captive-portal-service.enabled" = false;
    "browser.casting.enabled" = false;

    # HTTP
    "dom.security.https_only_mode" = true;
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
