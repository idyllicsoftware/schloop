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
    	_self.likeSchloopmark();
    	_self.addToMytopic();
    	_self.addComment();	
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

    likeSchloopmark() {
    	let _self = this;

    	$(document).on('click', '.like-schloopmark', function () {
    		var curr_coll_id = $(this).data('collaboration_id'),
				like;

    		if($(this).hasClass('like')){
    			like = false;
    			$(this).removeClass('like');
    			$(this).addClass('unlike');
    			$(this).find('p').html('Like');
    			$(this).find('img').replaceWith('<img src="/assets/admin/unlike.svg" >');
    		} else {
    			like = true;
    			$(this).find('img').replaceWith('<img src="/assets/admin/like.svg" >');
    			$(this).removeClass('unlike');
    			$(this).addClass('like');
    			$(this).find('p').html('Liked');
    		}

    		var like_data = {
    			'collaboration_id' : curr_coll_id,
    			'like' : like
    		}

    		$.ajax({
	            url: `/admin/teachers/collaborations`,
	            data: like_data,
	            method: 'POST',
	            success: function (res) {
	                if(res.success) {
	                	//TO DO.... 
	                } else {
	                    _self.showErrors(res.errors);
	                }
	            }
	        });
    	});
    };

    addToMytopic() {
    	let _self = this;

    	$(document).on('click', '.add-Tomytopic', function () {
    		var curr_coll_id = $(this).data('collaboration_id'),
				like;
    		//TO DO...
    	});
    };

    addComment () {
    	let _self = this;

    	$(document).on('keyup','.write-comment', function (e) {
    		var curr_coll_id = $(this).data('collaboration_id'),
    			curr_El = $(this);
    	
    		if (!e) {
		        e = window.event;
		    }
		    var keyCode = e.which || e.keyCode;
		    if (keyCode === 13 && !e.shiftKey) {
		        if (e.preventDefault) {
		            e.preventDefault();
		        } else {
		            e.returnValue = false;
		        }
		        var comment_data = $(this).html().replace(new RegExp('<div><br></div>', 'g'), '').replace(new RegExp(' &nbsp;', 'g'), '').replace(new RegExp('&nbsp;', 'g'), '');
		        var cmm_data = {
	    			'id' : curr_coll_id,
	    			'comment_type' : 'Collaboration',
	    			'message' : comment_data
	    		};

	    		$.ajax({
		            url: `/admin/teachers/comments`,
		            data: cmm_data,
		            method: 'POST',
		            success: function (res) {
		                if(res.success) {
		                	_self.loadCollaboratedSchloopmark();
		                } else {
		                    _self.showErrors(res.errors);
		                }
		            }
		        });
		    }
    	});
    };
}