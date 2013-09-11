
#json.array!(
# {id:0,
#	item:[
#		{id:"0;KCK_NADP_Bv6",text:"KCK_NADP_Bv6"},
#		{id:"0;BPC_CTRL_Bv5v4",text:"BPC_CTRL_Bv5v4"},
#		{id:"0;BPC_DTAG_Bv6Bv3",text:"BPC_DTAG_Bv6Bv3"},
#		{id:"0;HMP_DAWG_Bv3v1",text:"HMP_DAWG_Bv3v1"},
#		{id:"0;AGT_CKN_Bv6",text:"AGT_CKN_Bv6"},
#		{id:"0;DCO_RAM_Bv6v4",text:"DCO_RAM_Bv6v4"},
#		{id:"0;AB_HGB_Ev9",text:"AB_HGB_Ev9"}
#		]
#  }
#)


json_id = params[:id]

if json_id == '0'
	json.array!(:id=>0)
	json.item @projects do |p|
	    json.id "0;"+p.project
	    
	    #json.text p.project+ " <a href='/projects/#{p.id}'>?</a>"
	    json.text "<a href='/projects/#{p.id}'>#{p.project}</a>"
	    json.child "1"
	  
	end
else
	@datasets = get_datasets
	json.array!(:id=>json_id)
  	json.item @datasets do |d|
  		json.id json_id+';'+d.dataset
	    json.text d.dataset
	    json.child "0"
    	
  	end
end



def get_datasets
    id_parts = params[:id].split(';')   # eg "0;AB_SAND_Bv6"
    project_id = Project.find_by_project(id_parts[1]).id
    @datasets = Dataset.where("project_id='#{project_id}'")
end

