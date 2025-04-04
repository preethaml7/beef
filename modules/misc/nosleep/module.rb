#
# Copyright (c) 2006-2025 Wade Alcorn - wade@bindshell.net
# Browser Exploitation Framework (BeEF) - https://beefproject.com
# See the file 'doc/COPYING' for copying permission
#
class No_sleep < BeEF::Core::Command
  def pre_send
    BeEF::Core::NetworkStack::Handlers::AssetHandler.instance.bind('/modules/misc/nosleep/NoSleep.min.js', '/NoSleep', 'js')
  end

  def self.options
    []
  end

  def post_execute
    content = {}
    content['result'] = @datastore['result']
    BeEF::Core::NetworkStack::Handlers::AssetHandler.instance.unbind('NoSleep.js')
    save content
  end
end
