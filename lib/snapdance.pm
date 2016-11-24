package snapdance;
use Dancer2;

our $VERSION = '0.1';

my $SNAPCAST = SnapcastQueries->new( config => config()->{'snapcast'} );

get '/' => sub {

# refresh the client on each homepage (do not cache if another browser is also updating it)

    my $clients = $SNAPCAST->get_clients();

    my $cfg = config()->{'snapcast'};
    die "no snapcast configuration set" unless $cfg;
    use Data::Dumper;

    #print Dumper config()->{'snapcast'};
    my $cfgrooms = $cfg->{rooms} or die;

    my @rooms;
    my $id = 1;
    foreach my $cli (@$clients) {
        my $mac = $cli->{mac};

        # ignore the client
        next if grep { $_ eq $mac } @{ $cfg->{ignore} // [] };
        push @rooms,
          {
            id    => 'room' . $id++,
            name  => $cfgrooms->{$mac}->{name} // "Client from $mac",
            mac   => $mac,
            color => $cfgrooms->{$mac}->{color} // "#C00",
            value => $cli->{volume},
          };
    }
    @rooms = sort { lc( $a->{name} ) cmp lc( $b->{name} ) } @rooms;
    template 'index', { rooms => \@rooms };
};

get '/api/setsound/:room/:volume' => sub {
    header 'Content-Type' => 'application/json';

    my $room   = param('room');
    my $volume = param('volume');

    my $error;
    $error = "Invalid volume" if $volume !~ qr{^[0-9]+$} or $volume > 100;

    my $reply;
    if ( !$error ) {
        $reply = $SNAPCAST->set_volume( $room, $volume );
        $error = "Volume queries failed" unless $reply->{'result'} = $volume;
    }

    return to_json { status => 0, msg => $error } if $error;
    return to_json { status => 1, msg => "OK: $room - :$volume:",
        debug => $reply };
};

#.... move this to a library
{

    package SnapcastQueries;

    use JSON::XS;
    use Net::Telnet;
    use Data::Dumper;

    use Simple::Accessor qw{config hostname port};

    sub _build_hostname {
        my $cfg = $_[0]->config();
        my $h = eval { $cfg->{server}{host} }
          or die "No server host defined in configuration";

        return $h;
    }

    sub _build_port {
        my $cfg = $_[0]->config();
        return $cfg->{server}{port} // 1705;
    }

    sub do_request {
        my ( $self, $query ) = @_;

        my $snapserver = $self->hostname();
        my $port       = $self->port();

        $self->{_request_id} ||= 1;
        my $json = JSON::XS->new->utf8->encode(
            { %$query, id => $self->{_request_id} } );

        $self->{_request_id} = ( $self->{_request_id} + 1 ) % 65_536;

        my $t = Net::Telnet->new( Timeout => 10, Prompt => "/\n/" );
        $t->open( Host => $snapserver, Port => $port ) or die;
        my ($reply) = $t->cmd( $json . "\r\n" );
        $t->close;

        my $results = JSON::XS->new->utf8->decode($reply);

        die "Cannot connect to snapserver" unless ref $results;

        return $results;
    }

    sub get_clients {
        my $self = shift;

        my $results = $self->do_request(
            { 'jsonrpc' => '2.0', 'method' => 'Server.GetStatus' } );
        die "No clients connected to server"
          unless ref $results->{result}{clients}
          && scalar @{ $results->{result}{clients} };

        my @clients;
        foreach my $set ( @{ $results->{result}{clients} } ) {
            push @clients,
              {
                mac    => $set->{'host'}{'mac'},
                volume => $set->{'config'}{'volume'}{'percent'}
              };
        }

        @clients = sort { $a->{mac} cmp $b->{mac} } @clients;

        return \@clients;
    }

    sub set_volume {
        my ( $self, $client, $volume ) = @_;

        my $results = $self->do_request(
            {
                'jsonrpc' => '2.0',
                'method'  => 'Client.SetVolume',
                'params'  => { 'client' => $client, 'volume' => int($volume) },

                #'id' => 1 # request id
            }
        );

        #print Dumper $results;
        return $results;
    }

}

true;
