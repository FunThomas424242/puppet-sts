
node default {
  package { 'puppet-lint':
    ensure   => '1.1.0',
    provider => 'gem',
  }
  
  include sts
}

