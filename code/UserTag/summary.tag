# Copyright 2002 Interchange Development Group (http://www.icdevgroup.org/)
# Licensed under the GNU GPL v2. See file LICENSE for details.
# $Id: summary.tag,v 1.3 2005-02-10 14:38:39 docelic Exp $

# [summary  amount=n.nn
#           name=label*
#           hide=1*
#           total=1*
#           reset=1*
#           format="%.2f"*
#           currency=1* ]
#
# Calculates column totals (if used properly. 8-\)
# 
#
UserTag summary Order     amount
UserTag summary PosNumber 1
UserTag summary addAttr
UserTag summary Version   $Revision: 1.3 $
UserTag summary Routine   <<EOF
sub {
    my ($amount, $opt) = @_;
	my $summary_hash = $::Instance->{tag_summary_hash} ||= {};
	my $name;
	unless ($name = $opt->{name} ) {
		$name = 'ONLY0000';
		%$summary_hash = () if Vend::Util::is_yes($opt->{reset});
	}
	else {
		$summary_hash->{$name} = 0 if Vend::Util::is_yes($opt->{reset});
	}
	$summary_hash->{$name} += $amount if length $amount;
	$amount = $summary_hash->{$name} if Vend::Util::is_yes($opt->{total});
	return '' if $opt->{hide};
	return sprintf($opt->{format}, $amount) if $opt->{format};
    return Vend::Util::currency($amount) if $opt->{currency};
    return $amount;
}
EOF