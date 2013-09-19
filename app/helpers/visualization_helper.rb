module VisualizationHelper

  def get_retmat(pj,ds)
	retmat = {}
	total = 0
	@taxonomy_by_site_hash.each do |taxonomy, pj_hash|
	  pj_hash.each do |project, ds_hash|
	    if pj == project	
		  ds_hash.each do |dataset, value|
		    if ds == dataset
		      if value > 0 then
		  	    retmat[taxonomy] = value		      
			    total += value
			  end
			end
		  end
		end
	  end
	end
	return { :dname=>ds, :retmat=>retmat, :total=>total }
  end

 

  def string_2_color(str)

  	hex = Zlib::crc32(str).to_s(16)
  	return sprintf("#%.6s", hex)
  	
  end


end
