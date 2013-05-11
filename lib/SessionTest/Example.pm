package SessionTest::Example;
use Mojo::Base 'Mojolicious::Controller';

sub welcome {
    my $self = shift;

    $self->stash(
        user_id => $self->session('user_id'));
    $self->stash(
        user_screen_name => $self->session('user_screen_name'));
    $self->stash(
        user_name => $self->session('user_name'));
    $self->render('welcome');
}

1;
