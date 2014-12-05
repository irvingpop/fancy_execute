#
# Author:: Irving Popovetsky (<irving@chef.io)
# Copyright:: Copyright (c) 2014 Chef Software, Inc.
# License:: Apache License, Version 2.0
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

require 'chef/log'
require 'chef/provider'

# Monkeypatch Chef::Mixin:Shellout to respect live_stream, rather than always overriding
class Chef
  module Mixin
    module ShellOut

      def shell_out(*command_args)
        cmd = Mixlib::ShellOut.new(*run_command_compatible_options(command_args))
        cmd.live_stream ||= io_for_live_stream
        cmd.run_command
        cmd
      end

    end
  end
end

class Chef
  class Provider
    class FancyExecute < Chef::Provider::Execute

      if Gem::Version.new(Chef::VERSION) >= Gem::Version.new('12.0.0')
        provides :execute
      end

      def action_run
        opts = {}

        if sentinel_file = sentinel_file_if_exists
          Chef::Log.debug("#{@new_resource} sentinel file #{sentinel_file} exists - nothing to do")
          return false
        end

        # original implementation did not specify a timeout, but ShellOut
        # *always* times out. So, set a very long default timeout
        opts[:timeout] = @new_resource.timeout || 3600
        opts[:returns] = @new_resource.returns if @new_resource.returns
        opts[:environment] = @new_resource.environment if @new_resource.environment
        opts[:user] = @new_resource.user if @new_resource.user
        opts[:group] = @new_resource.group if @new_resource.group
        opts[:cwd] = @new_resource.cwd if @new_resource.cwd
        opts[:umask] = @new_resource.umask if @new_resource.umask
        opts[:log_level] = :info
        opts[:log_tag] = @new_resource.to_s
        if STDOUT.tty? && @new_resource.live_stream == true
          opts[:live_stream] = STDOUT
        elsif STDOUT.tty? && !Chef::Config[:daemon] && Chef::Log.debug? && !@new_resource.sensitive
          # the old behavior
          opts[:live_stream] = STDOUT
        end
        description = @new_resource.sensitive ? "sensitive resource" : @new_resource.command
        converge_by("execute #{description}") do
          result = shell_out!(@new_resource.command, opts)
          Chef::Log.info("#{@new_resource} ran successfully")
        end
      end

    end
  end
end

# Set FancyExecute as the default provider for :execute on Linux platforms
if Gem::Version.new(Chef::VERSION) < Gem::Version.new('12.0.0')
  %w(debian ubuntu fedora redhat centos).each do |platform|
    Chef::Platform.set plaform: platform.to_sym, resource: :execute, provider: Chef::Provider::FancyExecute
  end
end
