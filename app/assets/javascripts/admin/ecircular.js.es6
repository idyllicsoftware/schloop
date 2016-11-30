class SchoolECircular extends SchloopBase {
    init (){
        var _self = this;
        _self.initEventListeners();
        _self._ecirculars = {};
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
                        divisions.push(selectedDivisions.name + `<input type="hidden" name="grades[${key}][divisions][]" value="${divKey}" />`);
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

        $(".select-recipients_name").html(arr.join(", ") || 'Select recipients');
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
            'title': 'name',
            'body': 'name',
        }, function (res) {
            if(res.success) {
                $('.selected_circular_tag').html('Select E-Circular');
                $('.selected_circular_tag').next().val(null);
                $(".select-recipients_name").html('Select recipients');
                toastr.success('E-Circular sent successfully');
                eCircularFormEl[0].reset();
            }else {
                _self.showErrors(res.errors);
            }
        });
    };

    get circularHistoryListTpl (){
        return $('#circular-history-list-tpl').html();
    }

    loadCircularHistory(){
        let _self = this, html = '',
            { school_id } = _self._config,
            circularHistoryListEl = $('.ecirculars-history-section ul');
        _self._ecirculars = {};
        $.ajax({
            url: `/admin/schools/${school_id}/ecirculars/all`,
            success: function (res) {
                if(res.success) {
                    _self._ecirculars = res.circulars.toHash();
                    html = Mustache.to_html(_self.circularHistoryListTpl, {
                        circulars: res.circulars,
                        format_created_on: function () {
                            return moment(this.created_on).format('MMM D YYYY, h:mm a');
                        },
                        formatted_recipients: function () {
                            var arr = [], divisions,
                                html = '';
                            this.recipients.forEach(function (recipient) {
                                html = recipient.grade_name;
                                divisions = recipient.divisions.map(x => x.div_name);
                                if(divisions.length){
                                    html += " (";
                                    html += divisions.join(', ');
                                    html += ")";
                                }
                                arr.push(html);
                            });
                            return arr.join(", ");
                        }
                    });
                }
                circularHistoryListEl.html(html);
            }
        });
    };

    initCircularHistory (){
        let _self = this,
        { school_id } = _self._config,
        html = "",
        detailTpl = $("#circular-history-detail-tpl").html(),
        circularHistoryModal = $('#circular-history-modal');

        $(document).on('click','.circular-history-item', function () {
            let {circular_id} = $(this).data();
            if(_self._ecirculars.hasOwnProperty(circular_id)) {
                circularHistoryModal.modal('show');
                html = Mustache.to_html(detailTpl, {
                    circular: _self._ecirculars[circular_id],
                    format_created_on: function () {
                        return moment(this.created_on).format('MMM D YYYY, h:mm a');
                    },
                    formatted_grades: function () {
                        var arr = [], divisions,
                            html = '';
                        this.recipients.forEach(function (recipient) {
                            html = recipient.grade_name;
                            divisions = recipient.divisions.map(x => x.div_name);
                            if(divisions.length){
                                html += " (";
                                html += divisions.join(', ');
                                html += ")";
                            }
                            arr.push({name: html});
                        });
                        return arr;
                    }
                });
                circularHistoryModal.find('.modal-body').html(html);
            }
        });

        $(document).on('click', '.history-circular-btn-wrap a', function () {
            let {type} = $(this).data();
            if(type == "history"){
                $("#circulars-tab").removeClass('new_circular_active').addClass('history_active');
                _self.loadCircularHistory();
            }else {
                $("#circulars-tab").removeClass('history_active').addClass('new_circular_active');
            }
        });
    };
}        