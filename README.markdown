# Piktur Spec

Install the following gems globally:

```bash
> rvm gemset use ruby-2.4.1@global
> gem install dotenv
> gem install bundler

> rvm gemset use ruby-2.4.1@piktur
> bin/bundle install
```

Ensure executables exist in `/bin` and that they point to the dummy application.

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
Piktur::Spec.define_test_application!

# OR

require File.join(Gem.loaded_specs['piktur_spec'].gem_dir, 'config/environment')

# ./spec/dummy/config/environment.rb
# frozen_string_literal: true

require 'piktur/spec'
Piktur::Spec.init_test_application!

# OR

require File.join(Gem.loaded_specs['piktur_spec'].gem_dir, 'config/application')
```
