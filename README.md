# NAME

Test::Mockingbird - Advanced mocking library for Perl with support for dependency injection and spies

# VERSION

Version 0.10

# SYNOPSIS

    use Test::Mockingbird;

    # Mocking
    Test::Mockingbird::mock('My::Module', 'method', sub { return 'mocked!' });

    # Spying
    my $spy = Test::Mockingbird::spy('My::Module', 'method');
    My::Module::method('arg1', 'arg2');
    my @calls = $spy->(); # Get captured calls

    # Dependency Injection
    Test::Mockingbird::inject('My::Module', 'Dependency', $mock_object);

    # Batch dependency injection
    inject_all('My::Module', {
        DB     => $mock_db,
        Logger => $mock_logger,
        Config => $mock_config,
    });

    # Unmocking
    Test::Mockingbird::unmock('My::Module', 'method');

    # Restore everything
    Test::Mockingbird::restore_all();

    # Call ordering
    spy 'A::fetch';
    spy 'B::process';
    A::fetch();
    B::process();
    assert_call_order('A::fetch', 'B::process');   # passes
    clear_call_log();                               # reset without uninstalling spies

    # Constructor interception
    my $stub = My::Service->new;   # normally builds a real object
    intercept_new 'My::Service' => $stub;
    my $obj = My::Service->new(name => 'test');   # returns $stub

    intercept_new 'My::Service' => sub {
        my ($class, %args) = @_;
        return My::Double->new(%args);            # factory coderef
    };

    restore_all();

# DESCRIPTION

Test::Mockingbird provides powerful mocking, spying, and dependency injection capabilities to streamline testing in Perl.

# DIAGNOSTICS

Test::Mockingbird provides optional, non-intrusive diagnostic routines
that allow inspection of the current mocking state during test execution.
These routines are purely observational. They do not modify any mocking
behaviour, symbol table entries, or internal state.

Diagnostics are useful when debugging complex test suites, verifying
mock layering behaviour, or understanding interactions between multiple
mocking primitives such as mock, spy, inject, and the sugar functions.

## diagnose\_mocks

Return a structured hashref describing all currently active mock layers.
Each entry includes the fully qualified method name, the number of active
layers, whether the original method existed, and metadata for each layer
(type and installation location). See the diagnose\_mocks method for full
API details.

## diagnose\_mocks\_pretty

Return a human-readable, multi-line string describing all active mock
layers. This routine is intended for debugging and inspection during test
development. The output format is stable for human consumption but is not
guaranteed for machine parsing. See the diagnose\_mocks\_pretty method for
full API details.

## Diagnostic Metadata

Diagnostic information is recorded automatically whenever a mock layer is
successfully installed. Each layer records:

    * type          The category of mock layer (for example: mock, spy,
                    inject, mock_return, mock_exception, mock_sequence,
                    mock_once, mock_scoped)

    * installed_at  The file and line number where the layer was created

This metadata is maintained in parallel with the internal mock stack and
is automatically cleared when a method is fully restored via unmock or
restore\_all.

Diagnostics never alter the behaviour of the mocking engine and may be
safely invoked at any point during a test run.

# DEBUGGING EXAMPLES

This section provides practical examples of using the diagnostic routines
to understand and debug complex mocking behaviour.
All examples are safe to run inside test files and do not modify mocking semantics.

## Example 1: Inspecting a simple mock

    {
        package Demo::One;
        sub value { 1 }
    }

    mock_return 'Demo::One::value' => 42;

    my $diag = diagnose_mocks();
    print diagnose_mocks_pretty();

The output will resemble:

    Demo::One::value:
      depth: 1
      original_existed: 1
      - type: mock_return   installed_at: t/example.t line 12

This confirms that the method has exactly one active mock layer and shows
where it was installed.

## Example 2: Stacked mocks

    {
        package Demo::Two;
        sub compute { 10 }
    }

    mock_return    'Demo::Two::compute' => 20;
    mock_exception 'Demo::Two::compute' => 'fail';

    print diagnose_mocks_pretty();

Possible output:

    Demo::Two::compute:
      depth: 2
      original_existed: 1
      - type: mock_return   installed_at: t/example.t line 8
      - type: mock_exception installed_at: t/example.t line 9

This shows the order in which layers were applied. The most recent layer
appears last.

## Example 3: Spies and injected dependencies

    {
        package Demo::Three;
        sub action { 1 }
        sub dep    { 2 }
    }

    spy 'Demo::Three::action';
    inject 'Demo::Three::dep' => sub { 99 };

    print diagnose_mocks_pretty();

Example output:

    Demo::Three::action:
      depth: 1
      original_existed: 1
      - type: spy           installed_at: t/example.t line 7

    Demo::Three::dep:
      depth: 1
      original_existed: 1
      - type: inject        installed_at: t/example.t line 8

This confirms that both the spy and the injected dependency are active.

## Example 4: After restore\_all

    mock_return 'Demo::Four::x' => 5;
    restore_all();

    print diagnose_mocks_pretty();

Output:

    (no output)

After restore\_all, all diagnostic metadata is cleared along with the
mock layers.

## Example 5: Using diagnostics inside a failing test

When a test fails unexpectedly, adding the following line can help
identify the active mocks:

    diag diagnose_mocks_pretty();

This prints the current mocking state into the test output without
affecting the test run.

# METHODS

## mock($package, $method, $replacement)

Mocks a method in the specified package.
Supports two forms:

    mock('My::Module', 'method', sub { ... });

or the shorthand:

    mock 'My::Module::method' => sub { ... };

If the original function carries a Perl prototype, the same prototype is
automatically applied to the replacement coderef before it is installed.
This prevents Perl from emitting `Prototype mismatch` warnings at call
sites that were compiled against the original signature. The canonical
case is functions declared with a `()` no-args prototype, such as
`I18N::LangTags::Detect::detect`. The replacement is almost always an
anonymous `sub {}` created for the mock, so mutating its prototype
in-place is safe.

If the original has no prototype, no prototype is imposed on the
replacement.

## unmock($package, $method)

Restores the original method for a mocked method.
Supports two forms:

    unmock('My::Module', 'method');

or the shorthand:

    unmock 'My::Module::method';

Because `mock` stores the original coderef (not a copy), reinstating it
via glob assignment also restores its prototype automatically. No explicit
prototype handling is required in `unmock`.

## mock\_scoped

Creates a scoped mock that is automatically restored when the returned guard
goes out of scope.

This behaves like `mock`, but instead of requiring an explicit call to
`unmock` or `restore_all`, all mocked methods are reverted automatically
when the guard object is destroyed.

### Single-method forms

Shorthand:

    # The return value must be assigned to a lexical variable.
    # If discarded, the guard object is destroyed immediately and the mock never takes effect.
    # When $g goes out of scope, all mocked methods are restored automatically.

    my $g = mock_scoped 'My::Module::method' => sub { 'mocked' };

Longhand:

    my $g = mock_scoped('My::Module', 'method', sub { ... });

### Multi-method forms

Mock several methods on one package with a single guard:

    my $g = mock_scoped('My::Module',
        fetch  => sub { 'mocked_fetch'  },
        save   => sub { 'mocked_save'   },
        delete => sub { 'mocked_delete' },
    );

Mock methods across different packages in one call (shorthand pairs):

    my $g = mock_scoped(
        'My::Module::fetch'  => sub { 'mocked_fetch'  },
        'Other::Module::save' => sub { 'mocked_save'  },
    );

In both multi-method forms, every mocked method is restored when `$g`
goes out of scope or is explicitly undefed.

### Scoped lifecycle

    {
        my $g = mock_scoped 'My::Module::method' => sub { 'mocked' };
        My::Module::method();   # returns 'mocked'
    }

    My::Module::method();       # original behaviour restored

### Interaction with spy

A `spy` is not automatically restored when a `mock_scoped` guard
goes out of scope. `mock_scoped` only manages the specific mock
layer it installs. If you install a spy inside a scoped block, you
must restore it explicitly:

    {
        my $g   = mock_scoped 'My::Module::method' => sub { 1 };
        my $spy = spy 'My::Module::method';

        My::Module->method('arg');
    }
    # $g is destroyed here -- the mock_scoped layer is restored
    # but the spy layer is still active

    restore_all();    # needed to fully restore method

The safe pattern when combining `mock_scoped` and `spy` is to
call `restore_all` at the end of the block, or to avoid combining
them and use `mock` with an explicit `restore_all` instead:

    spy 'My::Module::method';
    My::Module->method('arg');
    my @calls = $spy->();
    restore_all();

### Notes

If you need both a modified implementation and call recording in
the same test, install the spy first and then the mock. The spy
will still capture calls even when the implementation is replaced
by the mock layer above it, because the spy wraps the layer below
it at installation time, not the current top of the stack. To avoid
confusion, prefer explicit `restore_all` over `mock_scoped` when
combining with spies.

## spy($package, $method)

Wraps a method so that all calls and arguments are recorded.
Supports two forms:

    spy('My::Module', 'method');

or the shorthand:

    spy 'My::Module::method';

Returns a coderef which, when invoked, returns the list of captured calls.
The original method is preserved and still executed.

### Call record format

Each captured call is an arrayref with the following structure:

    [ $method_name, $invocant, @arguments ]

where:

- `$method_name` - the fully qualified method name as a string
(e.g. `'My::Module::method'`)
- `$invocant` - the first argument to the call, typically `$self`
for method calls or the first positional argument for function calls
- `@arguments` - the remaining arguments passed to the method,
in the order they were supplied.
For named-parameter calls,
these will be alternating key/value pairs suitable for assignment to a hash:
`my %args = @{$call}[2..$#{$call}]`

### Example

    spy 'My::Module::process';
    My::Module->process(name => 'foo', value => 42);

    my @calls = $spy->();
    my $call  = $calls[0];

    # $call->[0] eq 'My::Module::process'
    # $call->[1] is the My::Module object
    # @{$call}[2..$#{$call}] gives (name => 'foo', value => 42)

    my %args = @{$call}[2..$#{$call}];
    is($args{name},  'foo', 'name arg captured');
    is($args{value}, 42,    'value arg captured');

### Limitations

`spy` installs its wrapper coderef directly into the glob without going
through `mock`, so the prototype-preservation logic in `mock` does not apply.
If the target function carries a Perl prototype (for example, a
`()` no-args prototype), installing a spy will emit a
`Prototype mismatch` warning.

If you need warning-free wrapping of a prototyped function, install the
spy on a non-prototyped alias, or use `mock` with a wrapper that records
calls and delegates to the original:

    my @calls;
    mock 'My::Module::detect' => sub {
        push @calls, [@_];
        return My::Module::_real_detect(@_);   # delegate manually
    };

This limitation will be addressed in a future release.

## inject($package, $dependency, $mock\_object)

Injects a mock dependency. Supports two forms:

    inject('My::Module', 'Dependency', $mock_object);

or the shorthand:

    inject 'My::Module::Dependency' => $mock_object;

The injected dependency can be restored with `restore_all` or `unmock`.

## inject\_all($package, \\%dependencies)

Inject multiple mock dependencies into a package in a single call.

    inject_all('My::Service', {
        DB     => $mock_db,
        Logger => $mock_logger,
        Config => $mock_config,
    });

This is equivalent to calling `inject` once per key/value pair:

    inject 'My::Service::DB'     => $mock_db;
    inject 'My::Service::Logger' => $mock_logger;
    inject 'My::Service::Config' => $mock_config;

Every injected dependency is tracked by the usual mock stack and is
restored automatically by `restore_all()` or individually by
`unmock('My::Service::DB')` etc.

### API specification

#### Input (Params::Validate::Strict schema)

\- `$package`: required, scalar string; the package into which dependencies
  are injected
\- `\%dependencies`: required, hashref; keys are dependency names (bare,
  without package prefix), values are the objects or values to inject

An empty hashref is accepted and has no effect.

#### Output (Returns::Set schema)

\- `return`: undef

### Example

    {
        package My::UserService;
        sub DB     { }   # normally returns a real DB handle
        sub Logger { }   # normally returns a real logger
    }

    inject_all('My::UserService', {
        DB     => $mock_db,
        Logger => $mock_logger,
    });

    # My::UserService::DB()     now returns $mock_db
    # My::UserService::Logger() now returns $mock_logger

    restore_all();   # both restored in one call

## restore\_all

Restores all mocked methods and injected dependencies.

Called with no arguments, restores everything that has been mocked
in the current test run:

    restore_all();

Called with a package name, restores only the mocks whose fully
qualified names begin with that package:

    restore_all 'My::Module';

This is useful when a test installs mocks across multiple packages
and needs to tear down only one package's mocks without disturbing
the others:

    mock 'My::Module::fetch'   => sub { 'mocked_fetch' };
    mock 'Other::Module::save' => sub { 'mocked_save'  };

    # Tear down only My::Module mocks
    restore_all 'My::Module';

    # Other::Module::save is still mocked here
    restore_all();    # now everything is restored

### Notes

Restoring a package that was never mocked is a no-op and does not
warn or croak.

## mock\_return

Mock a method so that it always returns a fixed value.

Takes a single target (either `'Pkg::method'` or `('Pkg','method')`) and
a value to return. Returns nothing. Side effects: installs a mock layer
using `mock`.

### API specification

#### Input

Params::Validate::Strict schema:

\- `target`: required, scalar, string; method target in shorthand or longhand form
\- `value`: required, any type; value to be returned by the mock

#### Output

Returns::Set schema:

\- `return`: undef

## mock\_exception

Mock a method so that it always throws an exception.

Takes a single target (either `'Pkg::method'` or `('Pkg','method')`) and
an exception message. Returns nothing. Side effects: installs a mock layer
using `mock`.

### API specification

#### Input

Params::Validate::Strict schema:

\- `target`: required, scalar, string; method target in shorthand or longhand form
\- `message`: required, scalar, string; exception text to `croak` with

#### Output

Returns::Set schema:

\- `return`: undef

## mock\_sequence

Mock a method so that it returns a sequence of values over successive calls.

Takes a single target (either `'Pkg::method'` or `('Pkg','method')`) and
one or more values. Returns nothing. Side effects: installs a mock layer
using `mock`. When the sequence is exhausted, the last value is repeated.

### API specification

#### Input

Params::Validate::Strict schema:

\- `target`: required, scalar, string; method target in shorthand or longhand form
\- `values`: required, array; one or more values to be returned in order

#### Output

Returns::Set schema:

\- `return`: undef

## mock\_once

Install a mock that is executed exactly once. After the first call, the
previous implementation is automatically restored. This is useful for
testing retry logic, fallback behaviour, and state transitions.

### API specification

#### Input (Params::Validate::Strict schema)

\- `target`: required, scalar, string; method target in shorthand or longhand form
\- `code`: required, coderef; mock implementation to run once

#### Output (Returns::Set schema)

\- `return`: undef

## intercept\_new

Intercept the `new` constructor of a class so that every call returns a
controlled value instead of a real instance.

    # Return the same pre-built object on every call
    intercept_new 'My::Service' => $mock_obj;
    my $a = My::Service->new;          # $mock_obj
    my $b = My::Service->new(id => 1); # $mock_obj (same instance every time)

    # Use a factory coderef (receives all original arguments, including the class name)
    intercept_new 'My::Service' => sub {
        my ($class, %args) = @_;
        return My::Double->new(%args);
    };

    restore_all();   # or:  unmock 'My::Service::new'

This is a thin wrapper around `mock`. The same mock stack semantics apply:
`restore_all()` and `unmock('My::Service::new')` both work, and multiple
interceptors can be stacked and peeled in LIFO order. `diagnose_mocks()`
records the layer with type `intercept_new`.

### API specification

#### Input (Params::Validate::Strict schema)

\- `$class`: required, scalar string; the package whose `new` method to
  intercept
\- `$factory`: required; either a coderef (called with the original arguments
  including the invocant class name) or any other value (returned verbatim
  on every call); may be `undef`

#### Output (Returns::Set schema)

\- `return`: undef

### Notes

When `$class` does not define its own `new` (relying instead on an inherited
one from a parent class or `UNIVERSAL`), `intercept_new` still works: it
installs the replacement directly into `$class`'s own stash. On restore,
the captured inherited coderef is reinstalled in the stash rather than being
removed, which may leave a redundant entry. Call `restore_all()` to clean up.

## restore

Restore all mock layers for a single method target. This is similar to
`restore_all`, but applies only to one method. If the method was never
mocked, this routine has no effect.

### API specification

#### Input (Params::Validate::Strict schema)

\- `target`: required, scalar, string; method target in shorthand or longhand form

#### Output (Returns::Set schema)

\- `return`: undef

## assert\_call\_order

Assert that the named methods were called in the given left-to-right order.

    assert_call_order('A::fetch', 'B::process', 'C::save');

Each argument must be a fully-qualified method name previously wrapped with
`spy()`. The check scans the internal call log for the named methods in
sequence. Intervening calls to other methods are ignored, so only the
relative order of the named methods is verified.

Produces one TAP `ok` or `not ok` line and returns a boolean.

Fails (with a diagnostic message) if:

- any named method was never called
- the observed order does not match the declared order

The call log is populated by `spy()` and cleared by `restore_all()` or
`clear_call_log()`. Plain `mock()` calls do not write to the log;
install a spy on any method whose ordering you need to verify.

### API specification

#### Input (Params::Validate::Strict schema)

\- `@methods`: required; two or more fully-qualified method name strings

#### Output (Returns::Set schema)

\- `return`: boolean; true if the order matched, false otherwise

### Example

    {
        package Pipeline;
        sub open  { 1 }
        sub run   { 1 }
        sub close { 1 }
    }

    spy 'Pipeline::open';
    spy 'Pipeline::run';
    spy 'Pipeline::close';

    Pipeline::open();
    Pipeline::run();
    Pipeline::close();

    assert_call_order('Pipeline::open', 'Pipeline::run', 'Pipeline::close');

    restore_all();

## clear\_call\_log

Clear the call-order log without restoring any mocks or spies.

Normally the log is cleared automatically by `restore_all()`. Call this
when you want to reset ordering state between phases of a single test
without tearing down the installed spies.

    spy 'A::fetch';
    spy 'B::process';

    # phase 1
    A::fetch();
    B::process();
    assert_call_order('A::fetch', 'B::process');

    clear_call_log();   # reset, spies still active

    # phase 2
    B::process();
    A::fetch();
    # assert_call_order would now fail because B came first in phase 2

    restore_all();      # also clears the log

### API specification

#### Input (Params::Validate::Strict schema)

\- none

#### Output (Returns::Set schema)

\- `return`: undef

## diagnose\_mocks

Return a structured hashref describing all currently active mock layers.
This routine is purely observational and does not modify any state.

### API specification

#### Input

Params::Validate::Strict schema:

\- none

#### Output

Returns::Set schema:

\- `return`: hashref; keys are fully qualified method names, values are
  hashrefs containing:
  - `depth`: integer; number of active mock layers
  - `layers`: arrayref of hashrefs; each layer has:
      - `type`: string
      - `installed_at`: string
  - `original_existed`: boolean

## diagnose\_mocks\_pretty

Return a human-readable string describing all currently active mock layers.
This routine is purely observational and does not modify any state.

### API specification

#### Input

Params::Validate::Strict schema:

\- none

#### Output

Returns::Set schema:

\- `return`: scalar string; formatted multi-line description of all active
  mock layers, including:
  - fully qualified method name
  - depth (number of active layers)
  - whether the original method existed
  - each layer's type and installation location

### Behaviour

#### Entry

\- No arguments are accepted.

#### Exit

\- Returns a formatted string describing the current mocking state.

#### Side effects

\- None. This routine does not modify `%mocked`, `%mock_meta`, or any
  symbol table entries.

#### Notes

\- This routine is intended for debugging and diagnostics. It is safe to
  call at any point during a test run.
\- The output format is stable and suitable for human inspection, but not
  guaranteed to remain fixed for machine parsing.

## DESTROY

If `Test::Mockingbird` goes out of scope, restore everything.

# SUPPORT

This module is provided as-is without any warranty.

Please report any bugs or feature requests to `bug-test-mockingbird at rt.cpan.org`,
or through the web interface at
[http://rt.cpan.org/NoAuth/ReportBug.html?Queue=Test-Mockingbird](http://rt.cpan.org/NoAuth/ReportBug.html?Queue=Test-Mockingbird).
I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.

You can find documentation for this module with the perldoc command.

    perldoc Test::Mockingbird

# AUTHOR

Nigel Horne, `<njh at nigelhorne.com>`

# BUGS

# SEE ALSO

- [Test Dashboard](https://nigelhorne.github.io/Test-Mockingbird/coverage/)
- [Test::Mockingbird::DeepMock](https://metacpan.org/pod/Test%3A%3AMockingbird%3A%3ADeepMock)
- [Test::Mockingbird::TimeTravel](https://metacpan.org/pod/Test%3A%3AMockingbird%3A%3ATimeTravel)

# REPOSITORY

[https://github.com/nigelhorne/Test-Mockingbird](https://github.com/nigelhorne/Test-Mockingbird)

# SUPPORT

This module is provided as-is without any warranty.

# LICENCE AND COPYRIGHT

Copyright 2025-2026 Nigel Horne.

Usage is subject to GPL2 licence terms.
If you use it,
please let me know.
