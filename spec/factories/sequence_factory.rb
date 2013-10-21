# spec/factories/sequence.rb

FactoryGirl.define do
  factory :sequence do |sequence|    
    sequence.sequence_comp "compress('AGCCTTTGACATCCTAGGACGACTTCTGGAGACAGATTTCTTCCCTTCGGGGACCTAGTGAC')"
    sequence.created_at Time.now
    sequence.updated_at Time.now
  end
end
