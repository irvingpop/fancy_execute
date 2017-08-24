# WARNING: THIS COOKBOOK IS DEPRECATED AND SHOULD NO LONGER BE USED

`fancy_execute` has not been needed in Chef since version 12.6.0 [this commit](https://github.com/chef/chef/commit/c03d49c7cc3b5eb351abc9f6537a1a65692e93fc)

The correct way to get live streaming of execute output in Chef is to use the `Chef::Config` setting `:always_stream_output` (bool)
