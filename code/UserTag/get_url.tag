# Copyright 2002-2020 Interchange Development Group and others
# 
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.  See the LICENSE file for details.

UserTag get-url Order        url
UserTag get-url AddAttr
UserTag get-url Interpolate
UserTag get-url Version      1.13
UserTag get-url Routine      <<EOR
require LWP::UserAgent;
sub {
	my ($url, $opt) = @_;
	my $html = '';
	my $method;
	
	my $ua = LWP::UserAgent->new;

	if($opt->{method}) { 
		$method = uc($opt->{method});
	} else {
		$method = 'GET';
	}

    if($opt->{timeout}) {
		my $to = Vend::Config::time_to_seconds($opt->{timeout});
		$ua->timeout($to);
	}

	if($opt->{useragent} ) {
			$ua->agent($opt->{useragent});
	}

	if($opt->{form}) {
		$opt->{content} = Vend::Interpolate::escape_form($opt->{form});
	}

	my $do_content;

	if ($opt->{content}) {
		if ($method eq 'POST' || $method eq 'PUT') {
			$opt->{content_type} ||= 'application/x-www-form-urlencoded';
			$do_content = 1;
		} 
		else {
			$url .= $opt->{url} =~ /\?/ ? '&' : '?';
			$url .= $opt->{content};
		}
	}

	my $req = HTTP::Request->new($method, $url);

	if (local $_ = $opt->{headers}) {
		for my $h (grep { /\S/ } split /[\r\n]+/) {
			my ($k, $v) = split (/:/, $h, 2);
			s/^\s+|\s+$//g for ($k, $v);
			$req->header($k => $v);
		}
	}

	if($do_content) {
		$req->content_type($opt->{content_type});
		$req->content($opt->{content});
	}

	if($opt->{authuser} && $opt->{authpass}) {
		$req->authorization_basic($opt->{authuser}, $opt->{authpass});
	}


	my $res = $ua->request($req);

	if ($res->is_success) {
		$html .= $res->content;
	} else {
		$html .= "Failed - " . $res->status_line;
	}

	if($opt->{strip}) {
		$html =~ s/.*<body[^>]*>//si;
		$html =~ s:</body>.*::si;
	}

	if ($opt->{scratch}) {
		$::Scratch->{$opt->{scratch}} = $html;
		return;
	}

	return $html;
}
EOR
