// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

//= require_self

class Followups extends SchloopBase {
    init (){
    	let {action} = this._config,
        	_self = this;

       	_self.initEventListeners();
        return this;
    };

    initEventListeners () {
    	let _self = this;

    	$('#schloopmarking-Tab a[data-tab-name="followups"]').on('shown.bs.tab', function (e) {
    		_self.loadFollowupsSchloopmark();	
    	});
    };

    get followupsBookmarksTpl (){
        return $("#followups_bookmarks_tpl").html();
    };

    loadFollowupsSchloopmark () {
    	let _self = this,
            followups_schloopmark = $('.followups-schloopmark');
        //TO DO...
        $.ajax({
            url: `/admin/teachers/followups`,
            method: 'GET',
            success: function (res) {
                if(res.success) {
                    var html = Mustache.to_html(_self.followupsBookmarksTpl, res);
                } else {
                    _self.showErrors(res.errors);
                }
            }    
        });             
    };
}    