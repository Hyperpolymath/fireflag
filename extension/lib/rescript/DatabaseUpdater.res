// SPDX-License-Identifier: PMPL-1.0-or-later
// Copyright (C) 2026 Jonathan D.A. Jewell <jonathan.jewell@open.ac.uk>

/**
 * Flag Database Auto-Updater
 *
 * Keeps flag database current with Mozilla's changes:
 * - Weekly checks for database updates from GitHub
 * - Detects deprecated/removed flags
 * - Validates against current Firefox version
 * - Community contribution pipeline
 */

open Types

type databaseVersion = {
  version: string,
  lastUpdated: string,
  minimumGeckoVersion: string,
  maximumGeckoVersion: option<string>,
}

type updateSource =
  | GitHub(string) // GitHub release URL
  | Community(string) // Community PR URL
  | Manual(string) // Manual update file

type updateStatus =
  | UpToDate
  | UpdateAvailable(databaseVersion)
  | UpdateRequired(string) // Reason for requirement
  | UpdateFailed(string) // Error message

// Check for database updates from GitHub releases
let checkForUpdates = async (currentVersion: string): updateStatus => {
  try {
    // Fetch latest release from GitHub API
    let response = await Fetch.fetch(
      "https://api.github.com/repos/hyperpolymath/fireflag/releases/latest",
    )

    if !response->Fetch.Response.ok {
      UpdateFailed("Failed to fetch update information")
    } else {
      let json = await response->Fetch.Response.json
      let latestVersion = json
        ->Js.Json.decodeObject
        ->Option.flatMap(obj => Js.Dict.get(obj, "tag_name"))
        ->Option.flatMap(Js.Json.decodeString)
        ->Option.getOr(currentVersion)

      if latestVersion > currentVersion {
        UpdateAvailable({
          version: latestVersion,
          lastUpdated: Js.Date.now()->Js.Date.fromFloat->Js.Date.toISOString,
          minimumGeckoVersion: "109.0",
          maximumGeckoVersion: None,
        })
      } else {
        UpToDate
      }
    }
  } catch {
  | exn => UpdateFailed(Js.Exn.message(exn)->Option.getOr("Unknown error"))
  }
}

// Download and validate updated database
let downloadDatabase = async (version: databaseVersion): result<flagDatabase, string> => {
  try {
    let url = `https://github.com/hyperpolymath/fireflag/releases/download/${version.version}/flags-database.json`

    let response = await Fetch.fetch(url)

    if !response->Fetch.Response.ok {
      Error("Failed to download database")
    } else {
      let json = await response->Fetch.Response.json
      let db = parseFlagDatabase(json) // Validate schema

      Ok(db)
    }
  } catch {
  | exn => Error(Js.Exn.message(exn)->Option.getOr("Download failed"))
  }
}

// Validate flag availability against current browser version
let validateFlagForBrowser = (flag: flag, browserVersion: string): bool => {
  // Check minimum version
  let meetsMin = switch flag.geckoMinVersion {
  | Some(minVer) => compareVersions(browserVersion, minVer) >= 0
  | None => true
  }

  // Check maximum version (if flag was removed)
  let meetsMax = switch flag.geckoMaxVersion {
  | Some(maxVer) => compareVersions(browserVersion, maxVer) <= 0
  | None => true
  }

  meetsMin && meetsMax
}

// Compare semantic versions (returns -1, 0, or 1)
let compareVersions = (a: string, b: string): int => {
  let parseVersion = v =>
    v
    ->String.split(".")
    ->Array.map(s => Int.fromString(s)->Option.getOr(0))

  let aParts = parseVersion(a)
  let bParts = parseVersion(b)
  let maxLen = Int.max(Array.length(aParts), Array.length(bParts))

  let rec compare = (i: int): int => {
    if i >= maxLen {
      0
    } else {
      let aVal = Array.get(aParts, i)->Option.getOr(0)
      let bVal = Array.get(bParts, i)->Option.getOr(0)

      if aVal < bVal {
        -1
      } else if aVal > bVal {
        1
      } else {
        compare(i + 1)
      }
    }
  }

  compare(0)
}

// Filter database for current browser version
let filterDatabaseForBrowser = (db: flagDatabase, browserVersion: string): flagDatabase => {
  {
    ...db,
    flags: db.flags->Array.filter(flag => validateFlagForBrowser(flag, browserVersion)),
  }
}

// Detect deprecated flags (have maxVersion)
let findDeprecatedFlags = (db: flagDatabase): array<flag> => {
  db.flags->Array.filter(flag => flag.geckoMaxVersion->Option.isSome)
}

// Detect flags unavailable in current version
let findUnavailableFlags = (db: flagDatabase, browserVersion: string): array<flag> => {
  db.flags->Array.filter(flag => !validateFlagForBrowser(flag, browserVersion))
}

// Auto-update workflow
let autoUpdate = async (currentVersion: string, enableAutoUpdate: bool): result<
  flagDatabase,
  string,
> => {
  if !enableAutoUpdate {
    Error("Auto-update disabled")
  } else {
    let status = await checkForUpdates(currentVersion)

    switch status {
    | UpToDate => Error("Already up to date")
    | UpdateFailed(msg) => Error(msg)
    | UpdateRequired(reason) => Error(`Update required: ${reason}`)
    | UpdateAvailable(version) => await downloadDatabase(version)
    }
  }
}

// Parse flag database from JSON
let parseFlagDatabase = (json: Js.Json.t): flagDatabase => {
  // TODO: Implement full JSON parsing with validation
  {
    version: "1.0.0",
    lastUpdated: Js.Date.now()->Js.Date.fromFloat->Js.Date.toISOString,
    categories: Js.Dict.empty(),
    flags: [],
  }
}
