// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// RAILS_ENV=production bundle exec rake assets:precompile
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require bootstrap
//= require_tree .




$(document).ready(function() {
	function scrollToAnchor(aid){
		var aTag = $("a[name='"+ aid +"']");
		$('html,body').animate({scrollTop: aTag.offset().top},'slow');
	}
	$("a").click(function() {
		var href = $(this).attr('href').replace('#', '')
		scrollToAnchor(href);
	});
	
	// Calling LayerSlider on the target element
	$('#layerslider').layerSlider({
		pauseOnHover: false,
		imgPreload: true
		
	    // Slider options goes here,
	    // please check the 'List of slider options' section in the documentation
	});
		
});
