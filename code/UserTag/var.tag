# Copyright 2002 Interchange Development Group (http://www.icdevgroup.org/)
# Licensed under the GNU GPL v2. See file LICENSE for details.
# $Id: var.tag,v 1.10 2005-02-10 14:38:39 docelic Exp $

UserTag var Order         name global filter
UserTag var Interpolate   1
UserTag var Version       $Revision: 1.10 $
UserTag var Routine       <<EOR
sub {
	my ($key, $global, $filter) = @_;
	my $value;
	if ($global and $global != 2) {
		$value = $Global::Variable->{$key};
	}
	elsif ($Vend::Session->{logged_in} and defined $Vend::Cfg->{Member}{$key}) {
		$value = $Vend::Cfg->{Member}{$key};
	}
	else {
		$value = (
			$::Pragma->{dynamic_variables}
			? Vend::Interpolate::dynamic_var($key)
			: $::Variable->{$key}
		);
		$value ||= $Global::Variable->{$key} if $global;
	}
	$value = filter_value($filter, $value, $key) if $filter;
	return $value;
}
EOR