#########################

use strict;
use Test::More;
BEGIN { plan tests => 12 };
use Math::FitRect qw( fit_rect crop_rect );

ok( 1, 'Module loaded fine.' );
my( $rect, $rect1, $rect2 );

#-------------------------------------------------------------------------------

$rect = Math::FitRect::_normalize(20);
ok((
	$rect->{w}==20 and 
	$rect->{h}==20 and 
	$rect->{r}==1
), 'Normalize a scalar square.' );

$rect = Math::FitRect::_normalize([11,22]);
ok((
	$rect->{w}==11 and 
	$rect->{h}==22 and 
	$rect->{r}==0.5
), 'Normalize a array ref rectangle.' );

$rect = Math::FitRect::_normalize( {w=>14,h=>5} );
ok((
	$rect->{w}==14 and 
	$rect->{h}==5 and 
	$rect->{r}==2.8
), 'Normalize a hash ref rectangle.' );

#-------------------------------------------------------------------------------

$rect = fit_rect( 10 => 5 );
ok((
	$rect->{w}==5 and 
	$rect->{h}==5 and
	$rect->{x}==0 and 
	$rect->{y}==0
), 'Fit a larger square in to a smaller square.' );

$rect = fit_rect( 2 => 7 );
ok((
	$rect->{w}==7 and 
	$rect->{h}==7 and
	$rect->{x}==0 and 
	$rect->{y}==0
), 'Fit a smaller square in to a larger square.' );

$rect = fit_rect( [10,5] => [8,8] );
ok((
	$rect->{w}==8 and 
	$rect->{h}==4 and
	$rect->{x}==0 and 
	$rect->{y}==2
), 'Fit a larger rectangle in to a smaller rectangle.' );

$rect = fit_rect( [7,6] => [10,14] );
ok((
	$rect->{w}==10 and 
	$rect->{h}==9 and
	$rect->{x}==0 and 
	$rect->{y}==3
), 'Fit a smaller rectangle in to a larger rectangle.' );

#-------------------------------------------------------------------------------

$rect = crop_rect( 10 => 5 );
ok((
	$rect->{w}==5 and 
	$rect->{h}==5 and
	$rect->{x}==0 and 
	$rect->{y}==0
), 'Fit a larger square in to a smaller square.' );

$rect = crop_rect( 2 => 7 );
ok((
	$rect->{w}==7 and 
	$rect->{h}==7 and
	$rect->{x}==0 and 
	$rect->{y}==0
), 'Fit a smaller square in to a larger square.' );

$rect = crop_rect( [10,5] => [8,8] );
ok((
	$rect->{w}==16 and 
	$rect->{h}==8 and
	$rect->{x}=-3 and 
	$rect->{y}==0
), 'Fit a larger rectangle in to a smaller rectangle.' );

$rect = crop_rect( [7,6] => [10,14] );
ok((
	$rect->{w}==16 and 
	$rect->{h}==14 and
	$rect->{x}==-2 and 
	$rect->{y}==0
), 'Fit a smaller rectangle in to a larger rectangle.' );

#-------------------------------------------------------------------------------

#print "w:$rect->{w} h:$rect->{h} x:$rect->{x} y:$rect->{y} r:$rect->{r}\n";

