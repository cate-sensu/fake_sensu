# Fake Sensu
A sensu api without all the dependencies. For testing.

## Usage
Include it in your spec helper

```ruby
require 'fake_sensu'
FakeSensu.version = '0.10.12'
FakeSensu.start!
```

## Adding a new verision
If you want to add support for an additional sensu api version, just point the add_version script to a sensu api with default seed data loaded. If successful, the version will become available.

```bash
./add_version http://foo:bar@0.0.0.0/4567
```
