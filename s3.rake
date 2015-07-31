namespace :s3 do
  desc "S3 Files Manipulation"

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

  task rename_files: :environment do
    s3 = AWS::S3.new
    bucket = s3.buckets['freshapps-staging-pvt']
    files = bucket.objects.collect {|x| x.key if foo(x.key) }.compact!
    files.each do |obj|
      bucket.objects[obj].copy_to("app-code/" + obj.split("/").second + "/" + obj.split("/").second + ".html")
    end
    puts "Done"
  end

  def foo key
    file = key.split("/").second.reverse + ".html"
    key.split("/").last == file
  end
end
