%%%-------------------------------------------------------------------
%%% @author Anton I Alferov <casper@ubca-dp>
%%% @copyright (C) 2013, Anton I Alferov
%%%
%%% Created: 21 May 2013 by Anton I Alferov <casper@ubca-dp>
%%%-------------------------------------------------------------------

-module(twitter_backend).
-compile(export_all).

-define(ApiUrl, "https://api.twitter.com/1.1").
-define(StatusesUrl, ?ApiUrl ++ "/statuses").
-define(MentionsTimelineUrl, ?StatusesUrl ++ "/mentions_timeline.json").
-define(UserTimelineUrl, ?StatusesUrl ++ "/user_timeline.json").

-define(MentionsTimelineParams, [
]).
-define(UserTimelineParams(ScreenName), [
	{"screen_name", ScreenName}
]).

mentions_timeline(OAuth) ->
	statuses(?MentionsTimelineUrl, ?MentionsTimelineParams, OAuth).

user_timeline(ScreenName, OAuth) ->
	statuses(?UserTimelineUrl, ?UserTimelineParams(ScreenName), OAuth).

statuses(Url, Params, OAuth) ->
	read_response(httpc:request(get, {utils_http:url(Url, Params),
		[oauth:auth_header(get, Url, Params, OAuth)]}, [], [])).

read_response({ok, {{_, 200, _}, _, Body}}) -> {ok, read_body(Body)};
read_response({ok, {{_, Code, Reason}, _, Body}}) ->
	{error, {{Code, Reason}, read_body(Body)}};
read_response(Error) -> Error.

read_body(Body) ->
	BodyBinary = list_to_binary(Body),
	case jsx:is_json(BodyBinary) of
		true -> jsx:decode(BodyBinary, [{labels, atom}]);
		_ -> BodyBinary
	end.
