#! /usr/bin/perl

use warnings;
use strict;

use Todotxt::Recurlist;
use Data::Dumper;

if ((@ARGV > 0) && ($ARGV[0] eq 'usage'))
  {
      print "  Recurring tasks:\n" .
	"    recur\n" .
	"      insert appropriate recurring tasks from $ENV{TODO_DIR}/recur.txt\n" .
	"\n";
      exit(0);
  }

if (! defined $ENV{TODO_FILE})
  {
      die "TODO_FILE environment variable not found\n";
  }
if (! defined $ENV{TODO_DIR})
  {
      die "TODO_DIR environment variable not found\n";
  }
if (! defined $ENV{TODO_SH})
  {
      die "TODO_SH environment variable not found\n";
  }

my $todofile = $ENV{TODO_FILE};
my $recurfile = $ENV{TODO_DIR} . '/recur.txt';

my @todoin = ();
my @recur = ();

open(INF, "<", $todofile) or die "Unable to open $todofile: $?";

while (<INF>)
  {
      my $line = $_;
      chomp $line;

      push @todoin, $line;
  }

close INF;

open(INF, "<", $recurfile) or die "Unable to open $recurfile: $?";

while (<INF>)
  {
      my $line = $_;
      chomp $line;

      push @recur, $line;
  }

close INF;

my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime;

my $date = [$year + 1900, $mon + 1, $mday];

my $rl = Todotxt::Recurlist->new(\@todoin, \@recur);
my $adds = $rl->addList($date);

for my $add (@$adds)
  {
      my @args = ($ENV{TODO_SH}, "command", "add", $add);
      (system(@args) == 0) or die "system @args failed: $?";
  }
