use ExtUtils::MakeMaker;

WriteMakefile(
	'NAME' => 'Math::FitRect',
	'VERSION_FROM' => 'FitRect.pm',
	'PREREQ_PM' => {},
	($] >= 5.005 ? (
		ABSTRACT_FROM => 'FitRect.pm',
		AUTHOR => 'Aran Clary Deltac <aran@arandeltac.com>'
	) : ()),
);
