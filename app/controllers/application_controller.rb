class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_filter :configure_permitted_parameters, if: :devise_controller?
  before_filter :do_common_stuff
  
  def do_common_stuff
    @ranks   = Rank.all.sorted
    @domains = Rank.find_by(rank: "superkingdom").taxa.order(:taxon)
  end
  
  def make_taxa_by_rank()
    # rank_id = Rank.find_by_rank(@tax_rank)
  
    rank_names        = %w[superkingdom  phylum  klass   order  family   genus  species strain ]
    taxon_table_names = %w[superkingdoms phylums klasses orders families genera species strains]
    rank_ids = ""
    taxa_joins = ""
    for n in 0..@rank_number 
      rank_ids += ' t'+(n+1).to_s+".#{rank_names[n]},"
      taxa_joins += "LEFT JOIN #{taxon_table_names[n]} AS t"+(n+1).to_s+" ON (#{rank_names[n]}_id = t"+(n+1).to_s+".id)\n"
    end
    
    return rank_ids[0..-2], taxa_joins


    
  end    
  
  
  
  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_in) { |u| u.permit(:username, :password, :remember_me) }
    devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:username, :email, :institution, :first_name, :last_name, :active, :security_level, :password, :password_confirmation) }
  end
  

end
