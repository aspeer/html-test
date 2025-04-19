#!/usr/bin/env perl
use strict;
use warnings;
use IO::Socket::INET;
use Socket qw(SOMAXCONN);

my $port = $ENV{PORT} || 8080;

my $server = IO::Socket::INET->new(
    LocalPort => $port,
    Listen    => SOMAXCONN,
    Reuse     => 1,
) or die "Cannot bind to port $port: $!";

while (my $client = $server->accept()) {
    my $request_line = <$client>;
    while (<$client>) {
        last if /^\s*$/;
    }
    my $time = localtime();

    my $body = <<"HTML";
<!DOCTYPE html>
<html>
<head><title>Current Time</title></head>
<body>
<p>Current time: $time</p>
</body>
</html>
HTML

    print $client "HTTP/1.1 200 OK\r\n";
    print $client "Content-Type: text/html; charset=UTF-8\r\n";
    print $client "Content-Length: " . length($body) . "\r\n";
    print $client "\r\n";
    print $client $body;

    close $client;
}