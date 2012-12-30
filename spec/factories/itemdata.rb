# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :itemdatum, :class => 'Itemdata' do
    word nil
    data ""
  end
end
