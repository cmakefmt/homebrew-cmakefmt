# SPDX-FileCopyrightText: Copyright 2026 Puneet Matharu
#
# SPDX-License-Identifier: MIT OR Apache-2.0

class Cmakefmt < Formula
  desc "Fast, correct CMake formatter"
  homepage "https://cmakefmt.dev"
  url "https://github.com/cmakefmt/cmakefmt/archive/refs/tags/v2.3.1.tar.gz"
  sha256 "e552703d22b061e7302e6bc7d3934ba073c7a00929a6e7c1971f7966e8cf43e6"
  license any_of: ["MIT", "Apache-2.0"]

  bottle do
    root_url "https://github.com/cmakefmt/homebrew-cmakefmt/releases/download/v2.3.1"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4132551f2e7a3b0ec2cbcbaf0ea1850112fbf3f4ae7f30aa0d70de66e26165ef"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "69caeab78afaf0c41c63b5345d650e6822fffed0db4bea75407bd28450632d66"
    sha256 cellar: :any_skip_relocation, tahoe:         "45c61750625b237185164bab86e47e263538a989cdc39ede8455beb36ccf0b4d"
    sha256 cellar: :any_skip_relocation, sequoia:       "3553d0131dbbb12f0e7274c00c0e8c46abc94863cb5c44f32293858754901522"
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
