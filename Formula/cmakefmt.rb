# SPDX-FileCopyrightText: Copyright 2026 Puneet Matharu
#
# SPDX-License-Identifier: MIT OR Apache-2.0

class Cmakefmt < Formula
  desc "Fast, correct CMake formatter"
  homepage "https://cmakefmt.dev"
  url "https://github.com/cmakefmt/cmakefmt/archive/refs/tags/v2.1.0.tar.gz"
  sha256 "539f78aebbf37bf1315708dfe22d05d548b301171f0acd9f10c2a5b0c6a80889"
  license any_of: ["MIT", "Apache-2.0"]

  bottle do
    root_url "https://github.com/cmakefmt/homebrew-cmakefmt/releases/download/v2.1.0"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "028ebb6b04e67b5d3b2288859da9cfe3c56ffd99d2ba13176a8d02b09b4ad5f8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bffff44adb1420004a5ea083eb8c86ac0b8eecef00ebe13b0087d996f249b403"
    sha256 cellar: :any_skip_relocation, tahoe:         "1525d0cb08c75b1e830373cda948493bea2bdfcab589c654b230bfbcf1879b97"
    sha256 cellar: :any_skip_relocation, sequoia:       "65061b0d0129c3882baee05008e31d59bd44e8f19df2b446c4fcadeef554b6d3"
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
