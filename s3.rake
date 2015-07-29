namespace :s3 do
  desc "Rename the glyph and sprite files in s3 without their digests"

  task copy_files: :environment do
    s3 = AWS::S3.new
    src = s3.buckets['freshapps-assets.freshpo.com']
    dest = s3.buckets['freshapps-staging-pvt']
    src.objects.each do |obj|
      new_key =  "app-code/" + obj.key.split("/").first.reverse + "/" + obj.key.split("/").last
      dest.objects["#{new_key}"].copy_from(src.objects[obj.key])
    end
    puts "Done"
  end
end
