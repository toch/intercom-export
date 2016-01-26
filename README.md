# Intercom Export

Export data from Intercom.

## Installation

See [mruby-cli](https://github.com/hone/mruby-cli) for more details.

```
docker-compile run compile
```

## Usage

For now, you can only request the list of conversations and it prints it as
a raw JSON on stdout

```
./mruby/build/host/bin/intercom-export -t <API KEY>:<API SECRET> -r conversations
```

## Contributing

1. Fork it ( https://github.com/toch/intercom-export/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
