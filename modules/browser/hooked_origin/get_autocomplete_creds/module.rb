#
# Copyright (c) 2006-2025 Wade Alcorn - wade@bindshell.net
# Browser Exploitation Framework (BeEF) - https://beefproject.com
# See the file 'doc/COPYING' for copying permission
#
class Get_autocomplete_creds < BeEF::Core::Command
  def self.options
    []
  end

  def post_execute
    content = {}
    content['results'] = @datastore['results']
    save content
  end
end
