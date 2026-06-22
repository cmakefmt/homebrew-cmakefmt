# SPDX-FileCopyrightText: Copyright 2026 Puneet Matharu
#
# SPDX-License-Identifier: MIT OR Apache-2.0

class Cmakefmt < Formula
  desc "Fast, correct CMake formatter"
  homepage "https://cmakefmt.dev"
  url "https://github.com/cmakefmt/cmakefmt/archive/refs/tags/v1.7.0.tar.gz"
  sha256 "80b2880b5774779e974f941752111c73a147bb8fa94d2117ddeb91aa716eae29"
  license any_of: ["MIT", "Apache-2.0"]

  bottle do
    root_url "https://github.com/cmakefmt/homebrew-cmakefmt/releases/download/v1.7.0"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5d54ed83b13bd3ef681add214dc2c10c51accfad236dff788b067feb6af00ba3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d4bfefdfa94f59161baae84fec5bb77dbadd3183fe050c589f8f106bc9065a51"
    sha256 cellar: :any_skip_relocation, tahoe:         "3e34b3f7ed215a7e588c771f9d0776faa7ae2a5cc820ee1298efb33f2112a28c"
    sha256 cellar: :any_skip_relocation, sequoia:       "1686d15c8b1aa3c57ed695a4aed6504a0215641dbf6b1952ecaa472d78d15812"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: ".")

    (buildpath/"cmakefmt.bash").write Utils.safe_popen_read(bin/"cmakefmt", "completions", "bash")
    (buildpath/"_cmakefmt").write Utils.safe_popen_read(bin/"cmakefmt", "completions", "zsh")
    (buildpath/"cmakefmt.fish").write Utils.safe_popen_read(bin/"cmakefmt", "completions", "fish")
    (buildpath/"cmakefmt.1").write Utils.safe_popen_read(bin/"cmakefmt", "manpage")

    bash_completion.install buildpath/"cmakefmt.bash"
    zsh_completion.install buildpath/"_cmakefmt"
    fish_completion.install buildpath/"cmakefmt.fish"
    man1.install buildpath/"cmakefmt.1"
  end

  test do
    (testpath/"CMakeLists.txt").write("project(foo)\n")
    assert_match "project(foo)", shell_output("#{bin}/cmakefmt CMakeLists.txt")
  end
end
