requires "Simple::Accessor" => "1.02";
requires "Test::Harness" => 0;
requires "Net::Telnet" => 0;
requires "Dancer2"  => "0";
requires "Template" => 0;
requires "JSON::XS" => 0;
requires "Plack"  => 0;
requires "Time::HiRes" => 0;
requires "Fcntl" => 0;

recommends "YAML"             => "0";
recommends "URL::Encode::XS"  => "0";
recommends "CGI::Deurl::XS"   => "0";
recommends "HTTP::Parser::XS" => "0";

on "test" => sub {
    requires "Test::More"            => "0";
    requires "HTTP::Request::Common" => "0";
};
