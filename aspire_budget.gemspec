# frozen_string_literal: true

require_relative 'lib/version'

Gem::Specification.new do |spec|
  spec.name          = 'aspire_budget'
  spec.version       = AspireBudget::VERSION
  spec.authors       = ['Drowze']
  spec.email         = ['gibim6+aspire@gmail.com']

  spec.summary       = 'Aspire Budget Ruby Wrapper'
  spec.description   = 'Aspire Budget Ruby Wrapper'
  spec.homepage      = 'https://google.com'
  spec.license       = 'MIT'
  spec.required_ruby_version = Gem::Requirement.new('>= 2.3.0')

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/drowze/aspirebudgeting_ruby'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_runtime_dependency 'google_drive', '~> 3.0'

  spec.add_development_dependency 'pry'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'rubocop', '~> 0.87.1'
  spec.add_development_dependency 'simplecov'
end
