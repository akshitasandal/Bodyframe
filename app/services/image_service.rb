class ImageService
  class << self
    def attach_image(image, task)
      if image
        begin
          _image_with_mime_type = image.match(/\Adata:([-\w]+\/[-\w\+\.]+)?;base64,(.*)/) || []
          extension = MIME::Types[_image_with_mime_type[1]]&.first&.preferred_extension || 'png'
          task.image.attach({ data: image, filename: 'task-image', content_type: "image/#{extension}" })
        rescue => exception
          task.errors.add(:image, 'Please provide valid base64 encoded image')
        end
      end
    end
  end
end
  