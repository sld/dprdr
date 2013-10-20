// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require jquery_ujs
//= require jquery-fileupload/basic
//= require jquery.balloon.min


(function($)
{
    /**
     * Ability for placeholder
     * usage: <input placeholder="any text">
     */
    $(function()
    {
        // if modernizr is available replace by var placeholder_support = Modernizr.input.placeholder;
        var placeholder_support = !!('placeholder' in document.createElement( 'input' ));
        if (!placeholder_support)
        {
            var inputs = $('input[placeholder]'),
                len = inputs.length,
                input,
                placeholder_class = 'placeholder';
            while (len--)
            {
                inputs[len].value = inputs[len].value ? inputs[len].value : inputs.eq(len).addClass(placeholder_class).attr('placeholder');
                inputs.eq(len).focus(function()
                {
                    var th = $(this);
                    if (this.value == th.attr('placeholder'))
                    {
                        th.removeClass(placeholder_class);
                        this.value = '';
                    }
                }).blur(function()
                    {
                        var th = $(this);
                        if (this.value == '')
                        {
                            th.addClass(placeholder_class);
                            this.value = th.attr('placeholder');
                        }
                    });
                (function(input)
                {
                    $(input.form).bind('submit', function()
                    {
                        if (input.value == $(input).attr('placeholder')) input.value = '';
                    });
                }(inputs[len]));
            }
        }
    });
}(jQuery));