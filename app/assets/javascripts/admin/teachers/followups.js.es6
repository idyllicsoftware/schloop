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

        $(document).on('click', '.read-more', function (e) {
            var bm_id = $(this).data('bookmark_id');
            e.preventDefault();
            this.expand = !this.expand;
            $(this).text(this.expand ? "Collapse" : "More...");
            $(this).closest('.content-block').find('.sm-area, .bg-area').toggleClass('sm-area bg-area');
            // if($(this).text() === 'Collapse') {
            //     var view_El = $(this).closest('.schloopmark-item').find('.view_count');
            //     _self.viewSchloopmark(bm_id, view_El);
            // }
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
                    var html = Mustache.to_html(_self.followupsBookmarksTpl, {
                        data: res.data,
                        is_text: function() {
                            return this.type === "text";
                        },
                        like_count: function() {
                            var like_El = [], count = 0, str = '';

                            if (this.likes && this.likes.length) {
                                this.likes.forEach( function (item) {
                                    count++;
                                    if (count <=2 ) {
                                        like_El.push(item.first_name);
                                    }
                                });
                                if (count == 1) {
                                    str = like_El[0] + " liked";
                                } else if (count == 2){
                                    str = like_El.join(',') + " liked";
                                } else {
                                    str = like_El.join(',') + " & " + count + " others liked";
                                }
                                return str;
                            } else {
                                str = "0 liked";
                                return str;
                            }   
                        },
                        profile_picture: function() {
                            var fname = this.teacher.first_name.charAt(0),
                                lname = this.teacher.last_name.charAt(0),
                                name = fname + lname;
                            return name.toUpperCase();
                        },
                        comment_profile: function() {
                            var fname = this.commenter.first_name.charAt(0),
                                lname = this.commenter.last_name.charAt(0), 
                                name = (fname + lname).toUpperCase();
                            return {profile_name: name};                            
                        },
                    });
                    _self.followup_bookmarks = res.data.toHash('id');
                    followups_schloopmark.html(html);
                    $("time.timeago").timeago();

                    $(document).find('.content-block .sm-area .data').each( function() {
                        var thisEl = $(this),
                            len = $(this).text().length;
                            if(len < 200){
                                $(this).closest('.content-block').find('.read-more').addClass('hidden');
                            }
                    });

                } else {
                    _self.showErrors(res.errors);
                }
            }    
        });             
    };
}    