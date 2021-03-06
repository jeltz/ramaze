namespace :release do
  task :all => [:release_github, :release_rubyforge]

  desc 'Display instructions to release on github'
  task :github => [:jquery, :reversion, :gemspec] do
    name, version = GEMSPEC.name, GEMSPEC.version

    puts <<INSTRUCTIONS
First add the relevant files:

git add MANIFEST CHANGELOG #{name}.gemspec lib/#{name}/version.rb

Then commit them, tag the commit, and push:

git commit -m 'Version #{version}'
git tag -a -m '#{version}' '#{version}'
git push

INSTRUCTIONS

  end

  # TODO: Not tested
  desc 'Display instructions to release on rubyforge'
  task :rubyforge => [:jquery, :reversion, :gemspec, :package] do
    name, version = GEMSPEC.name, GEMSPEC.version

    puts <<INSTRUCTIONS
To publish to rubyforge do following:

rubyforge login
rubyforge add_release #{name} #{name} '#{version}' pkg/#{name}-#{version}.gem

After you have done these steps, see:

rake release:rubyforge_archives

INSTRUCTIONS
  end

  desc 'Display instructions to add archives after release:rubyforge'
  task :rubyforge_archives do
    name, version = GEMSPEC.name, GEMSPEC.version
    puts "Adding archives for distro packagers is:", ""

    Dir["pkg/#{name}-#{version}.{tgz,zip}"].each do |file|
      puts "rubyforge add_file #{name} #{name} '#{version}' '#{file}'"
    end

    puts
  end
end
