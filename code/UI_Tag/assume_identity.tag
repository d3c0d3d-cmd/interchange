# Copyright 2002-2007 Interchange Development Group and others
# 
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.  See the LICENSE file for details.

UserTag assume-identity   Order        file locale
UserTag assume-identity   addAttr
UserTag assume-identity   PosNumber    2
UserTag assume-identity   Version      1.5
UserTag assume-identity   Routine      <<EOR
sub {
	my ($file, $locale, $opt) = @_;
	my $pn;
	if($opt and $opt->{name}) {
		$pn = $opt->{name};
	}
	else {
		$pn = $file;
		$pn =~ s/\.\w+$//;
		$pn =~ s:^pages/::;
	}
	$Global::Variable->{MV_PAGE} = $pn;
	$locale = 1 unless defined $locale;
	return Vend::Interpolate::interpolate_html(
		Vend::Util::readfile($file, undef, $locale)
	);
}
EOR
