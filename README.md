# Fake Sensu
A sensu api without all the dependencies. For testing. 

## Usage
Include it in your spec or test helper, and start it in the before suite block:

```ruby
require 'fake_sensu'

RSpec.configure do |config|
  config.before :suite do
    FakeSensu.start! "0.10.2"
  end
end
```

## Adding a new verision
If you want to add support for an additional sensu api version: 
1) spin up a vagrant vm with sensu on it 
2) run the test suite, killing it before the end (be sure to fully log out or the test suite will continue to run in the background and kill your data)
3) run the generate_responses script against the sensu vm you created

```bash
./generate_responses http://foo:bar@192.168.5.5/4567
```
