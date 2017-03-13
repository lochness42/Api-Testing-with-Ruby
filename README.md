## This is the setup guide for API testing on Mac

## Installation steps

#### If you don't have ruby set up

Then check the same with rvm, not run these commands:
```
curl -sSL https://get.rvm.io | bash -s stable
rvm install ruby
source ~/.bashrc
```
And make sure the right version of ruby is being used:
```
rvm install 2.2.1
rvm use 2.2.1
/bin/bash --login (this is optional if using on for instance, the Vagrant VM setup)
```
Update RubyGems and bundler if needs be:
```
gem install --no-rdoc --no-ri bundler
gem update
```

#### Once Ruby is set up
Run `bundle install` to install your desired gems

## Running Api tests
`bundle exec cucumber` or `bundle exec cucumber DEBUG=1` if you want more extensive debug information during run
