(function ($, app) {
    'use strict';
    $(document).ready(function () {
        $('select').select2();
        var $categoryName=$('#categoryName');
        var $dailyAllowance=$('#dailyAllowance');
        var $advanceAmount=$('#advanceAmount');
        var $submit=$('#submit');
        var $travelCategoryForm=$('#travelCategoryForm');

      
        $submit.on('click',function(){
            if($("#travelCategoryForm").valid()){
                travelCategory(this);
            }
        })
        var travelCategory=function(obj){
            var $this=$(obj);
            app.pullDataById(document.editTravelCategoryLink,{

                'categoryName':$categoryName.val(),
                'dailyAllowance':$dailyAllowance.val(),
                'advanceAmount':$advanceAmount.val(),}).then(function(response){
                app.showMessage("Travel Category Created Successfully.");
                window.location.href = '../../travelCategory';
            },function(error){
    
            });
        }
        var validate =  $travelCategoryForm.validate({
            rules: {
                categoryName: {
                    required: true
                },
                dailyAllowance:{
                    required: true
                },
                advanceAmount:{
                    required:true
                }
            },
            messages: {
              
            }
        });
    });
})(window.jQuery, window.app);

