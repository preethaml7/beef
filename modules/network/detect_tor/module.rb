#
# Copyright (c) 2006-2025 Wade Alcorn - wade@bindshell.net
# Browser Exploitation Framework (BeEF) - https://beefproject.com
# See the file 'doc/COPYING' for copying permission
#
class Detect_tor < BeEF::Core::Command
  def self.options
    [
      { 'name' => 'tor_resource', 'ui_label' => 'What Tor resource to request', 'value' => 'http://xycpusearchon2mc.onion/deeplogo.jpg' },
      { 'name' => 'timeout', 'ui_label' => 'Detection timeout', 'value' => '10000' }
    ]
  end

  def post_execute
    return if @datastore['result'].nil?

    save({ 'result' => @datastore['result'] })
  end
end
