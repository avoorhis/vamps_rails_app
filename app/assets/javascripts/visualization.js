// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.


function toggleAll(name)
{
  boxes = document.getElementsByClassName(name);
  for (i = 0; i < boxes.length; i++)
    if (!boxes[i].disabled)
   		{	boxes[i].checked = !boxes[i].checked ; }
}

function getDatasets(form)
{

	checked_datasets = json_project_tree.getAllCheckedBranches()
  	
  	if(checked_datasets==''){
  		alert("Select some datasets.")
  		return
  	}

  	var hiddenField1 = document.createElement("input"); 
	hiddenField1.setAttribute("type", 'hidden');
	hiddenField1.setAttribute("name", "datasets");
	hiddenField1.setAttribute("value", checked_datasets);	
	form.appendChild(hiddenField1);

  	$(form).submit();
}