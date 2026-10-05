# SPDX-FileCopyrightText: Copyright 2026 Puneet Matharu
#
# SPDX-License-Identifier: MIT OR Apache-2.0

class Cmakefmt < Formula
  desc "Fast, correct CMake formatter"
  homepage "https://cmakefmt.dev"
  url "https://github.com/cmakefmt/cmakefmt/archive/refs/tags/v2.0.0.tar.gz"
  sha256 "b564bb888a5a8f559c20df45e715c9ac5df05849ef6b665d855b7502adf155d9"
  license any_of: ["MIT", "Apache-2.0"]

  bottle do
    root_url "https://github.com/cmakefmt/homebrew-cmakefmt/releases/download/v2.0.0"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b0a188f18f3b7fac1bd7fa357dc73cde7c80c45a87e6f0da8a323d9bde62115f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9e60f16f5f0fe7ef44b4defff63e948e611ac0117f8e8af69e057873bb4fe11d"
    sha256 cellar: :any_skip_relocation, tahoe:         "ee9a15b43875c37c02054d7a396f88d19aa0b644cde8418b6e2805ecd3b84db4"
    sha256 cellar: :any_skip_relocation, sequoia:       "225ed11cb09e4ae4d5bdd9f2e8add293fa29dbee1bcf643f7b922bdb786d0cd3"
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
