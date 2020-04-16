json.data do
  json.proposal_image do
    json.id @proposal_image.id
    json.image url_for(@proposal_image.image)
    json.proposal_item_id @proposal_image.proposal_item_id
  end
end