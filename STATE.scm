;; SPDX-License-Identifier: PMPL-1.0-or-later
;; STATE.scm - Current project state

(define project-state
  `((metadata
      ((version . "0.1.0")
       (schema-version . "1")
       (created . "2026-01-10T13:49:37+00:00")
       (updated . "2026-02-04T10:30:00+00:00")
       (project . "fireflag")
       (repo . "fireflag")))

    (project-context
      ((name . "FireFlag")
       (tagline . "Safe Firefox/Gecko flag management for users and developers")
       (tech-stack . ("ReScript" "Idris2" "Zig" "WASM" "Deno"))))

    (current-position
      ((phase . "Active Development")
       (overall-completion . 75)
       (components
         ((manifest . 100)
          (directory-structure . 100)
          (flag-database . 50)
          (rescript-core . 100)
          (idris-ffi . 100)
          (ui-popup . 100)
          (ui-sidebar . 100)
          (ui-options . 100)
          (devtools-panel . 100)
          (background-worker . 100)
          (security-integration . 80)
          (icons . 100)
          (containerization . 0)))
       (working-features . ("Popup flag management"
                            "Sidebar tracking & export"
                            "Options page configuration"
                            "DevTools performance panel"
                            "Permission request flow"))))

    (route-to-mvp
      ((milestones
        ((v0.1.0-structure
          . ((items . ("Manifest V3 setup"
                       "Extension directory structure"
                       "rsr-template-repo workflows"))
             (status . "in-progress")))
         (v0.2.0-core
          . ((items . ("Flag database with safety levels"
                       "ReScript core types"
                       "Idris FFI integration from proven"
                       "WASM optimizations"))
             (status . "pending")))
         (v0.3.0-ui
          . ((items . ("Browser action popup"
                       "Sidebar panel"
                       "Options page"
                       "Granular permission UI"))
             (status . "pending")))
         (v0.4.0-features
          . ((items . ("Flag tracking (before/after)"
                       "Export reports"
                       "DevTools integration"
                       "Performance metrics"))
             (status . "pending")))
         (v0.5.0-security
          . ((items . ("svalin static analysis"
                       "vordr runtime verification"
                       "selur secrets detection"
                       "Security audit"))
             (status . "pending")))
         (v0.6.0-build
          . ((items . ("cerro-terro containerization"
                       "chainguard base images"
                       "Guix channel setup"
                       "Reproducible builds"))
             (status . "pending")))
         (v1.0.0-release
          . ((items . ("Mozilla Add-ons submission"
                       "Multi-browser testing (Firefox, Librewolf, Waterfox, Pale Moon)"
                       "Store listing with screenshots"
                       "Privacy policy and documentation"))
             (status . "pending")))))))

    (blockers-and-issues
      ((critical . ())
       (high . ("Flag database needs curation - combine Firefox docs + our analysis"))
       (medium . ("Test Pale Moon compatibility (different Gecko version)"
                  "Determine WASM module size limits for extension"))
       (low . ())))

    (critical-next-actions
      ((immediate . ("Create flag database schema"
                     "Import proven Idris FFI modules"
                     "Build ReScript core types for browser flags"))
       (this-week . ("Implement all three UI components"
                     "Add granular permission feedback system"
                     "Set up flag safety classification"))
       (this-month . ("Complete developer tracking features"
                      "Integrate security scanning (svalin/vordr/selur)"
                      "Build containerized environment"
                      "Test on all target browsers"))))

    (session-history
      ((session-1
        . ((timestamp . "2026-02-04T10:30:00+00:00")
           (accomplishments . ("Backed up old feature flag library code to branch"
                               "Reset repo structure for browser extension"
                               "Created Manifest V3 configuration"
                               "Set up extension directory structure"
                               "Synced rsr-template-repo workflows"
                               "Updated STATE.scm with new project goals"
                               "Created task list (10 tasks)"))))))))

;; Helper functions
(define (get-completion-percentage state)
  (let ((components (cdr (assoc 'components (cdr (assoc 'current-position state))))))
    (/ (apply + (map cdr components)) (length components))))

(define (get-blockers state severity)
  (cdr (assoc severity (cdr (assoc 'blockers-and-issues state)))))

(define (get-milestone state name)
  (assoc name (cdr (assoc 'milestones (cdr (assoc 'route-to-mvp state))))))
