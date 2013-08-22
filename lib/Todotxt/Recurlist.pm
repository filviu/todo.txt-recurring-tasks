package Todotxt::Recurlist;

use strict;
use warnings;
use POSIX;

use Todotxt::Recur;
use DateTime;
use DateTime::Format::Duration;

sub new 
{
    my $this = shift;
    my $class = ref($this) || $this;
    my $self = {};

    bless $self, $class;
    $self->init(@_);

    return $self;
}

sub setDoneFile
{
  my( $self, $donefile ) = @_;
  $self->{DONEFILE} = $donefile;
}

sub init
{
    my ($self, $todolist, $recurlist) = @_;

    $self->{LIST} = $todolist;
    $self->{RECUR} = $recurlist;
}

sub getLastDoneDate
{
  my( $self, $recur ) = @_;
  return "" if !exists $self->{DONEFILE}; 
  my $cmd = "grep \"".$recur->{TASK}."\" ".$self->{DONEFILE}." | cut -d\" \" -f 2 | tail -n 1";
  return `$cmd`
}

sub addList
{
    my ($self, $date) = @_;
    my @candidates = ();
    my @toadd = ();

    for my $recur (@{ $self->{RECUR} })
    {
      my $rt = Todotxt::Recur->new($recur);

      if ($rt->matchDate($date))
      {
        push @candidates, $rt;
      }
    }

    # Now look at tasks that should happen after an interval
    for my $recur (@{ $self->{RECUR} })
    {
      my $rt = Todotxt::Recur->new($recur);
      if( $rt->{INTERVAL} > 0 ){
        my $ld = $self->getLastDoneDate( $rt );
        $ld =~ s/(^\s+|\s+$)//;
        if( $ld eq '' ){
          # No last date found
          push @candidates, $rt;
        }else{
          #Check last date
          my ( $y, $m, $d ) = split( '-', $ld );
          my $d1 = DateTime->new(
            year => $y,
            month => $m,
            day => $d
          );
          my $d2 = DateTime->now();
          my $diff = $d2->delta_days( $d1 )->delta_days;
          if( $diff >= $rt->{INTERVAL} ){
            push @candidates, $rt;
          }
        }
      }
    }

    for my $recur (@candidates)
      {
	  my $found = 0;

	  for my $task (@{ $self->{LIST} })
	    {
		if ($recur->sameTask($task))
		  {
		      $found = 1;
		      last;
		  }
	    }

	  if (! $found)
	    {
		push @toadd, $recur->task();
	    }
      }

    return \@toadd;
}

1;
