requires 'perl', '5.008001';

requires 'Data::Monad';
requires 'Sub::Install';

on 'test' => sub {
    requires 'Test::Class';
    requires 'Test::More', '0.98';
};

