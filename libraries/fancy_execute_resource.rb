#
# Author:: Adam Jacob (<adam@opscode.com>)
# Author:: Tyler Cloke (<tyler@opscode.com>)
# Copyright:: Copyright (c) 2008 Opscode, Inc.
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

require 'chef/resource'

class Chef
  class Resource
    class Execute < Chef::Resource

      def initialize(name, run_context=nil)
        super
        @resource_name = :execute
        @command = name
        @backup = 5
        @action = "run"
        @creates = nil
        @cwd = nil
        @environment = nil
        @group = nil
        @path = nil
        @returns = 0
        @timeout = nil
        @user = nil
        @allowed_actions.push(:run)
        @umask = nil
        @live_stream = nil
      end

      def live_stream(arg=nil)
        set_or_return(
          :live_stream,
          arg,
          :kind_of => [ TrueClass, FalseClass ]
        )
      end

    end
  end
end
