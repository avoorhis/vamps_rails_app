// Create the tooltips only when document ready
 jQuery(document).ready(function()
 {
     // http://qtip2.com/demos
     // MAKE SURE YOUR SELECTOR MATCHES SOMETHING IN YOUR HTML!!!
     jQuery('.project-select').each(function() {
         jQuery(this).qtip({
             content: {
                 text: jQuery(this).next('div')
             },
		
         });
     });
 });
