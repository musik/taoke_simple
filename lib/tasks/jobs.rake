namespace :jobs do
  task :process => :environment do
    TaobaoTop.new.process 'TR_SM'
  end
  task :reset => :environment do
    Shop.delete_all
    Item.delete_all
    Word.delete_all
  end
end
