# Scripts
renamer.py

	Run script with path to folder  as argument, will rename all subfolders
	to remove all underscores and replace with spaces - but multiple will
	only be replaced with one space.

weather.sh

	Modification of r3donnx's script to run weather information as widget
	on Mac touchbar using Better Touch Tool. This version reads plaintext
	rather than XML, because the source XML is now plaintext (for some reason?)

AIFinder.rb

	Input starting H(Y) and sample size, returns H(Y|X=x) for each option and
	I(Y|X=x) for each sample group.

recommender.rb

	Uses MSD and Pearson Correlation as similarity metrics, and Resnick's to
	guess a rating for a user based on those metrics. Can change user-item
	matrix but the main script sets that up and runs it for user 5, item 3.
