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

	all = json_project_tree.getAllCheckedBranches()
  	//alert(form["nas"].value)
  	//alert(all)

  	var hiddenField1 = document.createElement("input"); 
	hiddenField1.setAttribute("type", 'hidden');
	hiddenField1.setAttribute("name", "datasets");
	hiddenField1.setAttribute("value", all);	
	form.appendChild(hiddenField1);

  	$(form).submit();
}