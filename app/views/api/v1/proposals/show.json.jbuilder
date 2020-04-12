json.data do
  json.proposal do
    json.id @proposal.id
    json.customer_id @proposal.customer_id
    json.artist_id @proposal.artist_id
    json.status @proposal.status
    json.proposal_items @proposal.proposal_items do |proposal_item|
      json.id proposal_item.id
      json.title proposal_item.title
      json.description proposal_item.description
      json.service_id proposal_item.service_id
    end
  end
end