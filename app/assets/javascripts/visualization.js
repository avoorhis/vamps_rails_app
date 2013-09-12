// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

//= require jquery/jquery.min
//= require jquery/jquery.dynatree.min
//= require jquery/jquery-ui.custom.min
//= require jquery/jquery.cookie
//= require ./mootools/mootools-beta-1.2b2
//= require ./mootools/moocanvas

function toggleAll(name)
{
  boxes = document.getElementsByClassName(name);
  for (i = 0; i < boxes.length; i++)
    if (!boxes[i].disabled)
   		{	boxes[i].checked = !boxes[i].checked ; }
}

// function getDatasets(form)
// {

// 	checked_datasets = json_project_tree.getAllCheckedBranches()
  	
//   	if(checked_datasets==''){
//   		alert("Select some datasets.")
//   		return
//   	}

//   var hiddenField1 = document.createElement("input"); 
// 	hiddenField1.setAttribute("type", 'hidden');
// 	hiddenField1.setAttribute("name", "datasets");
// 	hiddenField1.setAttribute("value", checked_datasets);	
// 	form.appendChild(hiddenField1);

//   	$(form).submit();
// }
function open_datasets(pid)
{
  
  ds_div = document.getElementById(pid);
  if(ds_div.style.display == 'inline'){
    ds_div.style.display = 'none'

  }else{
    ds_div.style.display = 'inline'

  }
  
  

}
var initialiseShowHideTrigger = function(h) {
  var show_trigger = $("show_" + h.id); // assume the show trigger has the same id
                                        // as the target with "show_" prepended

  var hide_trigger = $("hide_" + h.id); // similarly for hide trigger

  show_trigger.onclick = function() { // add onclick handler to
    h.show();                         // show the target element,
    show_trigger.hide();              // hide the show trigger,
    hide_trigger.show();              // and show the hide trigger
  }

  hide_trigger.onclick = function() { // add onclick handler to
    h.hide();                         // hide the target element,
    show_trigger.show();              // show the show trigger,
    hide_trigger.hide();              // and hide the hide trigger
  }

  hide_trigger.onclick();             // trigger the hide trigger so initially
                                      // the target is hidden
}