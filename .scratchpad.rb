require 'date' # => true


DateTime.parse('2014-11-30 13:54:47') # => #<DateTime: 2014-11-30T13:54:47+00:00 ((2456992j,50087s,0n),+0s,2299161j)>

require 'yaml'
{ wow: 'hello'}.to_yaml # => "---\n:wow: hello\n"

File.ftype('/Users/johngallagher/Dropbox/Projects/ProgrammingProjects/CurrentProjects/lapsus-rails') # => "directory"
