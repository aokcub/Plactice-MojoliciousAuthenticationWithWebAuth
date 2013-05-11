package SessionTest::Example;
use Mojo::Base 'Mojolicious::Controller';

# This action will render a template
sub welcome {
    my $self = shift;

    unless ( $self->session('verified') ) {
        $self->redirect_to('/auth/login');
    }

    $self->stash(
        user_id => $self->session('user_id'));
    $self->stash(
        user_screen_name => $self->session('user_screen_name'));
    $self->stash(
        user_name => $self->session('user_name'));
    $self->render('welcome');
}

1;
