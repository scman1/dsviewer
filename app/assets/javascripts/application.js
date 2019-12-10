// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require rails-ujs
//= require activestorage
//= require turbolinks
//= require jquery3
//= require popper
//= require bootstrap
//= require bootstrap-sprockets
//= require_tree .
//= require jquery-ui/widgets/tooltip


$( function() {
    enableTooltips();
} );

function enableTooltips(obj){
    if (obj==undefined){
        obj= $(document);
    }

    obj.tooltip({
        track: true,
        position: {
            my: "center bottom-20",
            at: "center top",

            using: function( position, feedback ) {
                $( this ).css( position );
                $( "<div>" )
                    .addClass( "arrow" )
                    .addClass( feedback.vertical )
                    .addClass( feedback.horizontal )
                    .appendTo( this );
            }
        },
        content: function() {
            return $(this).attr('title');
        },
        open: function (event, ui) {
            setTimeout(function () {
                $(ui.tooltip).hide();
            }, 3000);
        },
        /*show: {
            effect: "blind",
            delay: 150
        }*/
    });

}

