# SPDX-FileCopyrightText: Copyright 2026 Puneet Matharu
#
# SPDX-License-Identifier: MIT OR Apache-2.0

class Cmakefmt < Formula
  desc "Fast, correct CMake formatter"
  homepage "https://cmakefmt.dev"
  url "https://github.com/cmakefmt/cmakefmt/archive/refs/tags/v2.4.0.tar.gz"
  sha256 "02404edfeb4cac094f4db9a372a8f043b39a89158341ba5bca1d32b95ed9c593"
  license any_of: ["MIT", "Apache-2.0"]

  bottle do
    root_url "https://github.com/cmakefmt/homebrew-cmakefmt/releases/download/v2.4.0"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0e9097a601d4e114344013a7b2679036d36ef5ece890d5d8d426e1c3780d3427"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c32d758e813cf59c79adfa96f64269c6656874f1fcbbb1ef687bf482cafbad52"
    sha256 cellar: :any_skip_relocation, tahoe:         "2d856df97fdc85165db93c93294cebffac64f97e978707e4656c197fa1776d9f"
    sha256 cellar: :any_skip_relocation, sequoia:       "8ebe5d90dc54871dc907a3e3a53327e099308d3198018c12f9fa8a676d314076"
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
