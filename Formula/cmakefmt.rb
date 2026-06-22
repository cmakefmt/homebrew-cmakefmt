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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "17fdf87ca7a2991c01071d4735b90eb55909927612d411e739fc25251c3f7494"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6593dffeec370f36d931f6bc350e19cba59d016e76403784097681df9bea38d2"
    sha256 cellar: :any_skip_relocation, tahoe:         "767fe38fb2f5599b3ea2d6ab8db828543c6f969a99558deb5cdf9b4a774cdeb0"
    sha256 cellar: :any_skip_relocation, sequoia:       "e0d2c868360f65a9c1a06f7fd78bbc6fcfce66400f851dbcf664f47e52d73e5d"
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
