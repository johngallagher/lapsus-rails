# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "newrelic_rpm"
  s.version = "3.5.5.38"

  s.required_rubygems_version = Gem::Requirement.new("> 1.3.1") if s.respond_to? :required_rubygems_version=
  s.authors = ["Jason Clark", "Sam Goldstein", "Jon Guymon", "Ben Weintraub"]
  s.date = "2013-01-07"
  s.description = "New Relic is a performance management system, developed by New Relic,\nInc (http://www.newrelic.com).  New Relic provides you with deep\ninformation about the performance of your web application as it runs\nin production. The New Relic Ruby Agent is dual-purposed as a either a\nGem or plugin, hosted on\nhttp://github.com/newrelic/rpm/\n"
  s.email = "support@newrelic.com"
  s.executables = ["mongrel_rpm", "newrelic_cmd", "newrelic"]
  s.extra_rdoc_files = ["CHANGELOG", "LICENSE", "README.md", "GUIDELINES_FOR_CONTRIBUTING.md", "newrelic.yml"]
  s.files = ["bin/mongrel_rpm", "bin/newrelic_cmd", "bin/newrelic", "CHANGELOG", "LICENSE", "README.md", "GUIDELINES_FOR_CONTRIBUTING.md", "newrelic.yml"]
  s.homepage = "http://www.github.com/newrelic/rpm"
  s.post_install_message = "\n# New Relic Ruby Agent Release Notes #\n\n## v3.5.5 ##\n\n  * Add thread profiling support\n\n    Thread profiling performs statistical sampling of backtraces of all threads\n    within your Ruby processes. This feature requires MRI >= 1.9.2, and is\n    controlled via the New Relic web UI. JRuby support (in 1.9.x compat mode) is\n    considered experimental, due to issues with JRuby's Thread#backtrace.\n\n  * Add audit logging capability\n\n    The agent can now log all of the data it sends to the New Relic servers to\n    a special log file for human inspection. This feature is off by default, and\n    can be enabled by setting the audit_log.enabled configuration key to true.\n    You may also control the location of the audit log with the audit_log.path key. \n\n  * Use config system for dispatcher, framework, and config file detection\n\n    Several aspects of the agent's configuration were not being handled by the\n    configuration system.  Detection/configuration of the dispatcher (e.g. passenger,\n    unicorn, resque), framework (e.g. rails3, sinatra), and newrelic.yml\n    location are now handled via the Agent environment, manual, and default\n    configuration sources.\n\n  * Updates to logging across the agent\n\n    We've carefully reviewed the logging messages that the agent outputs, adding\n    details in some cases, and removing unnecessary clutter. We've also altered\n    the startup sequence to ensure that we don't spam STDOUT with messages\n    during initialization.\n\n  * Fix passing environment to manual_start()\n\n    Thanks to Justin Hannus.  The :env key, when passed to Agent.manual_start,\n    can again be used to specify which section of newrelic.yml is loaded.\n\n  * Rails 4 support\n\n    This release includes preliminary support for Rails 4 as of 4.0.0.beta.\n    Rails 4 is still in development, but the agent should work as expected for\n    people who are experimenting with the beta.\n\n\nSee https://github.com/newrelic/rpm/blob/master/CHANGELOG for a full list of\nchanges.\n"
  s.rdoc_options = ["--line-numbers", "--inline-source", "--title", "New Relic Ruby Agent"]
  s.require_paths = ["lib"]
  s.rubygems_version = "1.8.23"
  s.summary = "New Relic Ruby Agent"

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
