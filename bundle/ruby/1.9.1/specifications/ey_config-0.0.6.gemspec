# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "ey_config"
  s.version = "0.0.6"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Jacob Burkhart & Michael Broadhead & others"]
  s.date = "2012-05-14"
  s.description = "Access to additional services for Engine Yard customers."
  s.email = ["jacob@engineyard.com"]
  s.executables = ["ey_config_local"]
  s.files = ["bin/ey_config_local"]
  s.homepage = "http://github.com/engineyard/ey_config"
  s.require_paths = ["lib"]
  s.rubygems_version = "1.8.23"
  s.summary = "Engine Yard Configuration"

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
