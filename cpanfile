requires 'perl', '5.008001';

requires 'Class::Accessor::Lite';
requires 'Data::Monad';
requires 'Sub::Install';

on 'test' => sub {
    requires 'Test::Class';
    requires 'Test::More', '0.98';
};

