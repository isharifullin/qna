class AttachmentSerializer < ActiveModel::Serializer
  attributes :name, :url

  def name
    object.file.identifier
  end

  def url
    object.file.url
  end
end
