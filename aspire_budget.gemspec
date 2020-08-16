# frozen_string_literal: true

require_relative 'lib/aspire_budget/version'

Gem::Specification.new do |spec|
  spec.name          = 'aspire_budget'
  spec.version       = AspireBudget::VERSION
  spec.authors       = ['Drowze']
  spec.email         = ['gibim6+aspire@gmail.com']
  spec.requirements  = 'Aspire Budget spreadsheet v3.1.0+'

  spec.summary       = 'Aspire Budget Ruby Wrapper'
  spec.description   = <<-DESCRIPTION
    Aspire Budget is a free zero-based envelope-style budgeting spreadsheet
    built with Google Sheets by Matthew Alcorn. This gem aims to provide an
    expressive Ruby interface to it.
  DESCRIPTION
  spec.homepage      = 'https://github.com/drowze/aspirebudgeting_ruby'
  spec.license       = 'MIT'
  spec.required_ruby_version = Gem::Requirement.new('>= 2.4.0')

  spec.metadata = {
    'homepage_uri' => spec.homepage,
    'source_code_uri' => spec.homepage
  }

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    %w[README.md LICENSE.txt] + Dir['lib/**/*']
  end

  spec.add_runtime_dependency 'google_drive', '~> 3.0'

  spec.add_development_dependency 'pry'
  spec.add_development_dependency 'pry-byebug', '~> 3.9.0'
  spec.add_development_dependency 'rake', '~> 13.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'rubocop', '~> 0.89.1'
  spec.add_development_dependency 'rubocop-packaging', '~> 0.2.0'
  spec.add_development_dependency 'rubocop-performance', '~> 1.7.1'
  spec.add_development_dependency 'rubocop-rspec', '~> 1.42.0'
  spec.add_development_dependency 'rubocop-thread_safety', '~> 0.4.1'
  spec.add_development_dependency 'simplecov', '~> 0.17.0'
  spec.add_development_dependency 'webmock'
end
