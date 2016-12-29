// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

//= require_self

class Collaborations extends SchloopBase {
    init (){
    	let {action} = this._config,
        	_self = this,
            params = {teacher_id: this._config.teacher_id};
        _self.popoverInit(true);
        _self.initEventListeners();
        return this;
    };

    initEventListeners () {
    	let _self = this;

    	$('#schloopmarking-Tab a[data-tab-name="collaboration"]').on('shown.bs.tab', function (e) {
    		_self.loadCollaboratedSchloopmark();	
    	});	
    };

    get collaborationsBookmarksTpl (){
        return $("#collaborations_bookmarks_tpl").html();
    };

    loadCollaboratedSchloopmark () {
    	let _self = this,
    		collaborationsContainer = $('.collaborated-schloopmark');

    	$.ajax({
            url: `/admin/teachers/collaborations`,
            method: 'GET',
            success: function (res) {
                if(res.success) {
                	var html = Mustache.to_html(_self.collaborationsBookmarksTpl, res);
                        _self.collaborations = res.data.toHash('collaboration_id');
                        collaborationsContainer.html(html);
                        $("time.timeago").timeago();
                } else {
                    _self.showErrors(res.errors);
                }
            }
        });
    };
}