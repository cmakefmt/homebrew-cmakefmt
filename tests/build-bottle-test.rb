# SPDX-FileCopyrightText: Copyright 2026 Puneet Matharu
#
# SPDX-License-Identifier: MIT OR Apache-2.0

# No installation occurs: run with "brew ruby tests/build-bottle-test.rb".
require "formula_installer"
require "tmpdir"

builder = File.expand_path("../scripts/build-bottle.rb", __dir__)
Dep = Struct.new(:name, :build?)
TestFormula = Struct.new(:deps)

class << Formulary
  attr_accessor :test_formula

  def factory(_name)
    test_formula
  end
end

class FormulaInstaller
  class << self
    attr_accessor :test_options, :test_steps
  end

  def initialize(_formula, **options)
    self.class.test_options = options
    self.class.test_steps = []
  end

  %i[prelude fetch install finish].each do |step|
    define_method(step) { self.class.test_steps << step }
  end
end

def assert_installation
  expected = { build_bottle: true, ignore_deps: true, env: "std", installed_on_request: true }
  raise "Unexpected installer options" unless FormulaInstaller.test_options == expected
  raise "Unexpected install sequence" unless FormulaInstaller.test_steps == %i[prelude fetch install finish]
end

# Entered by a fresh brew process, with its real environment and PATH filtering.
if ARGV.first == "--integration"
  ARGV.shift
  raise "Homebrew did not filter the test variable" if ENV.key?("CMAKEFMT_RUST_BIN")
  Formulary.test_formula = TestFormula.new([Dep.new("rust", true)])
  load builder
  assert_installation
  exit
end

Dir.mktmpdir("cmakefmt-rust-bin") do |dir|
  rust_bin = Pathname.new(dir).realpath
  %w[cargo rustc].each do |name|
    (rust_bin/name).write("")
    (rust_bin/name).chmod(0o755)
  end
  passed = system(
    {
      "CMAKEFMT_RUST_BIN" => rust_bin.to_s,
      "PATH" => "#{rust_bin}:#{ENV.fetch('HOMEBREW_PATH')}",
      # Model a fresh CI shell, not a nested brew command that restores its parent's PATH.
      "HOMEBREW_BREW_FILE" => nil,
    },
    ENV.fetch("HOMEBREW_BREW_FILE"), "ruby", "--", __FILE__, "--integration", rust_bin.to_s,
  )
  raise "Homebrew invocation failed" unless passed

  ARGV.replace([rust_bin.to_s])
  paths = ORIGINAL_PATHS + [rust_bin]
  Object.send(:remove_const, :ORIGINAL_PATHS)
  Object.const_set(:ORIGINAL_PATHS, paths.freeze)
  Formulary.test_formula = TestFormula.new([Dep.new("rust", true)])
  load builder
  assert_installation

  [[], [rust_bin.to_s, "extra"]].each do |args|
    ARGV.replace(args)
    begin
      load builder
      raise "Invalid arguments were accepted"
    rescue SystemExit => error
      raise "Guard exited successfully" if error.success?
    end
  end
  ARGV.replace([rust_bin.to_s])

  [[Dep.new("rust", false)], [Dep.new("rust", true), Dep.new("openssl@3", false)]].each do |deps|
    Formulary.test_formula = TestFormula.new(deps)
    begin
      load builder
      raise "Unsafe dependencies were accepted"
    rescue SystemExit => error
      raise "Guard exited successfully" if error.success?
    end
  end

  Formulary.test_formula = TestFormula.new([Dep.new("rust", true)])
  (rust_bin/"rustc").chmod(0o644)
  begin
    load builder
    raise "Missing compiler was accepted"
  rescue SystemExit => error
    raise "Guard exited successfully" if error.success?
  end
end

puts "Bottle installer and dependency guards passed."
