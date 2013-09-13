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
    rank_id = Rank.find_by_rank(@tax_rank)
  
    # rank_ids = "superkingdom_id, phylum_id, class_id, orderx_id, family_id, genus_id, species_id, strain_id"
    rank_ids = "t1.taxon, t2.taxon, t3.taxon, t4.taxon, t5.taxon, t6.taxon, t7.taxon, t8.taxon"
    taxa_ids = "LEFT JOIN taxa AS t1 ON (superkingdom_id = t1.id)
    LEFT JOIN taxa AS t2 ON (phylum_id  = t2.id)
    LEFT JOIN taxa AS t3 ON (class_id   = t3.id)
    LEFT JOIN taxa AS t4 ON (orderx_id  = t4.id)
    LEFT JOIN taxa AS t5 ON (family_id  = t5.id)
    LEFT JOIN taxa AS t6 ON (genus_id   = t6.id)
    LEFT JOIN taxa AS t7 ON (species_id = t7.id)
    LEFT JOIN taxa AS t8 ON (strain_id  = t8.id)
    "
    return rank_ids, taxa_ids
  end    
  
  
  
  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_in) { |u| u.permit(:username, :password, :remember_me) }
    devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:username, :email, :institution, :first_name, :last_name, :active, :security_level, :password, :password_confirmation) }
  end
  

end
