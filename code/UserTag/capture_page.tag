UserTag capture_page Order page file
UserTag capture_page addAttr
UserTag capture_page Routine <<EOR
sub {
	my ($page, $file, $opt) = @_;

	# check if we are allowed to write the file
	unless (Vend::File::allowed_file($file, 1)) {
		Vend::File::log_file_violation($file, 'capture_page');
		return 0;
	}

	if ($opt->{scan}) {
		Vend::Page::do_scan($opt->{scan});
	}

	$::Scratch->{mv_no_count} = 1;

	if ($opt->{expiry}) {
		my $stat = (stat($file))[9];

		if ($stat > $opt->{expiry}) {
			if ($opt->{touch}) {
				my $now = time();
				unless (utime ($now, $now, $file)) {
					::logError ("Error on touching file $file: $!\n");
				}
			}
			return;
		}
	}

	my $pageref = Vend::Page::display_page($page,{return => 1});
	Vend::Interpolate::substitute_image($pageref);

	my $retval = Vend::File::writefile (">$file", $pageref, 
        {auto_create_dir => $opt->{auto_create_dir},
		umask => $opt->{umask}});
	return $opt->{hide} ? '' : $retval;
}
EOR
