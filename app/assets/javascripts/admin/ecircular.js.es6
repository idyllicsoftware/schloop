class SchoolECircular extends SchloopBase {
    init (){
        var _self = this;
        _self.initEventListeners();
        return this;
    };

    initCircularTagPopover (){
        $("#select-circular-popover").on('shown.bs.popover', function () {
            var popupEl = $('#' + $(this).attr('aria-describedby'));
            popupEl.find("input[name=radio_select]").change(function(){
                if( $(this).is(":checked") ){
                    let val = $(this).val(),
                        html = $(this).next().text();

                    $('.selected_circular_tag').html(html);
                    $('.selected_circular_tag').next().val(val)
                }
            });
        });
    };

    updateRecipientsHtml (allData, selectedHash){
        var html = "", arr = [], divisions,
            selectedObj,
            selectedDivisions;

        for(var key in selectedHash){
            if(allData.hasOwnProperty(key)){
                selectedObj = allData[key];
                html = selectedObj.name;
                divisions = [];
                selectedHash[key].forEach(function (item) {
                    if(selectedObj.divisions.hasOwnProperty(item)) {
                        selectedDivisions = selectedObj.divisions[item];
                        divisions.push(selectedDivisions.name + `<input type="hidden" name="divisions[]" value="${item}" />`);
                    }
                });
                if(divisions.length){
                    html += "(";
                    html += divisions.join(', ');
                    html += ")";
                }
                arr.push(html);
            }
        }

        $(".select-recipients_name").html(arr.join(", "));
    };

    initRecipientsSelectPopover (){
        let _self = this,
        toggleAllDivisions = function (checkEl, checked) {
            let divisionCheckboxes = checkEl.closest('.std_name').find('ul.checkbox_customized .division_checkbox');
            divisionCheckboxes.each(function (index, item) {
                item.checked = checked;
            });
        },
        allData = {},
        selectedHash = {},
        processCheckbox = function(popupEl){
            var checkedEl = popupEl.find('.division_checkbox:checked');
            checkedEl.each(function (index, item) {
                let checkEl = $(this),
                    { grade_id } =  checkEl.data();
                if(!selectedHash.hasOwnProperty(grade_id)) {
                    selectedHash[grade_id] = [];
                }
                selectedHash[grade_id].push($(this).val());
            });

            _self.updateRecipientsHtml(allData, selectedHash);
        };

        $("#all-grade-section-tab .std_name").each(function(index, item){
            var el = $(this),
                gradeEl = el.find('.grade_checkbox'),
                divisionEl = el.find('.division_checkbox');

            gradeEl.each(function (idx, itm) {
                var el = $(itm);
                allData[el.val()] = {
                    name: el.next().text(),
                    id: el.val(),
                    divisions: {}
                }
            });

            divisionEl.each(function (idx, itm) {
                let el = $(itm),
                    { grade_id } =  el.data();
                if(allData.hasOwnProperty(grade_id)){
                    allData[grade_id].divisions[el.val()] = {
                        name: el.next().text(),
                        id: el.val()
                    };
                }
            });

        });

        $("#select-recipients-popover").on('shown.bs.popover', function () {
            var popupEl = $('#' + $(this).attr('aria-describedby'));

            debugger;
            popupEl.find('.grade_checkbox').change(function () {
                toggleAllDivisions($(this), $(this).is(":checked"));
                processCheckbox(popupEl);
            });

            popupEl.find('.division_checkbox').change(function () {
                var checkEl = $(this),
                    checkedEl = checkEl.closest('.checkbox_customized').find('.division_checkbox:checked'),
                    gradeEl = checkEl.closest('.std_name').find('.grade_checkbox');

                gradeEl[0].checked = !!checkedEl.length;
                processCheckbox(popupEl);
            });

            /*
            popupEl.find("input[type=checkbox]").change(function(){
                var selected_grade_id,selected_grade,selected_division, hash = {},
                    selected_division_id,vall = $(this).data('grade_id'),
                    tag_El = $('.school-ecircular-form').find('.select-recipients_name');

                if(popupEl.find("input[name='grade["+ vall +"]division[]']:checked") && $(this).parents().eq(2).find('.chek_cls').is(':not(:checked)')){
                    if($("input[name='grade[]']:checked") && vall == undefined){
                        return true;
                    }else{
                        $(this).parents().eq(2).find('.chek_cls').prop('checked', true);
                    }
                }
                popupEl.find("input[name='grade[]']:checked").each(function(i){
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

            */
        });
    };
			
    initEventListeners (){
        let _self = this,
        { school_id } = _self._config,
        eCircularFormEl = $(".school-ecircular-form");

        _self.initCircularTagPopover();
        _self.initRecipientsSelectPopover();

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