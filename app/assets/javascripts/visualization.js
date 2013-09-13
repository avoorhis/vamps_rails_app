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

//
// CHECK_FOR_SELECTED_DATASETS
//
function check_for_selected_datasets(form)
{
  
  cbs = document.getElementsByName(project+'--ds-ids[]')
  alert(cbs)
  have_acheck = false
  for(var i=0; i < cbs.length; i++) {
    if(cbs[i].checked){
      have_acheck = true
    }
              
  }
  if(have_acheck){
    alert('submitting')
    $(form).submit();
  }else{
    alert('Select some data!')
    return;
  }
  return;
}
//
// OPEN_DATASETS
//
function open_datasets(pid, project)
{
  
  //alert('in open')
  ds_div = document.getElementById(pid+'_ds_div');
  cbs = document.getElementsByName(project+'--ds-ids[]')
  toggle = document.getElementById(project+'_toggle')
  if(ds_div.style.display == 'inline'){
    // hide
    ds_div.style.display = 'none'
    toggle.style.visibility = 'hidden'
    // uncheck project
    document.getElementById(project+'--pj-id').checked = false
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
    document.getElementById(project+'--pj-id').checked = true
    // now set all the ds checkboxes to 'checked'
    for(var i=0; i < cbs.length; i++) {
      if(cbs[i].type == 'checkbox') {
        cbs[i].checked=true        
      }
    }
  }
  

}
//
//  CHECK_PROJECTS
//
function check_project(pid, project)
{
  cbs = document.getElementsByName(project+'--ds-ids[]')
  have_acheck = false
  for(var i=0; i < cbs.length; i++) {
    if(cbs[i].checked){
      have_acheck = true

    }
              
  }
  if(have_acheck){
    document.getElementById(project+'--pj-id').checked = true
  }else{
    document.getElementById(project+'--pj-id').checked = false
  }
}
//
// TOGGLE_SELECTED_DATASETS
//
function toggle_selected_datasets(pid, project)
{
  
  cbs = document.getElementsByName(project+'--ds-ids[]')
  ds_div = document.getElementById(pid+'_ds_div')
  

  
  if(cbs[0].checked == true) {  
    document.getElementById(project+'--pj-id').checked = false
    for(var i=0; i < cbs.length; i++) { 
        cbs[i].checked=false        
    }
  }else{
    document.getElementById(project+'--pj-id').checked = true
    for(var i=0; i < cbs.length; i++) { 
        cbs[i].checked=true        
    }

  }


}
