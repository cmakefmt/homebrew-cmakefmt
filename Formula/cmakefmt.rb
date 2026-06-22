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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "28cd7c64eba44e87f1f3621acbd1f798a11143089202290b8f4e7a25d44c2696"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "063bebb7568d236cc820639234472890ce4fdd3de3d9227a6941daf0ac3262a3"
    sha256 cellar: :any_skip_relocation, tahoe:         "eaf162b3e19a75bc7ae777dbf112b7771dad1e2bb822b57fbe4f67721094a3f8"
    sha256 cellar: :any_skip_relocation, sequoia:       "da2623852eb7ea6ac082d6849dad46cfde43abbfdfb3a99526cfba40fe93c3b9"
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
