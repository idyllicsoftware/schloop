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

        $(document).on('click', '.read_more', function (e) {
            var bm_id = $(this).data('bookmark_id');
            e.preventDefault();
            this.expand = !this.expand;
            $(this).text(this.expand ? "Collapse" : "More...");
            $(this).closest('.content-block').find('.sm-area, .bg-area').toggleClass('sm-area bg-area');
            if($(this).text() === 'Collapse') {
                var view_El = $(this).closest('.schloopmark-item').find('.view_count');
                _self.viewSchloopmark(bm_id, view_El);
            }
        });
        
        $(document).on('click', '.write-comment-tag', function() {
            $(this).closest('.schloopmark-item').find('.write-comment').focus();
        });

        $(document).on('click', '.content-block a img', function() {
            var bm_id = $(this).data('bm_id'),
                view_El = $(this).closest('.schloopmark-item').find('.view_count');
            _self.viewSchloopmark(bm_id, view_El);
        });

    	_self.likeSchloopmark();
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
                	var html = Mustache.to_html(_self.collaborationsBookmarksTpl, {
                        data: res.data,
                        is_text: function() {
                            return this.type === "text";
                        },
                    });
                        _self.bookmarks = res.data.toHash('id');
                        collaborationsContainer.html(html);
                        $("time.timeago").timeago(); 

                        $(document).find('.like-schloopmark > img').each( function() {
                            if($(this).hasClass('like')) {
                                $(this).parent().find('p').css('color','#25aae1');
                            }
                        });

                        collaborationsContainer.find('.add-Tomytopic').on('click', function () {
                            var curr_bm_id = $(this).data('bookmark_id'),
                                thisEl = $(this);

                                if (_self.bookmarks.hasOwnProperty(curr_bm_id)) {
                                        _self.addToMytopic(curr_bm_id, thisEl);
                                }
                        });

                        collaborationsContainer.on('click', '.follow-up-parent', function () {
                            var curr_bm_id = $(this).data('bookmark_id'),
                                thisEl = $(this);
                                if (_self.bookmarks.hasOwnProperty(curr_bm_id)) {
                                    var curr_Bm_id = _self.bookmarks[curr_bm_id].id;
                                    swal({
                                            title: "Are you sure?",
                                            text: "You want followup for parent",
                                            type: "info",
                                            showCancelButton: true,
                                            confirmButtonText: "Yes!",
                                            closeOnConfirm: false
                                        },
                                        function(isConfirm){
                                            if (isConfirm) {
                                                $.ajax({
                                                    url: "/admin/teachers/followups?bookmark_id=" + curr_Bm_id,
                                                    method: "POST",
                                                    success: function (res) {
                                                       if(res.success) {
                                                        swal.close();
                                                        thisEl.find('p').html('shared as followup');
                                                        thisEl.find('img').replaceWith('<img src="/assets/admin/follow_up_fill.svg" >');
                                                         toastr.success('Schloopmarked shared as followup successfully', '', {
                                                                    positionClass: 'toast-top-right cloud-display'
                                                                });      
                                                       } else {
                                                            _self.showErrors(res.errors);
                                                       }
                                                    }
                                                });
                                            }
                                    });
                                }    
                        });

                        $(document).find('.content-block .sm-area .data').each( function() {
                            var thisEl = $(this),
                                len = $(this).text().length;
                                if(len < 200){
                                    $(this).closest('.content-block').find('.read_more').addClass('hidden');
                                }
                        });

                        _self.addComment(); 
                } else {
                    _self.showErrors(res.errors);
                }
            }
        });
    };

    likeSchloopmark() {
    	let _self = this;
    
    	$(document).on('click', '.like-schloopmark', function () {
    		var like,
                thisEl = $(this),
                bm_id = $(this).data('bookmark_id'),
                img_El = $(this).find('img'),
                img1_src_path = img_El.data('img1'), img2_src_path = img_El.data('img2');
                
    		if(img_El.hasClass('like')){
    			like = false;
    			img_El.removeClass('like');
    			img_El.addClass('unlike');
    			$(this).find('p').html('Like').css('color','#666666');
    			img_El.attr('src', img2_src_path);
    		} else {
    			like = true;
    			img_El.removeClass('unlike');
    			img_El.addClass('like');
    			$(this).find('p').html('Liked').css('color','#25aae1');
                img_El.attr('src', img1_src_path);   
    		}

    		var like_data = {
                'bookmark_id' : bm_id,
    			'event' : 'like',
                'like_state' : like
    		}

    		$.ajax({
	            url: '/admin/teachers/bookmarks/bookmark_like_or_view',
	            data: like_data,
	            method: 'POST',
	            success: function (res) {
	                if(res.success) {
                        var like_count = res.bookmark.likes;
                        thisEl.closest('.schloopmark-item').find('.schloopmark-like .like_count').text(like_count);
	                } else {
	                    _self.showErrors(res.errors);
	                }
	            }
	        });
    	});
    };

    addToMytopic(bookmark_id, thisEl) {
    	let _self = this,
            img1_path = thisEl.find('img').data('img1'),
            img2_path = thisEl.find('img').data('img2');

            $.ajax({
                url: "/admin/teachers/collaborations/add_to_my_topics?bookmark_id=" + bookmark_id,
                method: "POST",
                success: function (res) {
                   if(res.success) {
                    thisEl.find('p').html('Added to my topics');
                    thisEl.find('img').attr('src','img2_path');
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
        
    	$('.write-comment').off('keydown').on('keydown', function (e) {
    		var curr_bm_id = $(this).data('bookmark_id'),
    			curr_El = $(this);
    	    //e.preventDefault();
           // e.stopPropagation()
    		if (!e) {
		        e = window.event;
		    }
		    var keyCode = e.which || e.keyCode;
		    if (keyCode === 13 && !e.shiftKey && !_self.locked) {
                var comment_data = $(this).html().replace(new RegExp('<div><br></div>', 'g'), '').replace(new RegExp(' &nbsp;', 'g'), '').replace(new RegExp('&nbsp;', 'g'), '');
                $(this).html("");
                if(comment_data){
                     _self.locked = true;
                    var cmm_data = {
    	    			'id' : curr_bm_id,
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
                            _self.locked = false;
    		            }
    		        });
                }
		    }
    	});
    };

    viewSchloopmark(bookmark_id, view_El) {
        let _self = this,
            views_data = {
                'bookmark_id' : bookmark_id,
                'event' : 'view'
            };
    
        $.ajax({
            url: '/admin/teachers/bookmarks/bookmark_like_or_view',
            data : views_data,
            method: 'POST',
            success: function (res) {
                if(res.success) {
                var view_count = res.bookmark.views;
                view_El.text(view_count);
                } else {
                    _self.showErrors(res.errors);
                }
            }
        });
    };
}