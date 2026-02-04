;; SPDX-License-Identifier: PMPL-1.0-or-later
;; ECOSYSTEM.scm - Project relationship mapping

(ecosystem
  (version "1.0")
  (name "fireflag")
  (type "browser-extension")
  (purpose "Safe Firefox/Gecko flag management for experimentation and development")

  (position-in-ecosystem
    (role "end-user-tool")
    (layer "application")
    (description "Browser extension that helps users and developers safely manage Firefox/Gecko flags (about:config, experimental features, developer flags) with safety classification, tracking, and analytics"))

  (related-projects
    ((proven
      . ((relationship . "dependency")
         (description . "Provides Idris2 FFI modules for compile-time safety guarantees (SafeJson, SafeUrl, SafeQueue, SafeLRU)")
         (url . "https://github.com/hyperpolymath/proven")))
     (svalin
      . ((relationship . "build-tool")
         (description . "Static analysis security scanner for extension code")
         (url . "https://github.com/hyperpolymath/svalin")))
     (vordr
      . ((relationship . "build-tool")
         (description . "Runtime verification for browser API usage")
         (url . "https://github.com/hyperpolymath/vordr")))
     (selur
      . ((relationship . "build-tool")
         (description . "Secrets detection for extension security")
         (url . "https://github.com/hyperpolymath/selur")))
     (cerro-terro
      . ((relationship . "build-tool")
         (description . "Build orchestration for containerized compilation")
         (url . "https://github.com/hyperpolymath/cerro-terro")))
     (rsr-template-repo
      . ((relationship . "template")
         (description . "Provides standard RSR workflows and infrastructure")
         (url . "https://github.com/hyperpolymath/rsr-template-repo")))))

  (what-this-is
    "FireFlag is a Firefox/Gecko browser extension that makes it safe and easy to experiment with browser flags. For regular users, it provides curated lists of safe flags to enable experimental features. For developers, it offers tracking, analytics, and export capabilities to understand how flag changes affect their applications and workflows.")

  (what-this-is-not
    ("A general feature flag management library (see backup-feature-flag-library branch)"
     "A Chrome/Chromium extension (Gecko browsers only)"
     "A tool for modifying Firefox source code"
     "A replacement for Firefox's built-in about:config interface")))
