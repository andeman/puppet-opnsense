
if ENV['COVERAGE'] == 'yes'
  require 'simplecov'
  require 'simplecov-console'
  require 'codecov'

  SimpleCov.formatters = [
    SimpleCov::Formatter::HTMLFormatter,
    SimpleCov::Formatter::Console,
    SimpleCov::Formatter::Codecov,
  ]
  SimpleCov.start do
    track_files 'lib/**/*.rb'

    add_filter '/spec'

    # do not track vendored files
    add_filter '/vendor'
    add_filter '/.vendor'

    # do not track gitignored files
    # this adds about 4 seconds to the coverage check
    # this could definitely be optimized
    add_filter do |f|
      # system returns true if exit status is 0, which with git-check-ignore means file is ignored
      system("git check-ignore --quiet #{f.filename}")
    end
  end
end

def write_yaml(path, data, mode = 0o600)
  File.open(path, 'w') do |file|
    file.write(YAML.dump(data))
    file.chmod(mode)
  end
end

def hash_from_fixture_yaml_file(fixture_path)
  fixture_yaml_path = File.join(File.dirname(__FILE__), 'fixtures', fixture_path)
  yaml_file = File.read(fixture_yaml_path)
  YAML.safe_load(yaml_file)
end
