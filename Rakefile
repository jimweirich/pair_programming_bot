$:.unshift("/Library/RubyMotion/lib")
require 'motion/project'

PROVISIONING_FILE = FileList['provisioning/*.mobileprovision'].first

Motion::Project::App.setup do |app|
  # Use `rake config' to see complete project settings.
  app.name = 'Pairing Bot'
  app.provisioning_profile = PROVISIONING_FILE
  app.icons << "Icon.png" << "Icon@2x.png"
end
