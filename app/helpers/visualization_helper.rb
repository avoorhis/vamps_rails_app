module VisualizationHelper

  def get_retmat(ds)
	retmat = {}
	total = 0
	@taxonomy_by_site.each do |item|
		taxonomy = item[:taxonomy]
		ds_hash  = item[:datasets]
		value = ds_hash[ds]
		retmat[taxonomy] = value
		if value > 0 then
			total = total + value
		end
	end
	return { :name=>ds, :retmat=>retmat, :total=>total }
  end

 

  def string_2_color(str)

  	#return str.to_hex()
  	#return str.unpack('U'*str.length).collect {|x| x.to_s 16}.join
  	hex = Zlib::crc32(str).to_s(16)
  	return sprintf("#%.6s", hex)
  	#return hex.rjust(6,'0')
		#$dork =  str_pad(dechex(crc32($data)), 8, '0', STR_PAD_LEFT) ;
		
		#$dork = substr($dork,2,6);
		
		#return $dork;
  end


end
