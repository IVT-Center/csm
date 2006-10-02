require 'mkmf'

GSL_CONFIG = "gsl-config"

# Taken from rb-gsl
def gsl_config()
  print("checking gsl cflags... ")
  IO.popen("#{GSL_CONFIG} --cflags") do |f|
    cflags = f.gets.chomp
    puts(cflags)
    $CFLAGS += " " + cflags
  end
   
  IO.popen("#{GSL_CONFIG} --libs") do |f|
    libs = f.gets.chomp
    dir_config("cblas")
    dir_config("atlas")
    if have_library("cblas") and have_library("atlas")
      libs.gsub!("-lgslcblas", "-lcblas -latlas")
      $LOCAL_LIBS += " " + libs.gsub(" -lgslcblas", "")
      print("checking gsl libs... ")
      puts(libs)
    else
      print("checking gsl libs... ")
      puts(libs)
      $LOCAL_LIBS += " " + libs
    end
  end

end

if (not have_library('gpc')) or (not find_header('gpc.h'))
	puts "Error: not having library 'gpc'"
	exit
else
	$LOCAL_LIBS += '-lgpc'
end

$CPPFLAGS += " -Wno-long-double -Wall -W -Wmissing-prototypes -Wconversion "
$CPPFLAGS += " -Wunreachable-code "
gsl_config();
srcs = %w(
	icp_ruby icpc_wrap 
	icp icp_loop icp_correspondences_dumb icp_correspondences_tricks
	journal laser_data math_utils )


$objs = srcs.collect{|i| i+".o"}

create_makefile('icpc')
if false
File.open("Makefile","a") do |f|
	f.puts <<-EOF
# Copy other sources from other directory
%.o: ../%.o
	cp $< $@
	
EOF

end end