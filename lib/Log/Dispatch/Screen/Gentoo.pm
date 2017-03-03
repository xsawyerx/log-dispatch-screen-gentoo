package Log::Dispatch::Screen::Gentoo;
# ABSTRACT: Gentoo-colored screen logging output

use strict;
use warnings;
use parent 'Log::Dispatch::Screen';
use Encode ();
use Module::Runtime qw< require_module >;
use Term::GentooFunctions ':all';

## no critic qw(Modules::RequireExplicitInclusion)
my $encode
    = require_module('Unicode::UTF8')
    ? sub { Unicode::UTF8::encode_utf8( $_[0] ) }
    : sub { Encode::encode_utf8( $_[0] ) };

# einfo
# ewarn
# eerror
# equiet
# ebegin
# eend

our %FUNCTION_MAP = (
    ''          => sub { einfo( $_[0] )  },
    'debug'     => sub { einfo( $_[0] )  },
    'info'      => sub { einfo( $_[0] )  },
    'notice'    => sub { einfo( $_[0] )  },
    'warning'   => sub { ewarn( $_[0] )  },
    'error'     => sub { eerror( $_[0] ) },
    'critical'  => sub { eerror( $_[0] ) },
    'alert'     => sub { eerror( $_[0] ) },
    'emergency' => sub { eerror( $_[0] ) },
);

sub log_message {
    my ( $self, %p ) = @_;

    my $level = $p{'level'};

    my $message
        = $self->{'utf8'}
        ? $encode->( $p{'message'} )
        : $encode->( $p{'message'} );

    my $print_func = $FUNCTION_MAP{$level} //= $FUNCTION_MAP{''};

    if ( $self->{'stderr'} ) {
        # Should be STDERR
        $print_func->($message);
    } else {
        # Should be STDOUT
        $print_func->($message);
    }
}

1;
