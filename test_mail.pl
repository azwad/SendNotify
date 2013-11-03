#!/usr/bin/perl 
use strict;
use warnings;
use feature qw( say );
use utf8;
use Encode;
use Pause;
use SendNotify;


my $from = 'xxx@gmail.com';
my $to = 'xxx@i.softbank.jp';
my $password = 'xxxxxxx';
my $pit_account = 'xxxxx';

my $mail = SendNotify->new();

my $sub = "test from $from via smtp";
my $message = "SMTPによる送信テスト";
$mail->post($from, $to, $sub, $message);


my $sub2 = "test from $from via Gmail";
my $message2 = "Gmailによる送信テスト";
$mail->post_gmail($from, $to, $sub2, $message2, $password);

my $message3 = 'twitterによる通知テスト';
$mail->tweet($message3, $pit_account);

say "test end";
