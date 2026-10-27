# SPDX-FileCopyrightText: Copyright 2026 Puneet Matharu
#
# SPDX-License-Identifier: MIT OR Apache-2.0

class Cmakefmt < Formula
  desc "Fast, correct CMake formatter"
  homepage "https://cmakefmt.dev"
  url "https://github.com/cmakefmt/cmakefmt/archive/refs/tags/v2.3.2.tar.gz"
  sha256 "62e1b2e08d82078c059794ab80593ca48213bc16a647b4296c5c45976639869f"
  license any_of: ["MIT", "Apache-2.0"]

  bottle do
    root_url "https://github.com/cmakefmt/homebrew-cmakefmt/releases/download/v2.3.2"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "48ce777c4d220910fd7444ffb3adbc946d0f275b9021f72418dab9ba694f6d3e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "65b47da817d88a43e5b686272054a33969472a745ac095d596314b2c7bc3804b"
    sha256 cellar: :any_skip_relocation, tahoe:         "e536f6b00336a4e26fc23a77edbbf9c694a17b2dba1dd8b758c120bc020315db"
    sha256 cellar: :any_skip_relocation, sequoia:       "14cb4d596dc65b601d4812bc11fb8774ff83f66f894f0d917eb4149fbade7cb4"
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
