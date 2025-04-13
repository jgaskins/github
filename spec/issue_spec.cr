require "./spec_helper"

require "../src/issue"

describe GitHub::Issue do
  describe GitHub::Issue::AuthorAssociation do
    it "deserializes multiple values from JSON" do
      assoc = GitHub::Issue::AuthorAssociation.from_json("Owner,Collaborator".to_json)

      assoc.owner?.should eq true
      assoc.collaborator?.should eq true
      assoc.organization_member?.should eq false
    end

    it "serializes multiple values to JSON" do
      assoc = GitHub::Issue::AuthorAssociation[Owner, Collaborator]

      assoc.to_json.should eq "Owner,Collaborator".to_json
    end
  end
end
