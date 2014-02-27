%%%-------------------------------------------------------------------
%%% Created: 21 May 2013 by Anton I Alferov <casper@ubca-dp>
%%%-------------------------------------------------------------------

{application, twitter, [
	{id, "twitter"},
	{vsn, "0.0.1"},
	{description, "Twitter API library"},
	{modules, [
		twitter,
		twitter_backend
	]},
	{registered, []},
	{applications, [kernel, stdlib, ssl, inets, utils, oauth]}
]}.
