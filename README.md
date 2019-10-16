# mach_info

Provides a wrapper api for the mach info calls available on darwin

## Installation

1. Add the dependency to your `shard.yml`:

   ```yaml
   dependencies:
     libc_mach:
       github: washu/mach_info
   ```

2. Run `shards install`

## Usage

```crystal
require "mach_info"


m = MachInfo.basic_host_info
total_cpus = m.max_cpus
```

This library adds the following Mach Info functions bindings

* host_self
* host_priv_self
* host_page_size
* host_info
* host_statistics
* host_statistics64
* kernel_version
* processor_set_default
* host_processor_info
* processor_set_info


The Core Module adds several static lookup methods to fetch the different flavors of
host_info, host_processor_info, and processor_set_info functions.


## Development

Install crystal, get cracking.

## Contributing

1. Fork it (<https://github.com/washu/mach_info/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [Sal Scotto](https://github.com/your-github-user) - creator and maintainer
