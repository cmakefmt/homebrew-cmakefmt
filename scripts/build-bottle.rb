# SPDX-FileCopyrightText: Copyright 2026 Puneet Matharu
#
# SPDX-License-Identifier: MIT OR Apache-2.0

# Run with "brew ruby -- scripts/build-bottle.rb /path/to/rust/bin" on an ephemeral CI runner.
# Homebrew no longer provides Intel bottles for Rust and its dependencies.
# Use an independently installed Rust toolchain without changing the formula
# or bypassing its source archive checksum. Normal installs still use brew.
require "formula_installer"

formula = Formulary.factory("cmakefmt/cmakefmt/cmakefmt")
unless formula.deps.length == 1 && formula.deps.first.name == "rust" && formula.deps.first.build?
  abort "Expected Rust to be the only dependency; review the bottle builder before adding dependencies."
end

# Homebrew filters arbitrary environment variables before invoking Ruby.
abort "Usage: brew ruby -- scripts/build-bottle.rb /path/to/rust/bin" unless ARGV.length == 1
rust_bin = Pathname.new(ARGV.fetch(0)).realpath
unless %w[cargo rustc].all? { |name| (rust_bin/name).executable? } && ORIGINAL_PATHS.include?(rust_bin)
  abort "The Rust toolchain directory must contain cargo and rustc and be on PATH before running brew."
end

# Using FormulaInstaller lets this CI-only build select the standard
# environment. The old "brew install --env=std" CLI option is disabled.
installer = FormulaInstaller.new(
  formula,
  build_bottle: true,
  ignore_deps: true,
  env: "std",
  installed_on_request: true,
)
installer.prelude
installer.fetch
installer.install
installer.finish
abort "Homebrew reported an installation failure." if Homebrew.failed?
