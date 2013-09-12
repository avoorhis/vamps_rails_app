// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.


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
function open_datasets(pid, project)
{
  
  //alert('in open')
  ds_div = document.getElementById(pid);
  cbs = document.getElementsByName(project+'_ds_ids[]')
  toggle = document.getElementById(project+'_toggle')
  if(ds_div.style.display == 'inline'){
    // hide
    ds_div.style.display = 'none'
    toggle.style.visibility = 'hidden'
    // uncheck project
    document.getElementById(project).checked = false
    for(var i=0; i < cbs.length; i++) {
      if(cbs[i].type == 'checkbox') {
        cbs[i].checked=false        
      }
    }
  }else{
    // show open dataset div
    ds_div.style.display = 'inline'
    toggle.style.visibility = 'visible'
    // check project
    document.getElementById(project).checked = true
    // now set all the ds checkboxes to 'checked'
    for(var i=0; i < cbs.length; i++) {
      if(cbs[i].type == 'checkbox') {
        cbs[i].checked=true        
      }
    }
  }
  

}

function toggle_selected_datasets(project)
{
  
  cbs = document.getElementsByName(project+'_ds_ids[]')
  ds_div = document.getElementById(pid);
  for(var i=0; i < cbs.length; i++) {
      if(ds_div.style.display == 'inline'){
        cbs[i].checked=true        
      }else{
        cbs[i].checked=false
      }
    }

 

}
