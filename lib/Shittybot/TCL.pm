#!/usr/bin/perl

package Shittybot::TCL;

use POE   qw/Wheel::Run/;
use Data::Dump  qw/ddx/;
use Shittybot::TCL::Child;
use Tcl;

sub spawn {
  my $class = shift;
  my $state = shift;
  my $self  = {};

  $self->{state}  = $state;

  bless ($self,$class);

  POE::Session->create(
    object_states => [
      $self => [qw/_start _tcl_in _tcl_out _tcl_chld/],
    ],
  );

  return $self;
}

sub _start {
  my $self  = $_[OBJECT];

  $self->{tcl}  = $self->load_state($self->{state});
}

sub _tcl_in {

}

sub _tcl_out {

}

sub _tcl_chld {

}

sub load_state {
  my $self      = shift;
  my $statepath = shift;

  my $tcl = Tcl->new;

  $tcl->Init;
  $tcl->CreateCommand('putlog',sub{ddx(@_)});
  $tcl->Eval("set smeggdrop_state_path $statepath");
  $tcl->EvalFile('smeggdrop.tcl');
  
  return $tcl;
}
1;