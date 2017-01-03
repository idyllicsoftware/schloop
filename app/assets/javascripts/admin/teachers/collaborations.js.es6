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

        $(document).on('click', '.more', function (e) {
            e.preventDefault();
            this.expand = !this.expand;
            $(this).text(this.expand ? "Collapse" : "More...");
            $(this).closest('.content-block').find('.sm-area, .bg-area').toggleClass('sm-area bg-area');
        });

    	_self.likeSchloopmark();
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
                        
                        collaborationsContainer.find('.add-Tomytopic').on('click', function () {
                            var curr_coll_id = $(this).data('collaboration_id');

                                if(!$(this).hasClass('mytopic')){
                                    $(this).addClass('mytopic');
                                    $(this).find('p').html('Added to my topics');
                                    $(this).find('img').replaceWith('<img src="/assets/admin/add_item_fill.svg" >');
                                    
                                    if (_self.collaborations.hasOwnProperty(curr_coll_id)) {
                                        var hash = _self.collaborations[curr_coll_id],
                                            datum = {
                                                'datum' : hash.bookmark_data.data
                                            },
                                            bookmarks_hash = $.extend(hash.bookmark_data, datum);
                                            _self.addToMytopic(bookmarks_hash);
                                    }
                                } else {
                                    swal({title: "Oops!", text: "This Schoolmark already added to mytopic.", type: "error", confirmButtonText: "OK" });
                                }
                        });

                        $(document).find('.content-block .sm-area .data').each( function() {
                            var thisEl = $(this),
                                len = $(this).text().length;
                                if(len < 200){
                                    $(this).closest('.content-block').find('.more').addClass('hidden');
                                }
                        });

                } else {
                    _self.showErrors(res.errors);
                }
            }
        });
    };

    likeSchloopmark() {
    	let _self = this;
    
    	$(document).on('click', '.like-schloopmark', function () {
    		var curr_coll_id = $(this).data('collaboration_id'),like,
                bm_id = $(this).data('bookmark_id'),
                teacher_id = $(this).data('teacher_id');

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
                'bookmark_id' : bm_id,
    			'event' : 'like',
                'like_state' : like
    		}

    		$.ajax({
	            url: '/admin/teachers/' + teacher_id +'/bookmark_like_or_view',
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

    addToMytopic(bookmarks_hash) {
    	let _self = this;

            $.ajax({
                url: "/admin/teachers/bookmarks",
                data: bookmarks_hash,
                method: "POST",
                success: function (res) {
                   if(res.success) {
                     toastr.success('Schloopmarked added to mytopic successfully', '', {
                                positionClass: 'toast-top-right cloud-display'
                            });      
                   } else {
                        _self.showErrors(res.errors);
                   }
                }
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