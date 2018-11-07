# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

# Add additional assets to the asset load path.
# Rails.application.config.assets.paths << Emoji.images_path
# Add Yarn node_modules folder to the asset load path.
Rails.application.config.assets.paths << Rails.root.join('node_modules')
Rails.application.config.assets.paths << Rails.root.join('vendor')

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in the app/assets
# folder are already added.
Rails.application.config.assets.precompile += %w( tinymce/tinymce.min
                                                  tinymce/skins/lightgray/skin.min
                                                  bootstrap/dist/css/bootstrap.min.css
                                                  font-awesome/css/font-awesome.min.css
                                                  nprogress/nprogress.css
                                                  iCheck/skins/flat/green.css
                                                  bootstrap-progressbar/css/bootstrap-progressbar-3.3.4.min.css
                                                  jqvmap/dist/jqvmap.min.css
                                                  bootstrap-daterangepicker/daterangepicker.css
                                                  custom.css
                                                  jquery/dist/jquery.min.js
                                                  bootstrap/dist/js/bootstrap.min.js
                                                  fastclick/lib/fastclick.js
                                                  nprogress/nprogress.js
                                                  Chart.js/dist/Chart.min.js
                                                  gauge.js/dist/gauge.min.js
                                                  bootstrap-progressbar/bootstrap-progressbar.min
                                                  iCheck/icheck.min.js
                                                  skycons/skycons.js
                                                  Flot/jquery.flot.js
                                                  Flot/jquery.flot.pie.js
                                                  Flot/jquery.flot.time.js
                                                  Flot/jquery.flot.stack.js
                                                  Flot/jquery.flot.resize.js
                                                  flot.orderbars/js/jquery.flot.orderBars.js
                                                  flot-spline/js/jquery.flot.spline.min.js
                                                  flot.curvedlines/curvedLines.js
                                                  DateJS/build/date.js
                                                  jqvmap/dist/jquery.vmap.js
                                                  jqvmap/dist/maps/jquery.vmap.world.js
                                                  jqvmap/examples/js/jquery.vmap.sampledata.js
                                                  moment/min/moment.min.js
                                                  bootstrap-daterangepicker/daterangepicker.js
                                                  animate.css/animate.min.css
                                                  custom.js  )
