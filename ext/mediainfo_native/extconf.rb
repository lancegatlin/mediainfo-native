require 'mkmf'

if (mediainfo_cfg = pkg_config('libmediainfo'))

  unless have_library('mediainfo')
    abort 'Failed to test-link against libmediainfo.'
  end

  non_std_location = mediainfo_cfg.detect { |flag| flag =~ /^-L/ }
  if non_std_location
    non_std_location.gsub!('-L', '')
    $LDFLAGS << " -Wl,-rpath,#{non_std_location}"
    message "embedding path to library into libmediainfo.so: #{non_std_location}\n"
  end

  with_cppflags("#{(mediainfo_cfg.detect { |flag| flag =~ /^-I/ })}") do
    create_makefile('mediainfo_native')
  end
else
  unless have_library('mediainfo')
    abort 'Failed to test-link against libmediainfo.'
  end

  with_cppflags("-lmediainfo") do
    create_makefile('mediainfo_native')
  end
end

