# vim:noet
package Math::FitRect;
#-------------------------------------------------------------------------------

=head1 NAME

Math::FitRect - Resize one rect in to another while preserving aspect ratio.

=head1 SYNOPSIS

  use Math::FitRect;
  
  # This will return: {w=>40, h=>20, x=>0, y=>10}
  my $rect = fit_rect( [80,40] => 40 );
  
  # This will return: {w=>80, h=>40, x=>-19, y=>0}
  my $rect = crop_rect( [80,40] => 40 );

=head1 DESCRIPTION

=cut

#-------------------------------------------------------------------------------
use warnings;
use strict;
use Carp;

our $VERSION = '0.01';

require Exporter;
our @ISA = qw(Exporter);
our @EXPORT_OK = qw(
	fit_rect
	crop_rect
);
#-------------------------------------------------------------------------------

=head1 RECT TYPE

When a method needs a rectangle type it can be in one of the following forms:

	1) $size
	This is a single scalar holding an unsigned integer that specifys a square.
  
	2) [ $w, $h ]
	An array ref with the first entry being the width and the second the height.
  
  3) { w=>$w, h=>$h }
  Hash ref.

=head1 METHODS

The $rect1 and $rect2 in the proceding examples will use the 
following:

    $rect1 = [20,10];               $rect2 = [40,8];
  ....................
  .                  .   ........................................
  .                  .   .                                      .
  .                  .   .                                      .
  .                  .   .                                      .
  .                  .   .                                      .
  .                  .   .                                      .
  .                  .   .                                      .
  .                  .   ........................................
  ....................

=head2 fit_rect

  my $new_rect1 = fit_rect( $rect1 => $rect2 );

  { w=>16, h=>8, x=>12, y=>0 } = $new_rect1;
  ............----------------............
  .           |              |           .
  .           |              |           .
  .           |              |           .
  .           |              |           .
  .           |              |           .
  .           |              |           .
  ............----------------............

Takes two rectangles and fits the first one inside the second one.  The rectangle 
that will be returned will be a hash ref with a 'w' and 'h' parameter as well 
as 'x' and 'y' parameters which will specify any offset.

=cut

#-------------------------------------------------------------------------------
sub fit_rect {
	return _calc_rect('fit',@_);
}
#-------------------------------------------------------------------------------

=head2 crop_rect

  my $new_rect1 = crop_rect( $rect1 => $rect2 );

  { w=>40, h=>20, x=>0, y=>-6 } = $new_rect1;
  ----------------------------------------
  |                                      |
  |                                      |
  |                                      |
  |                                      |
  |                                      |
  ........................................
  .                                      .
  .                                      .
  .                                      .
  .                                      .
  .                                      .
  .                                      .
  ........................................
  |                                      |
  |                                      |
  |                                      |
  |                                      |
  |                                      |
  ----------------------------------------

Like the fit_rect function, crop_rect takes two rectangles as a parameter and it 
makes $rect1 completely fill $rect2.  This can mean that the top and bottom (as 
in the diagram above) or the left and right get "chopped" off, or cropped as it 
is usually called.  This method returns a has just like fit_rect.

=cut

#-------------------------------------------------------------------------------
sub crop_rect {
	return _calc_rect('crop',@_);
}
#-------------------------------------------------------------------------------

=head1 PRIVATE METHODS

Do not use these methods directly as there is no garauntee that they work as 
documented or that they will work the same in future versions.

=head2 _calc_rect

  _calc_rect( $type, $from_rect, $to_rect );

=cut

#-------------------------------------------------------------------------------
sub _calc_rect {
	my($type,$from,$to) = @_;
	$from = _normalize($from);
	$to = _normalize($to);
	my($w,$h,$x,$y);
	if($type eq 'crop'){ ($to->{r},$from->{r}) = ($from->{r},$to->{r}); }
	
	if($from->{r} < $to->{r}){
		$w = $from->{w} * ($to->{h}/$from->{h});
		$h = $to->{h};
		$x = ($to->{w}-$w)/2;
		$y = 0;
	}else{
		$h = $from->{h} * ($to->{w}/$from->{w});
		$w = $to->{w};
		$y = ($to->{h}-$h)/2;
		$x = 0;
	}
	
	return {w=>int($w+0.5),h=>int($h+0.5),x=>int($x+0.5),y=>int($y+0.5)};
}
#-------------------------------------------------------------------------------

=head2 _normalize

  $rect = _normalize( $rect );

Take in a rect in any of the supported formats and returns a hash ref with 
the following keys:

  w - Width.
  h - Height.
  r - Aspect ratio. (w/h)

=cut

#-------------------------------------------------------------------------------
sub _normalize {
	my $rect = shift;
	my($w,$h,$r);
	if(!ref($rect)){ # square
		$w = $h = $rect;
	}elsif(ref($rect) eq 'HASH'){ # rect hash ref
		$w = $rect->{w};
		$h = $rect->{h};
	}elsif(@$rect==2){ # width, height
		$w = $rect->[0];
		$h = $rect->[1];
	}elsif(@$rect==4){ # x1, y1, x2, y2
		if($rect->[0]<$rect->[2]){ $w=($rect->[2]-$rect->[0])+1; }
		else{ $w=($rect->[0]-$rect->[2])+1; }
		if($rect->[1]<$rect->[3]){ $h=($rect->[3]-$rect->[1])+1; }
		else{ $h=($rect->[1]-$rect->[3])+1; }
	}else{
		croak('Invalid rectangle parameter');
	}
	$r = $w/$h;
	return {w=>$w,h=>$h,r=>$r};
}
#-------------------------------------------------------------------------------

=head1 AUTHOR

Copyright (C) 2005 Aran Clary Deltac (CPAN: BLUEFEET)

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself. 

Address bug reports and comments to: E<lt>aran@arandeltac.comE<gt>. When sending bug reports, 
please provide the version of Geo::Distance, the version of Perl, and the name and version of the 
operating system you are using.  Patches are welcome if you are brave!

=cut

#-------------------------------------------------------------------------------
1;
