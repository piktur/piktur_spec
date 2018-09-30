# Piktur Spec

Install the following gems globally:

```sh
  rvm gemset use ruby-2.5.1@global
  gem install dotenv
  gem install bundler

  rvm gemset use ruby-2.5.1@piktur
  bin/bundle install
```

Add gems [`piktur`](https://github.com/piktur/piktur.git) and [`piktur_spec`](https://github.com/piktur/piktur_spec.git) to the Gemfile.

```ruby
  gem 'piktur',                 git:    "https://github.com/piktur/piktur.git",
                                branch: 'master'

  group :test do
    gem 'piktur_spec',            git:    "https://github.com/piktur/piktur_spec.git",
                                  branch: 'master'
    gem 'rspec'
    gem 'simplecov',              require: false
  end
```

Configure `Spring.application_root`

```ruby
  # ./config/spring.rb

  Spring.application_root = './spec/dummy'
```

Utilise the test application as follows.

```ruby
  # ./spec/dummy/config/application.rb`
  # frozen_string_literal: true

  require 'piktur/spec'
  Piktur::Spec.define_rails_application!

  # OR

  require File.join(Gem.loaded_specs['piktur_spec'].gem_dir, 'config/environment')

  # ./spec/dummy/config/environment.rb
  # frozen_string_literal: true

  require 'piktur/spec'
  Piktur::Spec.init_rails_application!

  # OR

  require File.join(Gem.loaded_specs['piktur_spec'].gem_dir, 'config/application')
```

Ensure `/bin/rspec` exists and is executable `chmod +x ./bin/rspec`. If not add the file based on
[this snippet](https://github.com/piktur/piktur/src/master/bin/rspec) or copy the following:

```ruby
  #!/usr/bin/env ruby
  # frozen_string_literal: true

  begin
    load Gem.bin_path('piktur', 'test')
  rescue Gem::Exception
    load File.join(ENV.fetch('PIKTUR_HOME'), 'piktur/bin/test')
  end
```
