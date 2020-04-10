json.data do
  json.proposal_item do
    json.id @proposal_item.id
    json.title @proposal_item.title
    json.description @proposal_item.description
  end
end