# SPDX-FileCopyrightText: Copyright 2026 Puneet Matharu
#
# SPDX-License-Identifier: MIT OR Apache-2.0

class Cmakefmt < Formula
  desc "Fast, correct CMake formatter"
  homepage "https://cmakefmt.dev"
  url "https://github.com/cmakefmt/cmakefmt/archive/refs/tags/v2.2.0.tar.gz"
  sha256 "2a17ad5bcacc3697a1b163da4c8f38135277ceaca7cbd36b20ee672f18bb19cb"
  license any_of: ["MIT", "Apache-2.0"]

  bottle do
    root_url "https://github.com/cmakefmt/homebrew-cmakefmt/releases/download/v2.2.0"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8f60de1f6a313f6fded2129e1687198da8458a58bdc65ebbb6851a7f147cf23d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fb2f04d00b632dc64e554db2c26507dcc60cedd1b5d3338f1c9bd9915e479523"
    sha256 cellar: :any_skip_relocation, tahoe:         "7a2cc1ad7e68adf71de214e20c0de1c71bd648f907ffbf02433f642f70302af0"
    sha256 cellar: :any_skip_relocation, sequoia:       "d61c54606e3c959375c8e88b069c58732989d19476c28a71d4fc1ad7139ccc93"
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
