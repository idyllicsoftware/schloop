// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

//= require_self

class SchoolECircular extends SchloopBase {
    init (){
        var _self = this;
        _self.initEventListeners();
        return this;
    };
			
    initEventListeners (){
        let _self = this,
        { school_id } = _self._config,
        eCircularFormEl = $(".school-ecircular-form"),
        data = new FormData(eCircularFormEl[0]);

        $("#select-circular-popover").on('shown.bs.popover', function () {
        	$("input[name=radio_select]").change(function(){ 
			        if( $(this).is(":checked") ){ 
			            var val = $(this).val(),
			            	name = $(this).next().text(),
			            	tag_El = $(this).parents().eq(4).find('.selected_circular_tag');
			        	
			        	tag_El.replaceWith('<p class="selected_circular_tag">'+ name +'</p>');
			        	$('.selected_circular_tag').next().val(val)     
			        }
			    });
        });

        $("#select-recipients-popover").on('shown.bs.popover', function () {
        	$("input[type=checkbox]").change(function(){
        	        var selected_grade_id,selected_grade,selected_division, hash = {},
        	        	selected_division_id,vall = $(this).data('grade_id'),
        	        	tag_El = $('.school-ecircular-form').find('.select-recipients_name');  
		        
                if($("input[name='grade["+ vall +"]division[]']:checked") && $(this).parents().eq(2).find('.chek_cls').is(':not(:checked)')){
                    if($("input[name='grade[]']:checked") && vall == undefined){ 
                        return true;
                    }else{  
                        $(this).parents().eq(2).find('.chek_cls').prop('checked', true);
                    }        
                }
                $("input[name='grade[]']:checked").each(function(i){
                    selected_grade = $(this).parent().find('label').html();
                    selected_grade_id = $(this).val();
                    hash[selected_grade_id] = selected_grade ;
                //    tag_El.parent().append('<input type="hidden" name="grade[]" value="' + selected_grade_id +'">');
                });  
                for( var grade in hash){
                    $("input[name='grade["+ grade +"]division[]']:checked").each(function(i){ 
                            selected_division = $(this).parent().find('label').html();
                            selected_division_id = $(this).val();
                            hash[grade] = {
                                grade_name : hash[grade], 
                                divisions : {}
                            };
                            hash[grade].divisions[selected_division_id] = selected_division;
                    });
                }
                function printData(data) {
                    var str = '';
                    for (var key in data) {
                        if (typeof data[key] == 'object') {
                        str += printData(data[key]) + ' ';
                        }else {
                            str += data[key] + ' ';
                        }    
                    }
                    return str;
                };
                var ul_list = [];
                for(var grade in hash){
                    var li = '<li><input type="hidden" name="grade[]" value="' + grade +'"></li>';
                    ul_list.push(li); 
                    for(var division in hash[grade].divisions){
                     ul_list.push('<li><input type="hidden" name="grade['+ grade +']division[]" value="' + hash[grade].divisions[division] +'"></li>');
                    }
                }  
                tag_El.parent().find('.input_el').replaceWith('<ul class="input_el hidden">'+ ul_list.join('<br/>') +'</ul>');
                console.log(hash);
                tag_El.replaceWith('<p class="select-recipients_name">'+ printData(hash) +'</p>');
		    });    
        });
        

        this.initFormSubmit(eCircularFormEl, {
            'title': 'title',
            'attachments[]': 'attachments[]',
        }, function (res) {
            if(res.success) {
               // TO DO..
            }else {
                self.showErrors(res.errors);
            }
        },{
            contentType: false,
            enctype: 'multipart/form-data',
            processData: false
        });
    }
}        