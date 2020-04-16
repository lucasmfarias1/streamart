json.data do
  json.gig do
    json.id @gig.id
    json.status @gig.status
    json.gig_items @gig.gig_items do |gig_item|
      json.id gig_item.id
      json.title gig_item.title
      json.description gig_item.description
      json.price gig_item.price
      json.title_service gig_item.title_service
      json.description_service gig_item.description_service
    end
  end
end