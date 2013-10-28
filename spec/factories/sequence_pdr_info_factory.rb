# spec/factories/sequence_pdr_info.rb
FactoryGirl.define do
  
  factory :sequence_pdr_info do |sequence_pdr_info|
    before(:create) do |sequence_pdr_info|
      Sequence.delete(1000)
      SequenceUniqInfo.delete(1000)
      @sequence_uniq_info = FactoryGirl.create(:sequence_uniq_info, :id => 1000, :sequence_id=>1000, :taxonomy_id=>85)    
    end
    
    sequence_pdr_info.dataset_id    3
    sequence_pdr_info.sequence_id   1000
    sequence_pdr_info.seq_count     2
    sequence_pdr_info.created_at    Time.now
    sequence_pdr_info.updated_at    Time.now
    sequence_pdr_info.sequence_uniq_info @sequence_uniq_info
    
  end
end

