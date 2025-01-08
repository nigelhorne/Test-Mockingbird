package Test::Mockingbird;

use strict;
use warnings;

our $VERSION = '0.01';

use Carp qw(croak);

# Store mocked data
my %mocked;

sub mock {
    my ($package, $method, $replacement) = @_;
    croak 'Package and method are required for mocking' unless $package && $method;

    no strict 'refs'; # Allow symbolic references
    my $full_method = "${package}::$method";

    # Backup the original method
    $mocked{$full_method} = \&{$full_method} unless exists $mocked{$full_method};

    # Replace with mocked version
	no warnings 'redefine';
    *{$full_method} = $replacement || sub {};
}

sub unmock {
    my ($package, $method) = @_;
    croak "Package and method are required for unmocking" unless $package && $method;

    no strict 'refs';
    my $full_method = "${package}::$method";

    # Restore original method if backed up
    if (exists $mocked{$full_method}) {
	no warnings 'redefine';
        *{$full_method} = $mocked{$full_method};
        delete $mocked{$full_method};
    }
}

sub spy {
    my ($package, $method) = @_;
    croak "Package and method are required for spying" unless $package && $method;

    no strict 'refs';
    no warnings 'redefine';

    my $full_method = "${package}::$method";

    # Backup the original method
    $mocked{$full_method} = \&{$full_method} unless exists $mocked{$full_method};

    # Spy data
    my @calls;

    # Wrap the original method in a spy
    *{$full_method} = sub {
        push @calls, [@_];
        return $mocked{$full_method}->(@_);
    };

    return sub {
        return @calls; # Return all captured calls
    };
}

sub inject {
    my ($package, $dependency, $mock_object) = @_;
    croak "Package and dependency are required for injection" unless $package && $dependency;

    no strict 'refs';
    no warnings 'redefine';

    my $full_dependency = "${package}::$dependency";

    # Backup the original dependency
    $mocked{$full_dependency} = \&{$full_dependency} unless exists $mocked{$full_dependency};

    # Replace with the mock object
    *{$full_dependency} = sub { return $mock_object };
    # *{$full_dependency} = $mock_routine;
}

sub restore_all {
    # Restore all mocked methods and dependencies
    no strict 'refs';
    no warnings 'redefine';

    for my $full_method (keys %mocked) {
        *{$full_method} = $mocked{$full_method};
    }

    %mocked = ();
}

1;

__END__

=head1 NAME

Test::Mockingbird - Advanced mocking library for Perl with support for dependency injection and spies.

=head1 SYNOPSIS

  use Test::Mockingbird;

  # Mocking
  Test::Mockingbird::mock('My::Module', 'method', sub { return "mocked!" });

  # Spying
  my $spy = Test::Mockingbird::spy('My::Module', 'method');
  My::Module::method("arg1", "arg2");
  my @calls = $spy->(); # Get captured calls

  # Dependency Injection
  Test::Mockingbird::inject('My::Module', 'Dependency', $mock_object);

  # Unmocking
  Test::Mockingbird::unmock('My::Module', 'method');

  # Restore everything
  Test::Mockingbird::restore_all();

=head1 DESCRIPTION

Test::Mockingbird provides powerful mocking, spying, and dependency injection capabilities to streamline testing in Perl.

=head1 METHODS

=over 4

=item mock($package, $method, $replacement)

Mocks a method in the specified package.

=item spy($package, $method)

Spies on a method, tracking calls and arguments.

=item inject($package, $dependency, $mock_object)

Injects a mock object for a dependency.

=item unmock($package, $method)

Restores the original method for a mocked method.

=item restore_all()

Restores all mocked methods and dependencies to their original state.

=back
