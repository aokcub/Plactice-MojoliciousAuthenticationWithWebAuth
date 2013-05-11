package SessionTest::Auth;
use Mojo::Base 'Mojolicious::Controller';

# This action will render a template

sub login {
    my $self = shift;

    if ( $self->req->method eq 'POST' ) {
        return $self->redirect_to( "/auth/twitter/authenticate" );
    }

    $self->render('login');
}

sub logout {
    my $self = shift;

    $self->session( expires => 1 );
    return $self->redirect_to('/auth/login');
}

1;

