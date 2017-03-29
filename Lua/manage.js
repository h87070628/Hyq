var playerClass = require("playerMgr")
window.g_Manage = {
	player:null,
	get_player = function(args){
		if(this.player == null){
			this.player = new playerClass();
			this.player.init(args);
		}
		return this.player;
	},

	del_player = function(){
		if(this.player){
			this.player.free();
			this.player = null;
		}
	},
};

g_Manage.get_player({x:1,y:1});
g_Manage.del_player();
