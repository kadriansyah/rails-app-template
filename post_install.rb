require 'fileutils'

Dir['vendor/assets/components/**/', 'vendor/assets/components/**/.*'].each do |x|
    puts "processing #{x}"
    if  (x.include? 'demo') || (x.include? 'test') || (x.include? '.github') || (x.include? 'guides') ||
        (x.include? 'man') || (x.include? 'bin') || (x.include? 'templates') || (x.include? 'site')

        begin
            FileUtils.rm_r x
            puts "=== DELETING FOLDER #{x} ==="
        rescue
            puts "nothing todo for #{x} already deleted"
        end
    else
        files = Dir.glob(File.join(x, '*'), File::FNM_DOTMATCH)
        files.each do |file|
            if  (file.include? '.json') || (file.include? 'hero.svg') ||
                (file.include? '.md') || (file.include? '.yml') ||
                (file.include? 'index.html') || (file.include? 'LICENSE') ||
                (file.include? '.gitignore') || (file.include? 'COPYING') ||
                (file.include? 'Gruntfile.js') || (file.include? 'gulpfile.js') ||
                (file.include? 'Gulpfile.js') || (file.include? '.log') ||
                (file.include? '.editorconfig') || (file.include? '.gitattributes') ||
                (file.include? '.npmignore') || (file.include? '.sh') ||
                (file.include? 'Makefile')

                FileUtils.rm_r file
                puts "=== DELETING FILE #{file} ==="
            end
        end
    end
end