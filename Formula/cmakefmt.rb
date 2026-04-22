# SPDX-FileCopyrightText: Copyright 2026 Puneet Matharu
#
# SPDX-License-Identifier: MIT OR Apache-2.0

class Cmakefmt < Formula
  desc "Fast, correct CMake formatter"
  homepage "https://cmakefmt.dev"
  url "https://github.com/cmakefmt/cmakefmt/archive/refs/tags/v1.1.0.tar.gz"
  sha256 "c903a4ad43bcc28f434861c1f50d552f238b1284a196dbe583f61d5b8dfb7e75"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: ".")

    (buildpath/"cmakefmt.bash").write Utils.safe_popen_read(bin/"cmakefmt", "completions", "bash")
    (buildpath/"_cmakefmt").write Utils.safe_popen_read(bin/"cmakefmt", "completions", "zsh")
    (buildpath/"cmakefmt.fish").write Utils.safe_popen_read(bin/"cmakefmt", "completions", "fish")
    (buildpath/"cmakefmt.1").write Utils.safe_popen_read(bin/"cmakefmt", "--generate-man-page")

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
