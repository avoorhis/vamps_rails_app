
xml.instruct! :xml, :encoding =>"iso-8859-1"

xml_id = params[:id]

if xml_id == '0'
  xml.tree(:id=>0) do
    @projects.each do |p|
      xml.item(:id=>"0;"+p.project, :text=>p.project, :child=>"1") do
        #xml.tag!("itemtext") {xml.cdata! '<font color="red">'+p.project+'</font>'}
       # xml.itemtext do
       #  xml.cdata! '<font color="red">'+p.project+'</font>'
       # end
      #xml.item do
        #xml.item, :id=>p.project
        
        #xml.itemtext p.project

        #xml.title project.title
        #xml.project_description project.project_description
        #project.datasets.each do |dataset|
        #	xml.dataset do
        	#  xml.dataset dataset.dataset
         #   xml.dataset_description dataset.dataset_description
        #	 end
        #end
      end
    end
  end
else
  @datasets = get_datasets
  xml.tree(:id=>xml_id) do
    @datasets.each do |d|
      xml.item(:id=>xml_id+';'+d.dataset, :text=>d.dataset, :child=>"0") do        
      end
    end
  end
end

def get_datasets
    id_parts = params[:id].split(';')   # eg "0;AB_SAND_Bv6"
    project_id = Project.find_by_project(id_parts[1]).project_id
    @datasets = Dataset.where("project_id='#{project_id}'")
end