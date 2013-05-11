package SessionTest;
use Mojo::Base 'Mojolicious';
use Plack::Session::Store::File;
use Mojolicious::Sessions::Storable;

# This method will run once at server start
sub startup {
    my $self = shift;

    # Documentation browser under "/perldoc"
    $self->plugin('PODRenderer');

    my $conf = $self->plugin( 'Config', { file => 'conf/config.conf' } );

    # Session store
    my $sessions =
      Mojolicious::Sessions::Storable->new(
        session_store => Plack::Session::Store::File->new( dir => 'file' ) );
    $sessions = $sessions->cookie_domain( $conf->{session}{cookie_domain} )
      if $conf->{session}{cookie_domain};
    $sessions = $sessions->cookie_name( $conf->{session}{cookie_name} )
      if $conf->{session}{cookie_name};
    $sessions =
      $sessions->default_expiration( $conf->{session}{default_expiration} )
      if $conf->{session}{default_expiration};
    $self->app->sessions($sessions);

    # OAuth (Twitter)
    $self->plugin(
        'Web::Auth',
        module      => 'Twitter',
        key         => $conf->{auth}{consumer_key},
        secret      => $conf->{auth}{consumer_secret},
        on_finished => sub {
            my ( $c, $token, $token_secret, $ref ) = @_;

            # update session id
            $c->session_options->{change_id}++;

            $c->session( 'user_id'   => $ref->{id} );
            $c->session( 'user_name' => $ref->{name} );
            $c->session( 'user_screen_name' => $ref->{screen_name} );
            $c->session( 'verified'  => 1 );
            return $c->redirect_to('/');
        },
        on_error => sub {
            my ( $c, $err ) = @_;

            return $c->redirect_to('/auth/login');
        },
    );

    $self->hook(
        before_dispatch => sub {
            my $self = shift;

            unless ( $self->req->url->path->contains('/auth') ) {
                unless ( $self->session('verified') ) {
                    return $self->redirect_to('/auth/login');
                }
            }

            # update session id
            $self->session_options->{change_id}++;
        }
    );

    # Router
    my $r = $self->routes;

    # Normal route to controller
    $r->any('/auth/login')->to('auth#login');
    $r->get('/auth/logout')->to('auth#logout');

    $r->get('/')->to('example#welcome');
}

1;
