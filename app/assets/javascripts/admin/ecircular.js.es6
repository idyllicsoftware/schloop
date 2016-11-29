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
                for(var divKey in selectedHash[key]){
                    if(selectedObj.divisions.hasOwnProperty(divKey)) {
                        selectedDivisions = selectedObj.divisions[divKey];
                        divisions.push(selectedDivisions.name + `<input type="hidden" name="divisions[]" value="${divKey}" />`);
                    }
                };
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
            selectedHash = {};
            var checkedEl = popupEl.find('.division_checkbox:checked');
            checkedEl.each(function (index, item) {
                let checkEl = $(this),
                    { grade_id } =  checkEl.data();
                if(!selectedHash.hasOwnProperty(grade_id)) {
                    selectedHash[grade_id] = {};
                }
                selectedHash[grade_id][$(this).val()] = true;
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

            for(var cls in selectedHash){
                var divs = selectedHash[cls];
                popupEl.find('.division_checkbox').each(function (indx, item) {
                    if(divs.hasOwnProperty($(item).val())){
                        var gradeEl = $(item).closest('.std_name').find('.grade_checkbox');
                        gradeEl[0].checked = true;
                        item.checked = true;
                    }
                });
            }
            processCheckbox(popupEl);

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
        });
    };
			
    initEventListeners (){
        let _self = this,
        { school_id } = _self._config,
        eCircularFormEl = $(".school-ecircular-form");

        _self.initCircularTagPopover();
        _self.initRecipientsSelectPopover();
        _self.initCircularHistory();

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

    initCircularHistory (){
        let _self = this,
        { school_id } = _self._config,
        circularHistoryModal = $('#circular-history-modal');

        $(document).on('click','.circular-history-item', function () {
            circularHistoryModal.modal('show');
        });

        
    }
}        