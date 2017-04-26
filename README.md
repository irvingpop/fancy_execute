# WARNING: THIS COOKBOOK IS DEPRECATED AND SHOULD NO LONGER BE USED

`fancy_execute` has not been needed in Chef since version 12.6.0 [this commit](https://github.com/chef/chef/commit/c03d49c7cc3b5eb351abc9f6537a1a65692e93fc)

The correct way to get live streaming of execute output in Chef is to use the `Chef::Config` setting `:always_stream_output` (bool)

# fancy_execute

This cookbook overrides the default execute provider, giving you live streaming output of `STDOUT` in chef `execute` statements, even in CI situations.

# usage

Simply include this cookbook in your dependencies and live_streaming will automatically be overridden

in Berksfile:
```ruby
cookbook 'fancy_execute', git: "https://github.com/irvingpop/fancy_execute.git"
```

in metadata.rb
```ruby
depends 'fancy_execute'
```

# How it works
this cookbook uses [Ruby monkey patching](http://stackoverflow.com/questions/394144/what-does-monkey-patching-exactly-mean-in-ruby) to override Chef's `execute` provider.

It checks for the existance of a new configuration option: `Chef::Config[:live_stream]`, which is set by default in this cookbook

# Version compatibility
The current version (1.0.0) is compatible with Chef 12.4.0+ as far as I know. The previous version (0.1.0) was compatible with Chef 11 and Chef 12.0.x
