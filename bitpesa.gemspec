$:.unshift(File.join(File.dirname(__FILE__), 'lib'))

require "bitpesa/version"

spec = Gem::Specification.new do |s|
  s.name = "bitpesa"
  s.version = BitPesa::VERSION
  s.required_ruby_version = ">= 2.3.0"
  s.summary = "BitPesa API wrapper in Ruby"
  s.description = "BitPesa is a payment provider. See https://bitpesa.com for details."
  s.author = "Bitbond"
  s.email = "developers@bitbond.com"
  s.homepage = "https://api.bitpesa.co/documentation"
  s.license = "MIT"

  s.files = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- test/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end