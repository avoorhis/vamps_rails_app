module VisualizationHelper

  def get_retmat(ds)
	retmat = {}
	total = 0
	@taxonomy_by_site_hash.each do |item|
		taxonomy = item[:taxonomy]
		ds_hash  = item[:datasets]
		value = ds_hash[ds]
		retmat[taxonomy] = value
		if value > 0 then
			total += value
		end
	end
	return { :name=>ds, :retmat=>retmat, :total=>total }
  end

 

  def string_2_color(str)

  	hex = Zlib::crc32(str).to_s(16)
  	return sprintf("#%.6s", hex)
  	
  end


end
