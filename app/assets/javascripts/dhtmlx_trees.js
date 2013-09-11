
var items=''
function get_json_project_tree()
{
       
  json_project_tree = new dhtmlXTreeObject("json_sample_treebox", "100%", "100%", 0);
  json_project_tree.setImagePath("assets/dhtmlx/csh_dhx_skyblue/"); 
  json_project_tree.setSkin('dhx_skyblue');
  json_project_tree.enableThreeStateCheckboxes(true) //false to disable
  json_project_tree.enableTreeLines(true); // true by default
  json_project_tree.enableTreeImages(false); // true to enable 
  json_project_tree.enableCheckBoxes(true, false);
  json_project_tree.setOnCheckHandler("onCheck");
  // see: views/projects/index.json.jbuilder
  json_project_tree.setXMLAutoLoading("/projects.json");
  //json_tree.setXMLAutoLoadingBehaviour(mode);
  json_project_tree.setDataMode("json");
  //load first level of tree;
  json_project_tree.loadJSON("/projects.json?id=0");
             
          
} //end of function get_sample_tree

function onCheck(id,state)
{
  // this doesn't work because when you open a project
  // all the datasets are checked but this is not called 
  // for each
  //alert(json_project_tree.getOpenState(id))
  
  if( json_project_tree.getOpenState(id) == true ){

    if(json_project_tree.isItemChecked(id) == true){

      json_project_tree.setCheck(id,true)
      json_project_tree.setSubChecked(id,true)

    }else{

      json_project_tree.setCheck(id,false)
      json_project_tree.setSubChecked(id,false)

    }  
    

  }else if(json_project_tree.getOpenState(id) == -1){
    
    json_project_tree.openItem(id)
    json_project_tree.setCheck(id,true)
    json_project_tree.setSubChecked(id,true)

  }else{  // closed

    json_project_tree.openItem(id)
    if(json_project_tree.isItemChecked(id) == true){

      json_project_tree.setCheck(id,true)
      json_project_tree.setSubChecked(id,true)

    }else{

      json_project_tree.setCheck(id,false)
      json_project_tree.setSubChecked(id,false)

    }  
   

  }
  all = json_project_tree.getAllCheckedBranches()
  

}
function get_xml_project_tree()
{
       
  xml_project_tree = new dhtmlXTreeObject("xml_sample_treebox", "100%", "100%", 0);
  xml_project_tree.setImagePath("assets/dhtmlx/csh_dhx_skyblue/");
  xml_project_tree.setSkin('dhx_skyblue');
  xml_project_tree.enableThreeStateCheckboxes(true) //false to disable
  xml_project_tree.enableTreeLines(true); // true by default
  xml_project_tree.enableTreeImages(false); // true to enable 
  xml_project_tree.enableCheckBoxes(true, false);  
  xml_project_tree.setXMLAutoLoading("/projects.xml");
  xml_project_tree.setDataMode("xml");
  //load first level of tree;
  xml_project_tree.loadXML("/projects.xml?id=0");      
             
} //end of function get_sample_tree

function get_xml_taxonomy_tree()
{
       
  xml_tax_tree = new dhtmlXTreeObject("xml_tax_treebox", "100%", "100%", 0);
  xml_tax_tree.setImagePath("assets/dhtmlx/csh_dhx_skyblue/");
  xml_tax_tree.setSkin('dhx_skyblue');
  xml_tax_tree.enableThreeStateCheckboxes(true) //false to disable
  xml_tax_tree.enableTreeLines(true); // true by default
  xml_tax_tree.enableTreeImages(false); // true to enable 
  xml_tax_tree.enableCheckBoxes(true, false);  
  xml_tax_tree.setXMLAutoLoading("/projects.xml");
  xml_tax_tree.setDataMode("xml");
  //load first level of tree;
  xml_tax_tree.loadXML("/projects.xml?id=0");      
             
} //end of function g


