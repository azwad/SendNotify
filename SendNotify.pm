package SendNotify;
use strict;
use warnings;
use utf8;
use Encode;
use Email::MIME;
use Email::MIME::Creator;
BEGIN {
    $Return::Value::NO_CLUCK = 1;
}
use Email::Send;
use Email::Send::Gmail;
use lib qw(/homet/toshi/perl/lib);
use feature qw(say);
use PostGooglePlus;
use Tweet;

sub new {
	my $proto = shift;
	my $class = ref $proto || $proto;
	my $self = {};
	bless $self, $class;
	return $self;
}

sub post {
	my $self = shift;
	my ($from,$to, $sub, $message) = @_;

	my $mail = Email::MIME->create(
		header => [
			From 		=> $from,
			To			=> $to,
			Subject => Encode::encode('MIME-Header-ISO_2022_JP', $sub),
		],
		body => encode('iso-2022-jp', $message),
	);

	my $sender = Email::Send->new({mailer => 'Sendmail'});
	eval {$sender->send($mail)};
	die "Error Sending Email : $@" if $@;
}

sub post_gmail {
	my $self = shift;
	my ($from,$to, $sub, $message, $password) = @_;

	my $mail = Email::MIME->create(
		header => [
			From 		=> $from,
			To			=> $to,
			Subject => Encode::encode('MIME-Header-ISO_2022_JP', $sub),
		],
		body => encode('iso-2022-jp', $message),
	);

	my $sender = Email::Send->new(
		{ mailer => 'Gmail',
			mailer_args => [
			username => $from,
			password => $password,
			]
		}
	);

	eval {$sender->send($mail)};
	die "Error Sending Email : $@" if $@;
}


sub post_gplus {
	my $self = shift;
	my $message = shift;
	my $pit_account =  'google_voie';
	my $gplus_post = PostGooglePlus->new('pit_account' => $pit_account);
	$gplus_post->compose($message);
	$gplus_post->post;
}

sub tweet {
	my $self = shift;
	my $message = shift;
	my $pit_account = shift;
	my $twitter = Tweet->new();
	$twitter->init( 
		{ pit_twitter => $pit_account,
			pit_bitly => 'bit.ly',
		}
	);
	my $url = '';
	$twitter->post_tweet($message, $url);
	until ($twitter->is_success){
		say $twitter->is_error;
	}
}


1;

