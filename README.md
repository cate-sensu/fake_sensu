# Fake Sensu
A sensu api without all the dependencies. For testing. 

## Usage
Include it in your spec or test helper, and start it:

```ruby
require 'fake_sensu'

RSpec.configure do |config|
  config.before :suite do
    FakeSensu.version = '0.9.12' # optional
    FakeSensu.start!
  end
end
```

## Adding a new verision
If you want to add support for an additional sensu api version, just point the add_version script to a sensu api with default seed data loaded. If successful, the version will become available.

```bash
./add_version http://foo:bar@0.0.0.0/4567
```
