# Copyright 2002 Interchange Development Group (http://www.icdevgroup.org/)
# Licensed under the GNU GPL v2. See file LICENSE for details.
# $Id: email_raw.tag,v 1.5 2005-02-10 14:38:39 docelic Exp $

UserTag email-raw hasEndTag
UserTag email-raw addAttr
UserTag email-raw Interpolate
UserTag email-raw Version     $Revision: 1.5 $
UserTag email-raw Routine     <<EOR
sub {
    my($opt, $body) = @_;
    my($ok);
    $body =~ s/^\s+//;

    SEND: {
        open(Vend::MAIL,"|$Vend::Cfg->{SendMailProgram} -t") or last SEND;
        print Vend::MAIL $body 
            or last SEND;
        close Vend::MAIL
            or last SEND;
        $ok = ($? == 0);
    }

    if (!$ok) {
        ::logError("Unable to send mail using $Vend::Cfg->{SendMailProgram}\n" .
            "Message follows:\n\n$body");
    }

    return $opt->{hide} ? '' : $ok;
}
EOR