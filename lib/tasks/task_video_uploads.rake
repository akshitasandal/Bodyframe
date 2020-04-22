desc "Update Task Uplaod Status"
  task :video_upload_status => :environment do
    vimeo_client =  VimeoMe2::VimeoObject.new('20d9bf9cd677f0a54127fe9d397e4680')
    Meal.where(video_thumbnail: (nil || ""), upload_status: false).where.not(video_url: nil).each do|meal|
      video = vimeo_client.get("/me/videos/#{meal.video_url}")
      if video["transcode"].present? && video["transcode"]["status"] == "complete"
        thumbnail = video["pictures"]["sizes"][3]["link"]
        meal.update(video_thumbnail: thumbnail, upload_status: true)
      end
    end
    Workout.where(video_thumbnail:  (nil || ""), upload_status: false).where.not(video_url: nil).each do|workout|
      video = vimeo_client.get("/me/videos/#{workout.video_url}")
      if video["transcode"].present? && video["transcode"]["status"] == "complete"
        thumbnail = video["pictures"]["sizes"][3]["link"]
        workout.update(video_thumbnail: thumbnail, upload_status: true)
      end
    end
  end