# tempdir.cr

Creates a temporary directory.

## Installation

1. Add the dependency to your `shard.yml`:

   ```yaml
   dependencies:
     tempdir.cr:
       github: lugia-kun/tempdir.cr
   ```

2. Run `shards install`

## Usage

```crystal
require "tempdir"
```

### Dir.mktmpdir

```crystal
dir = Dir.mktmpdir(*args)
```

Creates a temporary directory. Arguments are not checked by here, this
methods arguments to `File.tmpname` as-is. See `File.tempname`.

The returning object is `Tempdir`. It removes all entries when
`#close`-d.

With block, the created directory will be removed after block is left.

```crystal
Dir.mktmpdir(...) do |dir|
  # work with dir
end
```

### Tempdir

The temporary directory class based on `Dir`.

This class only rewrite `#close` method to remove entries in the
directory.

## Development

There is no special instructions about this library.

The [crystal-lang/crystal](https://github.com/crystal-lang/crystal/)'s
development rules and policies would be apply.

## Contributing

1. Fork it (<https://github.com/lugia-kun/tempdir.cr/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [Hajime Yoshimori](https://github.com/lugia-kun) - creator and maintainer
